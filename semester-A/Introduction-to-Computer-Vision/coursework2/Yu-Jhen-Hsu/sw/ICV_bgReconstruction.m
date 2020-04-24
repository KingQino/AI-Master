function backgroundImg = ICV_bgReconstruction(videoFrames)
    
    % Parameter Setting
    [height, width, ~, ~] = size(videoFrames);
    backgroundImg = uint8(zeros(height, width, 3));
    
    % Choose the most frequecy pixel values in specific position as
    % background pxiel values
    for i=1:height
        for j=1:width
            for c=1:3
                backgroundImg(i,j,c) = mode(videoFrames(i,j,c,:));
            end
        end
    end
end

