GroupL
pommerman-hybrid-player

How to call our agent?
1. First, import file 'groupL' into the project
2. Second, in the main function, import two classes.
e.g.
import players.groupL.HybridPlayer;
import players.groupL.mcts.MctsParams;
3. Third, create our agent and initialize it.
e.g.
MctsParams hybridParams = new MctsParams();
hybridParams.stop_type = hybridParams.STOP_ITERATIONS;
hybridParams.num_iterations = 200;
hybridParams.rollout_depth = 12;
Player p = new HybridPlayer(seed, playerID++, hybridParams);
4. Finally, run it!!!
