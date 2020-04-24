GroupC
MarioLevelGenerator - Constructive - Search Based Method
                                   - Cellular Automata Algorithm - Random Mutation Hill Climber
                           
There are four classes in our package - groupC. 
1. Constructive - Based on the notch genetor provided in the source code, we extract some parameters to parameterize the genetor. After an original level is generated,  we update it with Cellular Automata Algorithm for several times, and then some additional operations also are applied to it such as Babel mechanism, Easter Eggs mechanism, playable mechanism. 
2. Evaluation - There are two types of evaluation methods. The first one is LeniencyScore, and the second is LinearityScore. We will explain them in details in our report.
3. RMHC - It is basically a sample provided by the professor, but we change it using the new evaluation.
4. LevelGenetor - It is exactly our level genetor which encapsulates Constructive genetor and RMHC to improve the performance of the genetor.

How to call our Genetor?
MarioLevelGenerator generator = new levelGenerators.groupC.LevelGenerator(new Constructive(),new RMHC(),100);
1. The first required parameter is an instance of Constructive class, which is used to produce a level genetor with constructive method (Cellular Automata Algorithm). 
2. The second required parameter is an instance of Romdon Mutation Hill Climber class, the purpose of which is to find a level with the best fitness and record the corresponding parameters in order to get the relatively best generator.
3. The last parameter donotes the number of evolving iterations i.e. the parameter of the function RMHC.java. Usually, we set it as 100.
Tip: Don't foget import the corresponding package and class.


How to change the other Evaluation method of ours?
We have two types of evaluation methods. You can find them at the very bottom of the RMHC class.  Switch to another way to evaluate by commenting and uncommenting.
