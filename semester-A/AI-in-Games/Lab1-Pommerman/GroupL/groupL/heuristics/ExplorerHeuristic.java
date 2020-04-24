package players.groupL.heuristics;

import core.GameState;
import players.groupL.utils.BoardUtils;
import players.heuristics.StateHeuristic;
import utils.Types;
import utils.Vector2d;


import java.util.Arrays;

public class ExplorerHeuristic extends StateHeuristic {

    public ExplorerHeuristic(GameState gameState){
        GameState gs =  gameState;
    }
    public double evaluateState(GameState gs) {
        //System.out.println("evadeHeuristic");
        boolean gameOver = gs.isTerminal();
        if (gameOver) {
            Types.RESULT win = gs.winner();
            switch (win) {
                case LOSS:
                    return -1;
                case WIN:
                    return 1;
            }
        }

        BoardUtils boardUtils = new BoardUtils(gs);

        int radius = 6; // the agent explores within six Manhattan distances
        int distance = radius; //Manhattan distance between agent and the positive object

        var PositiveObjects = new Types.TILETYPE[]{ Types.TILETYPE.WOOD, Types.TILETYPE.EXTRABOMB,
                Types.TILETYPE.INCRRANGE, Types.TILETYPE.KICK};
        //obtain the positive object

        var board = gs.getBoard();
        var boardSize = gs.getBoard().length;
        var pos = gs.getPosition();
        var xStart = pos.x < radius ? 0 : pos.x - radius;
        var xEnd = Math.min(pos.x + radius, boardSize);
        var yStart = pos.y < radius ? 0 : pos.y - radius;
        var yEnd = Math.min(pos.y + radius, boardSize);

        //This part is used to find a target positive object and return the position of it
        for ( var x = xStart; x < xEnd; x++ ){
            if (distance != radius){
                break;
            }
            for ( var y = yStart; y < yEnd; y++ ) {
                int finalY = y;
                int finalX = x;
                int ManhattanDistance = Math.abs(pos.x - x) + Math.abs(pos.y - y);
                if(ManhattanDistance <= 6){
                    if (Arrays.stream(PositiveObjects).anyMatch(object -> object == board[finalY][finalX])){
                        Vector2d object = new Vector2d(finalX, finalY);
                        distance = boardUtils.GetManhattanDistanceBetween(pos, object);
                        break;
                    }
                }

            }
        }


        return 1 - distance / radius;
    }


}

