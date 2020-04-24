function numberOfObjects = ICV_countObjectVideo(videoFrames,threshold)

    % Parameter Setting
    [~, ~, ~, frames] = size(videoFrames);
    numberOfObjects = zeros(frames,1);
    
    % Count the number based on different frames
    % ICV_countObjects - Give the object number of specific frame
    for i=1:frames
        disp("counting frame #" + string(i))
        numberOfObjects(i) = ICV_countObjects(videoFrames,i, threshold);   
    end
end

