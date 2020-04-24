function [referenceOFrame,compareOFrame,DiffImageAbs,aOut] = ICV_frameDifference(videoFrames,referecneIndex,index,threshold)

    % Parameter Setting
    [height, width, ~, ~] = size(videoFrames);

    % Blur the frame by ICV_colorFilter -> Using Gaussian Filter
    referenceOFrame = videoFrames(:,:,:,referecneIndex);
    referenceFrame = ICV_colorFilter(referenceOFrame);
    compareOFrame = videoFrames(:,:,:,index);
    compareFrame = ICV_colorFilter(compareOFrame);

    % The image without applying the threshold
    DiffImageAbs = uint8(abs(double(referenceFrame)- double(compareFrame)));

    % The image with applying the threshold
    aClass = DiffImageAbs > threshold;
    aOut = uint8(zeros(height, width));
    for i=1:height
        for j=1:width
            if aClass(i,j,1) == 1 || aClass(i,j,2) == 1 || aClass(i,j,3) == 1
                aOut(i,j) = 255;
            end
        end
    end

end

