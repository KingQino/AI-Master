package players.groupL.utils;

import core.GameState;
import utils.Types;
import utils.Vector2d;

import java.util.ArrayList;
import java.util.Arrays;

public class BoardUtils {
    private GameState _gameState;

    public BoardUtils(GameState gameState) {
        this._gameState = gameState;
    }

    public int GetManhattanDistanceBetween(Vector2d a, Vector2d b) {

        return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
    }

    //EmptySafeArea is passable tiles not in range of bombs, excluding unreachable tiles due to walls
    //in the range of floodFillArea -- Within 2 Manhattan distance of the center
    public int GetEmptySafeAreaAround(Vector2d space, int radius) {
        var board = _gameState.getBoard();
        var boardSize = _gameState.getBoard().length;
        var xStart = space.x < radius ? 0 : space.x - radius;
        var xEnd = Math.min(space.x + radius, boardSize);
        var yStart = space.y < radius ? 0 : space.y - radius;
        var yEnd = Math.min(space.y + radius, boardSize);

        var tileLocations = new ArrayList<Vector2d>();

        var bombs = this.LocateTileTypeWithinRadius(space, Types.TILETYPE.BOMB, 5);

        var bombThreatArea = bombs.stream().flatMap(bomb -> Arrays.stream(this.BombThreatArea(bomb))).toArray();

        var impassableTiles = new Types.TILETYPE[]{Types.TILETYPE.WOOD, Types.TILETYPE.RIGID, Types.TILETYPE.FLAMES,
                Types.TILETYPE.AGENT0,Types.TILETYPE.AGENT1,Types.TILETYPE.AGENT2,Types.TILETYPE.AGENT3};

        var count = 0;

        for ( var x = xStart; x < xEnd; x++ )
        for ( var y = yStart; y < yEnd; y++ ) {
            int ManhattanDistance = Math.abs(space.x - x) + Math.abs(space.y - y);
            if (ManhattanDistance <= 2) {
                int finalY = y;
                int finalX = x;
                if (Arrays.stream(impassableTiles).anyMatch(tile -> tile != board[finalY][finalX])
                ||Arrays.stream(bombThreatArea).anyMatch(threat -> threat != new Vector2d(finalX,finalY))){
                    count++;
                }

            }
        }

        return count;
    }

    //Judging whether there is 'tileType' within the radius centered on the agent
    public boolean IsTileTypeWithinRadius(Types.TILETYPE tileType, int radius) {
        return this.IsTileTypeWithinRadius(this._gameState.getPosition(), tileType, radius);
    }
    public boolean IsTileTypeWithinRadius(Vector2d tile, Types.TILETYPE tileType, int radius) {
        var board = _gameState.getBoard();
        var boardSize = _gameState.getBoard().length;
        var xStart = tile.x < radius ? 0 : tile.x - radius;
        var xEnd = Math.min(tile.x + radius, boardSize);
        var yStart = tile.y < radius ? 0 : tile.y - radius;
        var yEnd = Math.min(tile.y + radius, boardSize);

        var tileLocations = new ArrayList<Vector2d>();

        for ( var x = xStart; x < xEnd; x++ )
        for ( var y = yStart; y < yEnd; y++ ) {
            if ( board[y][x] == tileType ) return true;
        }

        return false;
    }

    //Judging whether there is 'tileType' within the Manhattan Distance centered on the agent
    public boolean IsTileTypeWithinManhattanDistance(Types.TILETYPE tileType, int distance) {
        return this.IsTileTypeWithinManhattanDistance(this._gameState.getPosition(), tileType, distance);
    }
    public boolean IsTileTypeWithinManhattanDistance(Vector2d tile, Types.TILETYPE tileType, int distance) {
        var board = _gameState.getBoard();
        var boardSize = _gameState.getBoard().length;
        var xStart = tile.x < distance ? 0 : tile.x - distance;
        var xEnd = Math.min(tile.x + distance, boardSize);
        var yStart = tile.y < distance ? 0 : tile.y - distance;
        var yEnd = Math.min(tile.y + distance, boardSize);


        for ( var x = xStart; x < xEnd; x++ )
        for ( var y = yStart; y < yEnd; y++ ) {
            int d = Math.abs(tile.x - x) + Math.abs(tile.y - y);
            if (d <= distance) {
                if ( board[y][x] == tileType ) return true;
            }
        }


        return false;
    }

    //Find all the 'tileType'  within the range radius centered on the agent
    public ArrayList<Vector2d> LocateTileTypeWithinRadius(Types.TILETYPE tileType, int radius) {
        return this.LocateTileTypeWithinRadius(this._gameState.getPosition(), tileType, radius);
    }

    public ArrayList<Vector2d> LocateTileTypeWithinRadius(Vector2d tile, Types.TILETYPE tileType, int radius) {
        var board = _gameState.getBoard();
        var boardSize = _gameState.getBoard().length;
        var xStart = tile.x < radius ? 0 : tile.x - radius;
        var xEnd = Math.min(tile.x + radius, boardSize);
        var yStart = tile.y < radius ? 0 : tile.y - radius;
        var yEnd = Math.min(tile.y + radius, boardSize);

        var tileLocations = new ArrayList<Vector2d>();

        for ( var x = xStart; x < xEnd; x++ )
        for ( var y = yStart; y < yEnd; y++ ) {
            if ( board[y][x] == tileType )
                tileLocations.add(new Vector2d(x, y));
        }

        return tileLocations;
    }

    public int BombStrength(Vector2d bombPosition) {
        return _gameState.getBombBlastStrength()[bombPosition.y][bombPosition.x];
    }

    public int BombLife(Vector2d bombPosition) {
        return _gameState.getBombLife()[bombPosition.y][bombPosition.x];
    }

    //Find the area of the bomb
    private Vector2d[] BombThreatArea(Vector2d bombPosition) {
        var board = _gameState.getBoard();
        int bombStrength = _gameState.getBombBlastStrength()[bombPosition.y][bombPosition.x];

        //Dangerous places
        var threatArea = new ArrayList<Vector2d>();
        //The explosion range cannot pass through rigid and wood
        var passableBlocks = new Types.TILETYPE[]{Types.TILETYPE.RIGID, Types.TILETYPE.WOOD};

        //find the horizontal the positions of these dangerous places
        for( int horizontal : new int[]{-1, 1} ) {
            for(int i = 1; i <= bombStrength; i ++) {
                int xPos = bombPosition.x + (horizontal * i);
                if( xPos < 0 || xPos >= board.length
                        || Arrays.stream(passableBlocks).anyMatch(tileType -> tileType == board[bombPosition.y][xPos])
                ){
                    break;
                }

                threatArea.add(new Vector2d(bombPosition.x + horizontal * i, bombPosition.y));
            }
        }

        //find the vertical the positions of these dangerous places
        for( int vertical : new int[]{-1, 1} ) {
            for(int i = 1; i <= bombStrength; i ++) {
                int yPos = bombPosition.y + (vertical * i);
                if( yPos < 0 || yPos >= board.length
                        || Arrays.stream(passableBlocks).anyMatch(tileType -> tileType == board[yPos][bombPosition.x])
                ){
                    break;
                }

                threatArea.add(new Vector2d(bombPosition.x, bombPosition.y + vertical * i));
            }
        }

        return threatArea.toArray(Vector2d[]::new);
    }

    private boolean InRangeOfBomb(Vector2d bombPosition) {
        Vector2d myLocation = _gameState.getPosition();
        return Arrays.stream(BombThreatArea(bombPosition)).anyMatch(v -> v.equals(myLocation));
    }

    public boolean IsBombThreat(Vector2d bombPosition) {
        var y = bombPosition.y;
        var x = bombPosition.x;
        return _gameState.getBoard()[y][x] == Types.TILETYPE.BOMB
                && _gameState.getBombLife()[y][x] < 4 //不应是10，为4可能好些，若炸弹快爆炸了
                && this.InRangeOfBomb(bombPosition);  //Agent在炸弹能够威胁到的位置
    }
}
