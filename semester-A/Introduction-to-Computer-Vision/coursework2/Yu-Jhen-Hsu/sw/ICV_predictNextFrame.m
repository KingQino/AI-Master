function [predictImg,frame2] = ICV_predictNextFrame(videoFrames, index, blockSize, searchSize)
    
    % Parameter
    [motionX, motionY, ~, ~, blocks] = ICV_blockMatching(videoFrames, index, blockSize, searchSize);
    [~, ~, ~, blockNum] = size(blocks);
    [height, width, ~, ~] = size(videoFrames);
    windowWidthNum = width/blockSize;
    frame1 = videoFrames(:,:,:,index);
    
    % Output Parameter
    frame2 = videoFrames(:,:,:,index+1);
    predictImg = uint8(zeros(height,width,3));
    
    % Start shifting the block
    for i=1:blockNum
        originalYPosition = floor((i-1)/windowWidthNum)*blockSize+1;
        originalXPosition = mod((i-1), windowWidthNum)*blockSize+1;    
        if motionX(i) ~= 0 || motionY(i) ~= 0
            originalYPosition = originalYPosition + motionY(i);
            originalXPosition = originalXPosition + motionX(i);       
            if originalYPosition>0 && originalXPosition>0 && originalYPosition+blockSize-1<=height && originalXPosition+blockSize-1 <= width
                predictImg(originalYPosition:originalYPosition+blockSize-1,originalXPosition:originalXPosition+blockSize-1,:) = blocks(:,:,:,i);
            end
        end
    end

    %Fill the black area with original value
    for i=1:height
        for j=1:width
            if sum(predictImg(i,j,:)) == 0
                predictImg(i,j,:) = frame1(i,j,:);
            end
        end
    end
    
end

