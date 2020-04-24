package players.groupL;

import core.GameState;
import players.Player;
import players.groupL.heuristics.AttackerHeuristic;
import players.groupL.heuristics.EvaderHeuristic;
import players.groupL.heuristics.ExplorerHeuristic;
import players.groupL.utils.BoardUtils;
import players.heuristics.*;
import players.optimisers.ParameterizedPlayer;
import utils.ElapsedCpuTimer;
import utils.Types;
import utils.Vector2d;
import players.groupL.mcts.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

public class HybridPlayer extends ParameterizedPlayer {
    private Random _random;
    private GameState _gameState;
    private BoardUtils _boardUtils;
    private Types.ACTIONS[] _actions;
    private MctsParams params;

    //variable for testing how many times the three Heuristics are run respectively
    //public static int[] count_Heuristic= new int[3];

    public HybridPlayer(long seed, int id) {
        this(seed, id, new MctsParams());
    }

    public HybridPlayer(long seed, int id, MctsParams params) {
        super(seed, id, params);
        reset(seed, id);

        ArrayList<Types.ACTIONS> actionsList = Types.ACTIONS.all();
        _actions = new Types.ACTIONS[actionsList.size()];
        int i = 0;
        for (Types.ACTIONS act : actionsList) {
            System.out.println(act);
            _actions[i++] = act;
        }
    }

    @Override
    public void reset(long seed, int playerID) {
        this.seed = seed;
        this.playerID = playerID;
        _random = new Random(seed);

        this.params = (MctsParams) getParameters();

    }

    @Override
    public Types.ACTIONS act(GameState gs) {
        ElapsedCpuTimer ect = new ElapsedCpuTimer();
        ect.setMaxTimeMillis(params.num_time);

        // update the Game state
        updateGameState(gs);

        // select a kind of Heuristic model
        var heuristic = this.getPlayerHeuristic();

        // Number of actions available
        int num_actions = _actions.length;

        // Root of the tree.  Compared with MCTS, it passes heuristic parameter
        SingleTreeNode m_root = new SingleTreeNode(params, gs, _random, num_actions, _actions, heuristic);
        //Determine the action using MCTS...
        m_root.mctsSearch(ect);

        //Determine the best action to take and return it.
        int action = m_root.mostValueAction();

        //... and return it.
        return _actions[action];
    }

    //This function selects one of the three heuristic methods, and the heuristic method is selected
    // when the corresponding condition is satisfied.
    private StateHeuristic getPlayerHeuristic() {

        if(inRangeOfBomb()) {
            return new EvaderHeuristic();
        }

        // When the agent has enough ammunition and the enemy is within 6 Manhattan distance, the agent considers attack
        if(bombCount() > 0 && enemyInRange(6)){
            return new AttackerHeuristic(getEnemyInRange(6));
        }

        return new ExplorerHeuristic(_gameState);
    }

    private boolean inRangeOfBomb() {
        ArrayList<Types.ACTIONS> directionsList = Types.ACTIONS.all();
        directionsList.remove(Types.ACTIONS.ACTION_BOMB);

        for (Types.ACTIONS direction: directionsList) {
            Vector2d dir = direction.getDirection().toVec();
            Vector2d pos = _gameState.getPosition();

            int x = pos.x + dir.x;
            int y = pos.y + dir.y;

            Vector2d temp = new Vector2d(x, y); //possible positions of the agent in next state
            ArrayList<Vector2d> surroundingBombs =
                    _boardUtils.LocateTileTypeWithinRadius(temp, Types.TILETYPE.BOMB, 1);
            Vector2d bomb ;
            for (int i = 0; i < surroundingBombs.size();i++){
                bomb = surroundingBombs.get(i);
                int bombLife = _boardUtils.BombLife(bomb);
                //this is a threshold condition. The agent starts to consider Evading
                // when the life of bomb is less than the tick threshold:5 + 2 * bomb_count,
                // where bomb_count is the number of bomb surrounding the agent
                if(bombLife < 5 + 2 * surroundingBombs.size())
                    return true;
            }

        }
        return false;

    }

    private int bombCount() {
        return _gameState.getAmmo();
    }

    private boolean enemyInRange(int range) {
        var enemies = _gameState.getEnemies();
        return Arrays.stream(enemies)
                .anyMatch(enemy -> _boardUtils.IsTileTypeWithinManhattanDistance(enemy, range));
    }

    private Types.TILETYPE getEnemyInRange(int range) {
        var enemies = _gameState.getEnemies();
        return Arrays.stream(enemies)
                .filter(enemy -> _boardUtils.IsTileTypeWithinManhattanDistance(enemy, range))
                .findAny().get();
    }


    private void updateGameState(GameState gameState) {
        _gameState = gameState;
        _boardUtils = new BoardUtils(_gameState);
    }

    @Override
    public int[] getMessage() {
        // default message
        int[] message = new int[Types.MESSAGE_LENGTH];
        message[0] = 1;
        return message;
    }

    @Override
    public Player copy() {
        return new HybridPlayer(seed, playerID);
    }

}
