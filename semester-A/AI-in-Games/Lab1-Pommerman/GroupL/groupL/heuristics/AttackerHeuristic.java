package players.groupL.heuristics;

import core.GameState;
import players.groupL.utils.BoardUtils;
import players.heuristics.StateHeuristic;
import utils.Types;
import utils.Vector2d;


public class AttackerHeuristic extends StateHeuristic {
    private Types.TILETYPE _targetEnemy;

    //The target enemy will be attacked
    public AttackerHeuristic(Types.TILETYPE targetEnemy) {
        this._targetEnemy = targetEnemy;
    }

    @Override
    public double evaluateState(GameState gs) {
        //System.out.println("AttackHeuristic");
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

        Vector2d enemyLocation;
        try {
            enemyLocation = boardUtils.LocateTileTypeWithinRadius(_targetEnemy, 6).get(0);
        } catch (Exception e) {
            return 0; // We probably lost the enemy
        }


        // Manhattan distance
        final var enemySearchArea = 2;

        // this variable is passable tiles not in range of bombs
        var emptySafeArea = boardUtils.GetEmptySafeAreaAround(enemyLocation, enemySearchArea);

        //floodFillArea is calculated using flood fill algorithm from the target position
        var floodFillArea = Math.round((enemySearchArea * 2 + 1) * (enemySearchArea * 2 + 1)/2)+1;

        //Attacker Score Function
        return 1 - emptySafeArea / floodFillArea;
    }


}
