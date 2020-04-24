package levelGenerators.groupC;

import engine.helper.RunUtils;
import levelGenerators.ParamMarioLevelGenerator;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

public class RMHC {
    private Random random;

    public RMHC() {
        random = new Random();
    }

    public int[] evolve(ParamMarioLevelGenerator generator, int nIterations) {
        ArrayList<float[]> searchSpace = generator.getParameterSearchSpace();

        // Random initialization
        int[] currentBest = getRandomPoint(searchSpace);
        float bestFitness = evaluate(currentBest, generator);

        // Repeat for nIterations
        for (int i = 0; i < nIterations; i++) {
            // Mutate current best
            int[] candidate = mutate(currentBest, searchSpace);
            float candidateFitness = evaluate(candidate, generator);

            // Keep the better solution
            if (candidateFitness > bestFitness) {
                currentBest = candidate;
                bestFitness = candidateFitness;
            }
        }

        System.out.println("After evolving, the parameter indexes of the level becomes: "+Arrays.toString(currentBest));
        System.out.println("And the corresponding Fitness achieves the highest: "+bestFitness);
        return currentBest;
    }

    private int[] getRandomPoint(ArrayList<float[]> searchSpace) {
        int nParams = searchSpace.size();
        int[] solution = new int[nParams];
        for (int i = 0; i < nParams; i++) {
            int nValues = searchSpace.get(i).length;
            solution[i] = random.nextInt(nValues);
        }
        return solution;
    }

    private int[] mutate(int[] solution, ArrayList<float[]> searchSpace) {
        int[] mutated = solution.clone();
        // Mutate with probability 1/n
        float mutateProb = 1f/solution.length;
        for (int i = 0; i < solution.length; i++) {
            if (random.nextFloat() < mutateProb) {
                mutated[i] = random.nextInt(searchSpace.get(i).length);
            }
        }
        return mutated;
    }

    private float evaluate(int[] solution, ParamMarioLevelGenerator generator){
        generator.setParameters(solution);
        String level = RunUtils.generateLevel(generator);
        levelGenerators.groupC.Evaluation evaluation = new Evaluation(level);

//        return (float)(evaluation.findLeniencyScore()); // The first kind of evaluation method
        return (float)(evaluation.findLinearityScore()); // The second kind of evaluation method
    }

}
