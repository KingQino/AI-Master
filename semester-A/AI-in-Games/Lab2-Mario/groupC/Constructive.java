package levelGenerators.groupC;

import engine.core.MarioLevelModel;
import engine.helper.MarioTimer;
import levelGenerators.ParamMarioLevelGenerator;

import java.util.ArrayList;
import java.util.Random;

public class Constructive implements ParamMarioLevelGenerator {
    private static final int ODDS_STRAIGHT = 0;
    private static final int ODDS_HILL_STRAIGHT = 1;
    private static final int ODDS_TUBES = 2;
    private static final int ODDS_JUMP = 3;
    private static final int ODDS_CANNONS = 4;

    private int[] odds = new int[5];
    private int totalOdds;
    private int difficulty;//0-4
    private int type; // 0-4
    private Random random;

    private int FLOOR_PADDING = 2;
    private int nIterations; // 1-3
    private int Floor; // 12-15
    private int Ceiling; //0-3

    ArrayList<float[]> searchSpace = new ArrayList();

    public Constructive() {
        random = new Random();
        this.type = random.nextInt(3);
        this.difficulty = random.nextInt(5);
        this.Floor = random.nextInt(4)+12;
        this.Ceiling = random.nextInt(4);
        this.nIterations = random.nextInt(3)+1;
    }

    public Constructive(ArrayList<float[]> parameterSearchSpace){
        random = new Random();
        this.searchSpace = parameterSearchSpace;
        this.type = random.nextInt(3);
        this.difficulty = random.nextInt(5);
        this.Floor = random.nextInt(4)+12;
        this.Ceiling = random.nextInt(4);
        this.nIterations = random.nextInt(3)+1;
    }

    public Constructive(ArrayList<float[]> parameterSearchSpace, int[] paramIndex){
        random = new Random();
        this.searchSpace = parameterSearchSpace;
        this.setParameters(paramIndex);
    }

    public Constructive(int[] paramIndex) {
        random = new Random();
        searchSpace.add(new float[]{0,1,2,3,4}); // type
        searchSpace.add(new float[]{0,1,2,3,4}); // difficulty
        searchSpace.add(new float[]{12,13,14,15}); // Floor
        searchSpace.add(new float[]{0,1,2,3}); // Ceiling
        searchSpace.add(new float[]{1,2,3,4,5}); // nIteration
        this.setParameters(paramIndex);
    }

    @Override
    public ArrayList<float[]> getParameterSearchSpace() {
        return searchSpace;
    }

    @Override
    public void setParameters(int[] paramIndex) {
        this.type = (int)searchSpace.get(0)[paramIndex[0]];
        this.difficulty = (int)searchSpace.get(1)[paramIndex[1]];
        this.Floor = (int)searchSpace.get(2)[paramIndex[2]];
        this.Ceiling = (int)searchSpace.get(3)[paramIndex[3]];
        this.nIterations = (int)searchSpace.get(4)[paramIndex[4]];
    }


    private int buildZone(MarioLevelModel model, int x, int maxLength) {
        int t = random.nextInt(totalOdds);
        int type = 0; //Randomly decide which block will be applied
        for (int i = 0; i < odds.length; i++) {
            if (odds[i] <= t) {
                type = i; // The prior sequence is Cannons, Jump, Tubes, Hill_Straight,
            }
        }

        switch (type) {
            case ODDS_STRAIGHT:
                return buildStraight(model, x, maxLength, false);
            case ODDS_HILL_STRAIGHT:
                return buildHillStraight(model, x, maxLength);
            case ODDS_TUBES:
                return buildTubes(model, x, maxLength);
            case ODDS_JUMP:
                return buildJump(model, x, maxLength);
            case ODDS_CANNONS:
                return buildCannons(model, x, maxLength);
        }
        return 0;
    }

    private int buildJump(MarioLevelModel model, int xo, int maxLength) {
        int js = random.nextInt(4) + 2;
        int jl = random.nextInt(2) + 2;
        int length = js * 2 + jl;

        boolean hasStairs = random.nextInt(3) == 0;

        int floor = model.getHeight() - 1 - random.nextInt(4);
        for (int x = xo; x < xo + length; x++) {
            if (x < xo + js || x > xo + length - js - 1) {
                for (int y = 0; y < model.getHeight(); y++) {
                    if (y >= floor) {
                        model.setBlock(x, y, MarioLevelModel.GROUND);
                    } else if (hasStairs) {
                        if (x < xo + js) {
                            if (y >= floor - (x - xo) + 1) {
                                model.setBlock(x, y, MarioLevelModel.GROUND);
                            }
                        } else {
                            if (y >= floor - ((xo + length) - x) + 2) {
                                model.setBlock(x, y, MarioLevelModel.GROUND);
                            }
                        }
                    }
                }
            }
        }

        return length;
    }

    private int buildCannons(MarioLevelModel model, int xo, int maxLength) {
        int length = random.nextInt(10) + 2;
        if (length > maxLength)
            length = maxLength;

        int floor = model.getHeight() - 1 - random.nextInt(4);
        int xCannon = xo + 1 + random.nextInt(4);
        for (int x = xo; x < xo + length; x++) {
            if (x > xCannon) {
                xCannon += 2 + random.nextInt(4);
            }
            if (xCannon == xo + length - 1)
                xCannon += 10;
            int cannonHeight = floor - random.nextInt(4) - 1;

            for (int y = 0; y < model.getHeight(); y++) {
                if (y >= floor) {
                    model.setBlock(x, y, MarioLevelModel.GROUND);
                } else {
                    if (x == xCannon && y >= cannonHeight) {
                        model.setBlock(x, y, MarioLevelModel.BULLET_BILL);
                    }
                }
            }
        }

        return length;
    }

    private int buildHillStraight(MarioLevelModel model, int xo, int maxLength) {
        int length = random.nextInt(10) + 10;
        if (length > maxLength)
            length = maxLength;

        int floor = model.getHeight() - 1 - random.nextInt(4);
        for (int x = xo; x < xo + length; x++) {
            for (int y = 0; y < model.getHeight(); y++) {
                if (y >= floor) {
                    model.setBlock(x, y, MarioLevelModel.GROUND);
                }
            }
        }

        addEnemyLine(model, xo + 1, xo + length - 1, floor - 1);

        int h = floor;

        boolean keepGoing = true;

        boolean[] occupied = new boolean[length];
        while (keepGoing) {
            h = h - 2 - random.nextInt(3);

            if (h <= 0) {
                keepGoing = false;
            } else {
                int l = random.nextInt(5) + 3;
                int xxo = random.nextInt(length - l - 2) + xo + 1; // set the initial position of these decorations

                if (occupied[xxo - xo] || occupied[xxo - xo + l] || occupied[xxo - xo - 1]
                        || occupied[xxo - xo + l + 1]) {
                    keepGoing = false;
                } else {
                    occupied[xxo - xo] = true;
                    occupied[xxo - xo + l] = true;
                    addEnemyLine(model, xxo, xxo + l, h - 1);
                    if (random.nextInt(4) == 0) {
                        decorate(model, xxo - 1, xxo + l + 1, h);
                        keepGoing = false;
                    }
                    for (int x = xxo; x < xxo + l; x++) {
                        for (int y = h; y < floor; y++) {
                            int yy = 9;
                            if (y == h)
                                yy = 8;
                            if (model.getBlock(x, y) == MarioLevelModel.EMPTY) {
                                if (yy == 8) {
                                    model.setBlock(x, y, MarioLevelModel.PLATFORM);
                                } else {
                                    model.setBlock(x, y, MarioLevelModel.PLATFORM_BACKGROUND);
                                }
                            }
                        }
                    }
                }
            }
        }

        return length;
    }

    private void addEnemyLine(MarioLevelModel model, int x0, int x1, int y) {
        char[] enemies = new char[]{MarioLevelModel.GOOMBA,
                MarioLevelModel.GREEN_KOOPA,
                MarioLevelModel.RED_KOOPA,
                MarioLevelModel.SPIKY};
        for (int x = x0; x < x1; x++) {
            //对在Ground上的每一个安全位置尝试放敌人
            if (random.nextInt(35) < difficulty + 1) { //这有一个概率，会出现敌人，最大为 5/35=1/7
                int type = random.nextInt(4);
                if (difficulty < 1) {
                    type = 0;
                } else if (difficulty < 3) {
                    type = 1 + random.nextInt(3);
                }
                model.setBlock(x, y, MarioLevelModel.getWingedEnemyVersion(enemies[type], random.nextInt(35) < difficulty));
            }
        }
    }

    private int buildTubes(MarioLevelModel model, int xo, int maxLength) {
//        System.out.println("call the buildTubes!");
        int length = random.nextInt(10) + 5;
        if (length > maxLength)
            length = maxLength;

        int floor = model.getHeight() - 1 - random.nextInt(4);
        int xTube = xo + 1 + random.nextInt(4);
        int tubeHeight = floor - random.nextInt(2) - 2;
        for (int x = xo; x < xo + length; x++) {
            if (x > xTube + 1) {
                xTube += 3 + random.nextInt(4);
                tubeHeight = floor - random.nextInt(2) - 2;
            }
            if (xTube >= xo + length - 2)
                xTube += 10;

            char tubeType = MarioLevelModel.PIPE;
            if (x == xTube && random.nextInt(11) < difficulty + 1) {
                tubeType = MarioLevelModel.PIPE_FLOWER;
            }

            for (int y = 0; y < model.getHeight(); y++) {
                if (y >= floor) {
                    model.setBlock(x, y, MarioLevelModel.GROUND);
                } else {
                    if ((x == xTube || x == xTube + 1) && y >= tubeHeight) {
                        model.setBlock(x, y, tubeType);
                    }
                }
            }
        }

        return length;
    }

    //parameter safe denotes whether add enemy line on the Straight
    private int buildStraight(MarioLevelModel model, int xo, int maxLength, boolean safe) {
        int length = random.nextInt(10) + 2; // The length of Straight: 2 - 11
        if (safe)
            length = 10 + random.nextInt(5); //Say safe, the length: 10 - 14
        if (length > maxLength)
            length = maxLength;

        int floor = model.getHeight() - 1 - random.nextInt(4); // 12 - 15
        for (int x = xo; x < xo + length; x++) {
            for (int y = 0; y < model.getHeight(); y++) {
                if (y >= floor) {
                    model.setBlock(x, y, MarioLevelModel.GROUND);
                }
            }
        }

        if (!safe) {
            if (length > 5) {
                decorate(model, xo, xo + length, floor);
            }
        }

        return length;
    }

    private void decorate(MarioLevelModel model, int x0, int x1, int floor) {
        if (floor < 1)
            return;

        boolean rocks = true;
        addEnemyLine(model, x0 + 1, x1 - 1, floor - 1);

        int s = random.nextInt(4);
        int e = random.nextInt(4);

        if (floor - 2 > 0) { // 设置floor在Straight的上面两格
            if ((x1 - 1 - e) - (x0 + 1 + s) > 1) { //给coins留出足够的空间，至少为2
                for (int x = x0 + 1 + s; x < x1 - 1 - e; x++) {
                    model.setBlock(x, floor - 2, MarioLevelModel.COIN);
                }
            }
        }

        s = random.nextInt(4);
        e = random.nextInt(4);

        if (floor - 4 > 0) { //设置floor在Straight上面的四格
            if ((x1 - 1 - e) - (x0 + 1 + s) > 2) {  //给rocks留出空间，至少为3
                for (int x = x0 + 1 + s; x < x1 - 1 - e; x++) {
                    if (rocks) {
                        if (x != x0 + 1 && x != x1 - 2 && random.nextInt(3) == 0) { //对Normal_BRICKs的范围限定，并且概率为1/3
                            model.setBlock(x, floor - 4, MarioLevelModel.NORMAL_BRICK);
                        } else {
                            model.setBlock(x, floor - 4, MarioLevelModel.COIN);
                        }

                    }
                }
            }
        }
    }


    //Todo -- Cellular Automate algorithm
    @Override
    public String getGeneratedLevel(MarioLevelModel model, MarioTimer timer) {
        model.clearMap();

        odds[ODDS_STRAIGHT] = 20;
        odds[ODDS_HILL_STRAIGHT] = 10;
        odds[ODDS_TUBES] = 2 + 1 * difficulty; //With the increasing of difficulty, there will be more Tubes, Jumps and cannons
        odds[ODDS_JUMP] = 2 * difficulty;
        odds[ODDS_CANNONS] = -10 + 5 * difficulty;

        if (type > 0) {
            odds[ODDS_HILL_STRAIGHT] = 0;
        }

        //aggregate total odds
        for (int i = 0; i < odds.length; i++) {
            if (odds[i] < 0)
                odds[i] = 0;
            totalOdds += odds[i];
            odds[i] = totalOdds - odds[i];
        }

        //At each cycle, set odd in the width range of the 'length'
        int length = 0;
        length += buildStraight(model, 0, model.getWidth(), true);
        while (length < model.getWidth()-10) { // save the most right zone for Babel
            length += buildZone(model, length, model.getWidth() - length);
        }

        //In the last four rows, set floor (Ground) randomly
//        int floor = model.getHeight() - 1 - random.nextInt(4);
        int floor = Floor; //12-15

        for (int x = length; x < model.getWidth(); x++) {
            for (int y = 0; y < model.getHeight(); y++) {
                if (y >= floor) {
                    model.setBlock(x, y, MarioLevelModel.GROUND);
                }
            }
        }

        // set ceil
        if (type > 0) {
            int ceiling = 0;
            int run = 0;
            for (int x = 0; x < model.getWidth(); x++) {
                if (run-- <= 0 && x > 4) {
//                    ceiling = random.nextInt(4);
                    ceiling = Ceiling; // 0-3
                    run = random.nextInt(4) + 4;
                }
                for (int y = 0; y < model.getHeight(); y++) {
                    if ((x > 4 && y <= ceiling) || x < 1) {
                        model.setBlock(x, y, MarioLevelModel.NORMAL_BRICK);
                    }
                }
            }
        }

        //The modifiedModel is used to store processed new levels
        MarioLevelModel modifiedModel = model.clone();

        // 'nIteration' Cellular Automate operations on the original model are done
        boolean keepGoing = true;
        while(keepGoing){
            nIterations--;
            if (nIterations == 0){
                keepGoing =false;
            }
            CellularAutomata(modifiedModel,model);
            model = modifiedModel.clone(); // update the model
//            System.out.println(modifiedModel.getMap());
        }

        // set the starting area in order to avoid the situation which Mario cannot start
        modifiedModel.setRectangle(0, 14, FLOOR_PADDING, 2, MarioLevelModel.GROUND);
        // set the end area in order to place the exit
        modifiedModel.setRectangle(model.getWidth() - 1 - FLOOR_PADDING, 14, FLOOR_PADDING+1, 2, MarioLevelModel.GROUND);
        //Set Babel towel in order to give players a sense of achievement when the player reaches the exit
        setBabel(modifiedModel);
        // Set Easter Eggs in the high range of
        setEasterEggs(modifiedModel);
        // playable mechanism: Due to the use of cellular automata algorithm for many times,
        // sometimes the level may be partially Empty (no playability),
        // so consider adding a playable mechanism, check whether the part is completely empty,
        // and randomly add tiles to make the level playable.
        setPlayable(modifiedModel);

        return modifiedModel.getMap();
    }


    private void setPlayable(MarioLevelModel modifiedModel) {
        String level = modifiedModel.getMap();
        String[] lines = level.split("\n");
        int tWidth = lines[0].length();
        int tHeight = lines.length;
        String emptyArea = "--------";
        int block_size = emptyArea.length();

        if (lines[tHeight-1].contains(emptyArea)){
            for (int x=0; x < tWidth - block_size; x++){ ;
                int NumEmptyRows = 0;
                int y;
                for (y = tHeight -1; y > tHeight-1-block_size; y--){
                    String sub = lines[y].substring(x,x+block_size);
                    if (sub.equals(emptyArea)){
                        NumEmptyRows++;
                    }else if (isContainBrick(sub)){
                        NumEmptyRows++;
                    }
                }
                if (NumEmptyRows>=block_size-2){
                    modifiedModel.setBlock(x+random.nextInt(block_size),tHeight-1-random.nextInt(block_size),
                            MarioLevelModel.getBumpableTiles()[random.nextInt(MarioLevelModel.getBumpableTiles().length)]);
                }
            }
        }

    }

    private boolean isContainBrick(String sub) {
        int len = MarioLevelModel.getBlockTiles().length;

        for (int i=0;i<sub.length();i++){
            for (int j=0; j<len;j++){
                if (sub.charAt(i)==MarioLevelModel.getBlockTiles()[j]){
                    return false;
                }
            }

        }
        return true;
    }

    private void setEasterEggs(MarioLevelModel modifiedModel) {
        int tWidth = modifiedModel.getWidth();
        char[] EasterEgg= new char[]{
                MarioLevelModel.LIFE_BRICK,
                MarioLevelModel.LIFE_HIDDEN_BLOCK,
                MarioLevelModel.COIN_BRICK,
                MarioLevelModel.COIN_QUESTION_BLOCK
        };

        int floor = modifiedModel.getHeight() - 1 - 9; // 6

        for (int x = 0; x<tWidth; x++){
            if (random.nextDouble() < 0.05f){
                modifiedModel.setBlock(x,floor - random.nextInt(4), EasterEgg[random.nextInt(EasterEgg.length)]);
            }
        }

    }

    private void setBabel(MarioLevelModel modifiedModel) {
        int tWidth = modifiedModel.getWidth();
        for (int t = 9; t >=3; t--){
            modifiedModel.setBlock(tWidth-1-t,t+2,MarioLevelModel.PYRAMID_BLOCK);
        }
    }

    private void CellularAutomata(MarioLevelModel modifiedModel, MarioLevelModel model) {

        int tHeight = modifiedModel.getHeight();
        int tWidth = modifiedModel.getWidth();

        for (int i =0; i<tHeight; i++ ){
            for (int j=0; j<tWidth; j++){
                char current = model.getBlock(j,i);
                int numberEmpty = aggregateNeighbours(model,i,j);
                if (current == MarioLevelModel.EMPTY && numberEmpty<=1){
                    modifiedModel.setBlock(j,i,MarioLevelModel.COIN); // reward
                }else if (current != MarioLevelModel.EMPTY && numberEmpty==3){
                    modifiedModel.setBlock(j,i,MarioLevelModel.EMPTY);
                }

            }
        }

    }

    private int aggregateNeighbours(MarioLevelModel model,int i, int j) {
        int tWidth = model.getWidth();
        int tHeight = model.getHeight();

        int numberEmpty=0;

        //deal with the boarder problem
        if (i==0){ // Consider the first row
            if (j==0){ // Consider the top-left corner
                for (int p = 0; p<=1; p++){
                    for (int q = 0; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            } else if (j==tWidth-1){// Consider the top-right corner
                for (int p = 0; p<=1; p++){
                    for (int q=-1; q<=0; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }else { // Consider the first row (excluding the corners)
                for (int p = 0; p<=1; p++){
                    for (int q=-1; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }
        }else if (i == tHeight-1){ // Consider the last row
            if (j==0){
                for (int p = -1; p<=0; p++){
                    for (int q = 0; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            } else if (j==tWidth-1){
                for (int p = -1; p<=0; p++){
                    for (int q=-1; q<=0; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }else {
                for (int p = -1; p<=0; p++){
                    for (int q=-1; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }
        }else {
            if (j==0){ // Consider the first column
                for (int p = -1; p<=1; p++){
                    for (int q = 0; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }else if (j==tWidth-1){ // Consider the last column
                for (int p = -1; p<=1; p++){
                    for (int q = -1; q<=0; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }else { // General situation
                for (int p=-1; p<=1; p++){
                    for (int q=-1; q<=1; q++){
                        if (p==0 && q==0) continue;
                        if (model.getBlock(j+q,i+p) == MarioLevelModel.EMPTY){ numberEmpty++;}
                    }
                }
            }
        }

        return numberEmpty;
    }

    @Override
    public String getGeneratorName() {
        return "Group C Generator -  Based on Parameterized Notch Generator - Search Based Method (Random Mutation Hill Climber)";
    }
}
