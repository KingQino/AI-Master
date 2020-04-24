package levelGenerators.groupC;

import engine.core.MarioForwardModel;
import engine.core.MarioLevelModel;

public class Evaluation {
    MarioLevelModel model;
    String level;

    public Evaluation(String level){
        String[] lines = level.split("\n");
        int tWidth = lines[0].length();
        int tHeight = lines.length;
        MarioLevelModel model = new MarioLevelModel(tWidth, tHeight);
        model.clearMap();
        model.copyFromString(level);
        this.model = model;
        this.level = model.getMap();
    }

    public double findLeniencyScore(){
        // split levels into lines
        String[] lines = level.split("\n");
        // define width and height of lines
        int tWidth = lines[0].length();
        int tHeight = lines.length;
        int feature1 = 0; //gaps
        int feature2 = 0; //edges
        float feature3; //the proportion of enemies and tiles(enemy can stand)

        //aggregate the feature1 -- gaps
        if (lines[tHeight-1].contains("--")||lines[tHeight-1].contains("---")){
            int step;
            for (int i=0; i<tWidth-3; i=i+step){
                step =1;
                String sub1 = lines[tHeight-1].substring(i,i+2);
                String sub2 = lines[tHeight-1].substring(i,i+3);
                if (sub2.equals("---")){
                    feature1++;
                    step =2;
                    continue;
                }else if (sub1.equals("--")){
                    feature1++;
                }
            }
        }

        //aggregate the feature2 -- edge
        for(int y = 0; y < tHeight; y++){
            for(int x = 0; x < tWidth; x++){
                char char1 = model.getBlock(x,y);
                char char2 = model.getBlock(x+1,y);
                for (char block:MarioLevelModel.getBumpableTiles()){
                    if ((char1 == block && char2 == MarioLevelModel.EMPTY)||(char2 == block && char1 ==MarioLevelModel.EMPTY)){
                        feature2++;
                    }
                }
            }
        }


        // available space to enemies ratio
        // available space is defined by different standing positions (platforms)
        // for each platform, what is the ratio between number of tiles to number of enemies standing on that platform?
        // available space can be characterised by gaps platforms, ground between two gaps, each platform is
        // separated by gaps
        // calculate the ratio between number of enemies and space measured by number of ground tiles
        // the weight assigned to this parameter is assumed to be 0.5
        // code: find enemy string first, when an enemy string is detected, count the number of enemies until there's
        // none. Next I want to detect the number of consecutive '%', which has to be one floor down the enemies
        // finally calculate the ratio between the counts


        char[] canStandBlocks = {MarioLevelModel.GROUND, MarioLevelModel.PYRAMID_BLOCK, MarioLevelModel.NORMAL_BRICK,
                MarioLevelModel.SPECIAL_BRICK, MarioLevelModel.USED_BLOCK, MarioLevelModel.COIN_QUESTION_BLOCK};

        int numEnemies= 0;
        int groundTile = 1;

        for (int y=0; y<model.getHeight(); y++){
            for(int x=0; x<model.getWidth(); x++){

                char block = model.getBlock(x,y);
                int len1 = MarioLevelModel.getEnemyCharacters().length;

                for (int p = 0; p<len1; p++){
                    char enemy = MarioLevelModel.getEnemyCharacters()[p];

                    if (block == enemy){
                        numEnemies++;

                        for (char tile : canStandBlocks){

                            if (model.getBlock(x,y+1)==tile){
                                char searchBlock = model.getBlock(x,y+1);
                                int i = -1;
                                int j = 1;
                                while(model.getBlock(x+i,y+1)==searchBlock && (i>=-4)){
                                    i--;
                                    groundTile++;
                                }
                                while (model.getBlock(x+j,y+1)==searchBlock && (j<=4)){
                                    j++;
                                    groundTile++;
                                }
                            }
                        }

                    }
                }

            }
        }

        feature3 = (float)numEnemies/(float)groundTile;
        //Standardisation
        //After running the notch generator and our generator for 10 times respectively, we estimate the average value of these features.
        //feature1_mean = 17.7    feature2_mean = 68.9   feature3_mean = 13.2
        //sigma1 = 15.96  sigma2 = 52.57  sigma3 = 1.82
        double feature1_mean = 17.7;
        double feature2_mean = 68.9;
        double feature3_mean = 13.2;
        double sigma1 = 15.96;
        double sigma2 = 52.57;
        double sigma3 = 1.82;
        double feature1_standard = Math.abs((double)feature1 - feature1_mean/ sigma1);
        double feature2_standard = Math.abs((double)feature2 - feature2_mean / sigma2);
        double feature3_standard = Math.abs((double)feature3 - feature3_mean / sigma3);

        double weight1 = 0.27;
        double weight2 = 0.13;
        double weight3 = 0.6;
        double leniencyScore = weight1 * feature1_standard + weight2 * feature2_standard + weight3 * feature3_standard;

        return leniencyScore;
    }



    // TODO: 11/12/2019: define linearity score as height differences
    /* first find the a ground that has the highest "height index", find all the height differences and take the average
    of heights to get the mean. Next, calculate the variance of heights.
    code:
     */


    public double findLinearityScore(){
        char[] canStandBlocks = {MarioLevelModel.GROUND, MarioLevelModel.PYRAMID_BLOCK, MarioLevelModel.NORMAL_BRICK,
                MarioLevelModel.SPECIAL_BRICK, MarioLevelModel.USED_BLOCK, MarioLevelModel.COIN_QUESTION_BLOCK};

        int totaltileHeight = 0; //'tile' denotes tile which is not empty
        int totalTileCount = 0;
        float heightMean;

        for(int i = 0; i<model.getHeight(); i++) {
            for (int j = 0; j < model.getWidth(); j++) {
                for (char tile : canStandBlocks) {
                    if (model.getBlock(j, i) == tile) {
                        totaltileHeight = totaltileHeight + i;
                        totalTileCount = totalTileCount + 1;

                    }
                }
            }
        }

        heightMean= (float)(totaltileHeight/totalTileCount);

        float heightDiffTotal = 0;
        for(int a = 0; a<model.getHeight(); a++){
            for(int b = 0; b<model.getWidth(); b++){
                for(char tile: canStandBlocks) {
                    if (model.getBlock(b,a) == tile) {
                        int tempHeight = a;
                        float heightDiff = Math.abs(tempHeight-heightMean);
                        heightDiffTotal = heightDiffTotal + heightDiff;

                    }

                }
            }

        }

        return heightDiffTotal;
//        return heightDiffTotal/40;

    }

}
