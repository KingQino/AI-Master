package levelGenerators.groupC;

import engine.core.MarioLevelModel;
import engine.helper.MarioTimer;
import levelGenerators.MarioLevelGenerator;
import levelGenerators.ParamMarioLevelGenerator;

import java.util.ArrayList;

public class LevelGenerator implements MarioLevelGenerator {
    ParamMarioLevelGenerator generator;
    RMHC rmhc;
    int evolve_nIterations;

    public LevelGenerator(ParamMarioLevelGenerator generator_constructive, RMHC rmhc, int evolve_nIterations){
        this.generator = generator_constructive;
        this.rmhc = rmhc;
        this.evolve_nIterations = evolve_nIterations;
    }

    @Override
    public String getGeneratedLevel(MarioLevelModel model, MarioTimer timer) {
        ArrayList<float[]> searchSpace = new ArrayList();
        searchSpace.add(new float[]{0,1,2,3,4}); // type
        searchSpace.add(new float[]{0,1,2,3,4}); // difficulty
        searchSpace.add(new float[]{12,13,14,15}); // Floor
        searchSpace.add(new float[]{0,1,2,3}); // Ceiling
        searchSpace.add(new float[]{1,2,3,4,5}); // nIteration
        generator = new levelGenerators.groupC.Constructive(searchSpace);

        int [] paramIndex = rmhc.evolve(generator, evolve_nIterations);
        generator = new Constructive(paramIndex);

        return generator.getGeneratedLevel(model,timer);
    }

    @Override
    public String getGeneratorName() {
        return null;
    }
}
