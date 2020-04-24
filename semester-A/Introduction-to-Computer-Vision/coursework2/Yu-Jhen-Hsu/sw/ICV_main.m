% Add path to get dataset (put the dataset under the sw file)
addpath("Dataset")
addpath(fullfile("Dataset","DatasetA"))
%% 

% ----------------------------------------------------
% Question 4 - Block Matching
% ----------------------------------------------------

% Functions for Question 4:
% ICV_blockMatching(videoFrames, index, blockSize, SearchArea, threshold)
%   - provide the motion vector
% ICV_predictNextFrame(videoFrames, index, blockSize, SearchArea, threshold) 
%   - predict the next frame

% Load Video
videoOb = VideoReader('DatasetC.mpg');
videoFrames = read(videoOb);
[height, width, ~, frames] = size(videoFrames);
 
 % 4(a) - Plot the motion vector in index+1 frame
[motionX, motionY, matrixMotionX, matrixMotionY, blocks] = ICV_blockMatching(videoFrames, 6, 16, 32);

imwrite(videoFrames(:,:,:,6), 'videoFrame6.png');
imwrite(videoFrames(:,:,:,7), 'videoFrame7.png');

% Next frmae and superimosed the arrow
imgframe = videoFrames(:,:,:,7);
imshow(imgframe);
hold on;
[x,y] = meshgrid(1:1:width,1:1:height);
quiver(x,y,matrixMotionX,matrixMotionY);
saveas(gcf,'motion(Arrow).png');

%% 
% 4(b) - predict the next frame
[predictImg,frame1] = ICV_predictNextFrame(videoFrames, 6, 16, 20);
subplot(1,2,1),imshow(predictImg);
title('predicted frame #7')
imwrite(predictImg, 'predict1620.png');
subplot(1,2,2),imshow(frame1);
title('original frame #7')

%% 
% 4(c)-predict the nextFrame based on different block size
index = 6;

tic
[predictImg0416,originalFrame] = ICV_predictNextFrame(videoFrames, index, 4, 16);
timeElapsed0416 = toc;

tic
[predictImg0816,~] = ICV_predictNextFrame(videoFrames, index, 8, 16);
timeElapsed0816 = toc;

tic
[predictImg1616,~] = ICV_predictNextFrame(videoFrames, index, 16, 16);
timeElapsed1616 = toc;

subplot(2,2,1),imshow(originalFrame);
title('Original Frame #' + string(index+1));
subplot(2,2,2),imshow(predictImg0416);
imwrite(predictImg0416, 'predictImg0416.png');
title('Predicited Frame(blockSize: ' + string(4) + ')');
subplot(2,2,3),imshow(predictImg0816);
imwrite(predictImg0816, 'predictImg0816.png');
title('Predicited Frame(blockSize: ' + string(8) + ')');
subplot(2,2,4),imshow(predictImg1616);
title('Predicited Frame(blockSize: ' + string(16) + ')');
imwrite(predictImg1616, 'predictImg1616.png');

%% 
% 4(d) - predicted image based on different search area
index = 7;

tic
[predictImg0808,originalFrame] = ICV_predictNextFrame(videoFrames, index, 8, 8);
timeElapsed0808 = toc;

tic
[predictImg0816,~] = ICV_predictNextFrame(videoFrames, index, 8, 16);
timeElapsed0816 = toc;

tic
[predictImg0832,~] = ICV_predictNextFrame(videoFrames, index, 8, 32);
timeElapsed0832 = toc;

subplot(2,2,1),imshow(originalFrame);
title('Original Frame #' + string(index+1));
subplot(2,2,2),imshow(predictImg0808);
title('Predicited Frame(SearchArea: ' + string(8) + ')');
imwrite(predictImg0808, 'predictImg0808.png');
subplot(2,2,3),imshow(predictImg0816);
title('Predicited Frame(SearchArea: ' + string(16) + ')');
imwrite(predictImg0816, 'predictImg0816.png');
subplot(2,2,4),imshow(predictImg0832);
title('Predicited Frame(SearchArea: ' + string(32) + ')');
imwrite(predictImg0832, 'predictImg0832.png');

%% 
% 4(e) - execute time
X = categorical({'4','8','16'});
X = reordercats(X,{'4','8','16'});
subplot(1,2,1),bar(X,[timeElapsed0416,timeElapsed0816,timeElapsed1616]);
title('Time executeion in different block area');
X = categorical({'8','16','32'});
X = reordercats(X,{'8','16','32'});
subplot(1,2,2),bar(X,[timeElapsed0808,timeElapsed0816,timeElapsed0832]);
title('Time executeion in different search area');
saveas(gcf,'time_differnece.png');

%%

% ----------------------------------------------------
% Question 5 - Objects
% ----------------------------------------------------

% Functions for Question 5:
% ICV_frameDifference(videoFrames,referecneIndex,index,threshold)
%   - provide the results of doing frame difference
% ICV_bgReconstruction(videoFrames, index, blockSize, SearchArea, threshold) 
%   - generated the background
% ICV_countObjectVideo(videoFrames, index, blockSize, SearchArea, threshold) 
%   - return a matrix that contains every object number during frames


% Load dataset
videoOb = VideoReader('DatasetC.mpg');
videoFrames = read(videoOb);
[~,~,~,frames] = size(videoFrames);

% 5(a) frame difference with first frame
for i=1:frames
    [referenceFrame,compareFrame,DiffImageAbs,thresholdImage] = ICV_frameDifference(videoFrames,1,i,20);
    subplot(2,2,1), imshow(referenceFrame);
    title('Reference Frame(Frame #1)')
    subplot(2,2,2), imshow(compareFrame);
    title('Compare Frame(Frame #' + string(i) + ')');
    subplot(2,2,3), imshow(DiffImageAbs);
    title('Frame difference(Frame #' + string(i) + ')');   
    subplot(2,2,4), imshow(thresholdImage);
    title('threshold Result(Frame #' + string(i) + ')');     
    pause(0.01);
    if i==3
        imwrite(referenceFrame, 'referenceFrame.png');
        imwrite(compareFrame, 'compareFrame03.png');
        imwrite(DiffImageAbs, 'DiffImageAbs03.png');
        imwrite(thresholdImage, 'thresholdImage03.png');
    elseif i==10
        imwrite(compareFrame, 'compareFrame10.png');
        imwrite(DiffImageAbs, 'DiffImageAbs10.png');
        imwrite(thresholdImage, 'thresholdImage10.png');        
    end
end


%%
% 5(b) frame difference with pervious frame
for i=2:frames
    [referenceFrame,compareFrame,DiffImageAbs,thresholdImage] = ICV_frameDifference(videoFrames,(i-1),i,20);
    subplot(2,2,1), imshow(referenceFrame);
    title('Reference Frame(Frame #' + string(i-1) + ')');
    subplot(2,2,2), imshow(compareFrame);
    title('Compare Frame(Frame #' + string(i) + ')');
    subplot(2,2,3), imshow(DiffImageAbs);
    title('Frame difference(Frame #' + string(i) + ')');   
    subplot(2,2,4), imshow(thresholdImage);
    title('Threshold Result(Frame #' + string(i) + ')');     
    pause(0.01);
    if i==3
        imwrite(compareFrame, 'compareFrameP03.png');
        imwrite(DiffImageAbs, 'DiffImageAbsP03.png');
        imwrite(thresholdImage, 'thresholdImageP03.png');
    elseif i==10
        imwrite(compareFrame, 'compareFrameP10.png');
        imwrite(DiffImageAbs, 'DiffImageAbsP10.png');
        imwrite(thresholdImage, 'thresholdImageP10.png');        
    end
end

%%
% 5(c) - Generate Background
backgroundImg = ICV_bgReconstruction(videoFrames);
imshow(backgroundImg);
imwrite(backgroundImg, 'backgroundImg.png');

%%
% 5(d) - countObjects
objectNumber = ICV_countObjectVideo(videoFrames,20);
bar(objectNumber);
saveas(gcf,'countObjects.png');

%% 
% ----------------------------------------------------
% Question 6 - LBP
% ----------------------------------------------------

% Functions for Question 6:
% ICV_LBP(faceImage,windowSize)
%   - provide the windows of original and LBP blocks 
%     and histogram of local and global descriptor of doing LBP
%   - the window size is determined how many window in height and width
% ICV_histogram(frequencyBins, index, windowNum, isGlobal);
%   - plot the local/global histgram 
% ICV_LBPClassification(testImage, windowSize)
%   - show the class of tesetImage in the command window


% Load an image from datasetA
faceImage = imread('face-1.jpg');

% Turn the image to gray image
faceImage = 0.2989 * faceImage(:,:,1) + 0.5870 * faceImage(:,:,2)+ 0.1140 * faceImage(:,:,3);

% 6(a) - LBP windows and histogram
windowSize = 4;

[faceWindows,faceLBPWindows,frequencyBins, faceGlobalDescriptor] = ICV_LBP(faceImage,windowSize);
[~, windowNum] = size(frequencyBins);

subplot(3,3,1), imshow(faceWindows(:,:,1));
title('face window #1')
subplot(3,3,2), imshow(faceWindows(:,:,5));
title('face window #5')
subplot(3,3,3), imshow(faceWindows(:,:,9));
title('face window #9')
subplot(3,3,4), imshow(faceLBPWindows(:,:,1));
title('LBP window #1')
subplot(3,3,5), imshow(faceLBPWindows(:,:,5));
title('LBP window #5')
subplot(3,3,6), imshow(faceLBPWindows(:,:,9));
title('LBP window #9')
subplot(3,3,7), ICV_histogram(frequencyBins, 1, windowNum, false);
subplot(3,3,8), ICV_histogram(frequencyBins, 5, windowNum, false);
subplot(3,3,9), ICV_histogram(frequencyBins, 9, windowNum, false);
saveas(gcf,'LBPQ1.png');
%% 
% 6(b)- show car/face global descriptor
% Load an image from datasetA
carImage = imread('car-1.jpg');
% Turn the image to gray image
carImage = 0.2989 * carImage(:,:,1) + 0.5870 * carImage(:,:,2)+ 0.1140 * carImage(:,:,3);
% Get global desciptor of car
[~,~,~, carGlobalDescriptor] = ICV_LBP(carImage,windowSize);

subplot(2,2,1), imshow(faceImage);
subplot(2,2,2), ICV_histogram(faceGlobalDescriptor, 1, windowNum, true);
subplot(2,2,3), imshow(carImage);
subplot(2,2,4), ICV_histogram(carGlobalDescriptor, 1, windowNum, true);
saveas(gcf,'LBPQ2.png');

%% 
% 6(c) - classification
testImage = imread('face-4.jpeg');
windowSize = 4;
[testGlobalDescriptorf4, minDifferencef4] = ICV_LBPClassification(testImage, windowSize);
testImage2 = imread('car-4.png');
[testGlobalDescriptorc4, minDifferencec4] = ICV_LBPClassification(testImage2, windowSize);

%% 
% 6(d) - decrease the window size(meaning increase the windows number in height/width)
testImage = imread('face-4.jpeg');
windowSize = 8;
[testGlobalDescriptorf8, minDifferencef8] = ICV_LBPClassification(testImage, windowSize);
testImage2 = imread('car-4.png');
[testGlobalDescriptorc8, minDifferencec8] = ICV_LBPClassification(testImage2, windowSize);
    
%% 
% 6(e) - increase the window size(meaning decrease the windows number in height/width)
testImage = imread('face-4.jpeg');
windowSize = 2;
[testGlobalDescriptor2, minDifference2] = ICV_LBPClassification(testImage, windowSize);
testImage2 = imread('car-4.png');
[testGlobalDescriptorc2, minDifferencec2] = ICV_LBPClassification(testImage2, windowSize);