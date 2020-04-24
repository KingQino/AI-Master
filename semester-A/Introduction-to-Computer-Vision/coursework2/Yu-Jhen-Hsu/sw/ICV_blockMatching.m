function [motionX,motionY,matrixMotionX,matrixMotionY, blocks] = ICV_blockMatching(videoFrames, index, blockSize, searchSize)

    % Parameter Setting
    [height, width, ~, ~] = size(videoFrames);
    startPoint = (searchSize-blockSize)/2;
    frame1 = videoFrames(:,:,:,index);
    frame2 = videoFrames(:,:,:,index+1);
    windowHeightNum = height/blockSize;
    windowWidthNum = width/blockSize;
    
    % Output Parameter Setting
    blocks = uint8(zeros(blockSize, blockSize,3,windowHeightNum*windowWidthNum));
    motionX = zeros((windowHeightNum*windowWidthNum),1);
    motionY = zeros((windowHeightNum*windowWidthNum),1);
    matrixMotionX = zeros(height,width);
    matrixMotionY = zeros(height,width);

    % Block Matching
    blockNum = 0;
    for i=1:blockSize:height
        for j=1:blockSize:width
            blockNum = blockNum + 1;
            blocks(:,:,:,blockNum) = frame1(i:i+blockSize-1,j:j+blockSize-1,:);
            originalFrame = blocks(:,:,:,blockNum);
            minimunCost = realmax;

            % Starting to the search area match, if the cost is smaller than minimunCost
            % assign it as movement vector
            for si=i-startPoint:i+startPoint
                for sj=j-startPoint:j+startPoint
                    if si>0 && sj>0 && si+blockSize-1<=height && sj+blockSize-1 <= width
                        compareFrame = frame2(si:si+blockSize-1,sj:sj+blockSize-1,:);
                        cost = (sum(sum(sum((double(originalFrame)-double(compareFrame)).^2))) ^ 0.5);                
                        if cost < minimunCost
                            minimunCost = cost;
                            motionY(blockNum) = si-i;
                            motionX(blockNum) = sj-j;
                            matrixMotionY(i+blockSize/2,j+blockSize/2) = si-i;
                            matrixMotionX(i+blockSize/2,j+blockSize/2) = sj-j;
                        end   
                    end
                end
            end
        end
    end
end

