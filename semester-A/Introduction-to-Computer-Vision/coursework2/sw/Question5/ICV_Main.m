%% 5.(a)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);
referenceFrame = VideoFrames(:,:,:,1);
Frame1 = VideoFrames(:,:,:,2);
Frame2 = VideoFrames(:,:,:,100);
figure(1),imshow(referenceFrame);
saveas(gcf,'referenceFrame.png ');
figure(2),imshow(Frame1);
saveas(gcf,'selectedFrame.png ');
figure(3),imshow(Frame2);

GaussianKernel = [ 1 2 1; 2 4 2; 1 2 1];
referenceFrame = ICV_imageFiltering(referenceFrame,GaussianKernel);
GrayFrame1 = ICV_imageFiltering(Frame1,GaussianKernel);
GrayFrame2 = ICV_imageFiltering(Frame2,GaussianKernel);
Threshold = 20;

[FrameDifferencing1, ThresholdResult1]= ICV_TemporalDifference(referenceFrame,GrayFrame1,Threshold );
figure(4),imshow(FrameDifferencing1);
saveas(gcf,'FrameDifferencing.png ');
figure(5),imshow(ThresholdResult1);
saveas(gcf,'ThresholdResult.png ');

[FrameDifferencing2, ThresholdResult2]= ICV_TemporalDifference(referenceFrame,GrayFrame2,Threshold );
figure(6),imshow(FrameDifferencing2);
figure(7),imshow(ThresholdResult2);

%% 5.(b)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);

for iFrame = 2:VidObj.NumFrames
    disp(['Frame #' num2str(iFrame) ' | Reference Frame #' num2str(iFrame-1) ]);
    GaussianKernel = [ 1 2 1; 2 4 2; 1 2 1];
    GrayFrame1 = ICV_imageFiltering(VideoFrames(:,:,:,iFrame-1),GaussianKernel);
    GrayFrame2 = ICV_imageFiltering(VideoFrames(:,:,:,iFrame),GaussianKernel);
    figure(1),imshow(VideoFrames(:,:,:,iFrame));
    title(['Frame #' num2str(iFrame) ' | Reference Frame #' num2str(iFrame-1)]);
    Threshold = 20;
    [FrameDifferencing, ThresholdResult] = ICV_TemporalDifference(GrayFrame1,GrayFrame2,Threshold );
    figure(2),imshow(FrameDifferencing);
    title(['Frame #' num2str(iFrame) ' | Reference Frame #' num2str(iFrame-1)]);
    figure(3),imshow(ThresholdResult);
    title(['Frame #' num2str(iFrame) ' | Reference Frame #' num2str(iFrame-1)]);
end

%% 5.(c)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);

[H,W,~] = size(VideoFrames(:,:,:,1));
num_pixel = zeros(H,W); 
background = zeros(H,W,3);
image = zeros(H,W,3);

for iFrame = 2:VidObj.NumFrames
    disp(['Frame #' num2str(iFrame) ' | Reference Frame #' num2str(iFrame-1) ]);
    Frame1 = VideoFrames(:,:,:,iFrame-1);
    Frame2 = VideoFrames(:,:,:,iFrame);    
    
    GaussianKernel = [ 1 2 1; 2 4 2; 1 2 1];
    GrayFrame1 = ICV_imageFiltering(Frame1,GaussianKernel);
    GrayFrame2 = ICV_imageFiltering(Frame2,GaussianKernel);    
    
    Threshold = 20;
    [FrameDifferencing, ThresholdResult] = ICV_TemporalDifference(GrayFrame1,GrayFrame2,Threshold);
    
    for i = 1:H
        for j = 1:W
            if ThresholdResult(i,j) == 0
                num_pixel(i,j) = num_pixel(i,j)+1;
                image(i,j,:) = image(i,j,:) + double(Frame2(i,j,:));
            end
        end
    end
      
end

for i = 1:H
    for j = 1:W
        background(i,j,:) = image(i,j,:)/num_pixel(i,j);
    end
end
background = uint8(background);
imshow(background);

%% 5.(d)

Frame = VideoFrames(:,:,:,1);
Threshold = 20;
[F, T] = ICV_TemporalDifference(Frame,background,Threshold);
figure,imshow(F);
figure,imshow(T);