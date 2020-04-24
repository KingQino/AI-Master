%% 4.(a)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);
% the sizes consecutive of the frames must be the same
block_size = 16;
search_window_size = 20;

Frame1 = VideoFrames(:,:,:,16);
Frame2 = VideoFrames(:,:,:,17);
[X,Y,U,V] = ICV_4a(Frame1,Frame2,block_size,search_window_size);
figure(1),imshow(Frame1);
figure(2),imshow(Frame2);

figure(3),imshow(Frame1)
hold on
quiver(Y,X,V,U,'r');
hold off;

% for iFrame = 1:VidObj.NumFrames-1
%     disp(['Change between Frame #' num2str(iFrame) ' and Frame #' num2str(iFrame+1)]);
%     Frame1 = VideoFrames(:,:,:,iFrame);
%     Frame2 = VideoFrames(:,:,:,iFrame+1);
%     [X,Y,U,V] = ICV_4a(Frame1,Frame2,block_size,search_window_size);
%     figure(iFrame);
%     title(['Change between Frame #' num2str(iFrame) ' and Frame #' num2str(iFrame+1)]);
%     imshow(Frame1);
%     hold on;
%     quiver(Y,X,V,U);
%     hold off;
% end

%% 4.(b)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);
% the sizes consecutive of the frames must be the same
block_size = 16;
search_window_size = 20;

Frame1 = VideoFrames(:,:,:,16);
Frame2 = VideoFrames(:,:,:,17);
[Prediction] = ICV_4b(Frame1,Frame2,block_size,search_window_size);
figure(1),imshow(Frame2);
title('The actual frame');
figure(2),imshow(Prediction);
title('The predicited frame');

%% 4.(c)(d)
VidObj = VideoReader('DatasetC.mpg');
VideoFrames = read(VidObj);
% the sizes consecutive of the frames must be the same
block_size = 8;
search_window_size = 32;

Frame1 = VideoFrames(:,:,:,16);
Frame2 = VideoFrames(:,:,:,17);
[Prediction] = ICV_4c(Frame1,Frame2,block_size,search_window_size);
figure(1),imshow(Prediction);
title('The predicited frame');
