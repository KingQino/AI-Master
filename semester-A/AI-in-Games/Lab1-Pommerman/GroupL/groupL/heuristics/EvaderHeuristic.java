package players.groupL.heuristics;

import core.GameState;
import players.groupL.utils.BoardUtils;
import players.heuristics.StateHeuristic;
import utils.Types;

public class EvaderHeuristic extends StateHeuristic {
    @Override
    public double evaluateState(GameState gs) {
        //System.out.println("evadeHeuristic");
        boolean gameOver = gs.isTerminal();
        if(gameOver){
            Types.RESULT win = gs.winner();
            switch(win){
                case LOSS:
                    return -1;
                case WIN:
                    return 1;
            }
        }

        BoardUtils boardUtils = new BoardUtils(gs);

        //Location of all bombs within the radius of 3 of the agent
        var bombs = boardUtils.LocateTileTypeWithinRadius(Types.TILETYPE.BOMB, 3);

        //Finding dangerous bombs in the bombs above
        var threateningBombs = bombs.stream().filter(bomb -> boardUtils.IsBombThreat(bomb));

        // Evader Score Function
        return 1 - threateningBombs.mapToDouble(bomb -> 0.25 * (11 - boardUtils.BombLife(bomb)/Types.BOMB_LIFE)/10).sum();

    }
}
