%% 3.(a)
VidObj = VideoReader('../DatasetB.avi');
VideoFrames = read(VidObj);

for iFrame = 1:VidObj.NumFrames
    disp(['Frame #' num2str(iFrame)])
    figure(1),imshow(VideoFrames(:,:,:,iFrame))
    title(['Frame #' num2str(iFrame)])
    Histogram_matrix = ICV_Histogram(VideoFrames(:,:,:,iFrame));
    title(['Frame #' num2str(iFrame)]);
    pause(1/VidObj.FrameRate)
end

close all
%% 3.(b)

VidObj = VideoReader('../DatasetB.avi');
VideoFrames = read(VidObj);

for iFrame = 1:VidObj.NumFrames-1    
    disp(['Intersection between Frame #' num2str(iFrame) 'and Frame #' num2str(iFrame+1)])
    
    % present two consecutive frames of the video 
%     figure(1),imshow(VideoFrames(:,:,:,iFrame))
%     title(['Frame #' num2str(iFrame)])
%     figure(2),imshow(VideoFrames(:,:,:,iFrame+1))
%     title(['Frame #' num2str(iFrame+1)]);
    
    % present the two histograms with respect to frames above
    figure(3), H1 = ICV_Histogram(VideoFrames(:,:,:,iFrame));
    title(['Frame #' num2str(iFrame)]);
    figure(4), H2 = ICV_Histogram(VideoFrames(:,:,:,iFrame+1));
    title(['Frame #' num2str(iFrame+1)]);
    
    % present the intersection of the two Histograms
%     Intersection = ICV_intersection(H1, H2);
%     title(['Intersection between Frame #' num2str(iFrame) 'and Frame #' num2str(iFrame+1)]);
    pause(1/VidObj.FrameRate)
end


close all


