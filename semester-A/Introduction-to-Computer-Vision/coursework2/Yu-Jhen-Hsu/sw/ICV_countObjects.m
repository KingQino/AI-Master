function objectNumber = ICV_countObjects(videoFrames,index, threshold)
    
    % Parameter Setting
    backgroundImg = imread('backgroundImg.png');
    [height, width, ~, ~] = size(videoFrames);

    % Blur Image to reduce noise
    referenceOFrame = backgroundImg;
    referenceFrame = ICV_colorFilter(referenceOFrame);
    compareOFrame = videoFrames(:,:,:,index);
    compareFrame = ICV_colorFilter(compareOFrame);
    
    % Frame Difference
    DiffImageAbs = uint8(abs(double(referenceFrame)- double(compareFrame)));

    aClass = DiffImageAbs > threshold;
    binaryOutput = logical(zeros(height, width));
    for i=1:height
        for j=1:width
            if aClass(i,j,1) == 1 || aClass(i,j,2) == 1 || aClass(i,j,3) == 1
                binaryOutput(i,j) = 1;
            end      
        end
    end

    tempBinary = logical(zeros(height+2, width+2));
    tempBinary(2:height+1,2:width+1) = binaryOutput;
    newtempBinary = tempBinary;
    
    % Dilation and Erosion Application - fill in the gap and remove
    % insufficent area
    structureElement = [1 1 1; 1 1 1; 1 1 1];
    % Dilation
    for k=1:3
        tempBinary = newtempBinary;       
        for i=2:height+1
            for j=2:width+1
                condition = tempBinary(i-1:i+1,j-1:j+1) == structureElement;
                condition(2,2) = 0;
                if sum(sum(condition)) >= 1
                    newtempBinary(i,j) = 1;
                end      
            end
        end
    end
    
    % Erosion
    for k=1:3
        tempBinary = newtempBinary;
        for i=2:height+1
            for j=2:width+1
                condition = tempBinary(i-1:i+1,j-1:j+1) == structureElement;
                condition(2,2) = 0;
                if sum(sum(condition)) ~= 8
                    newtempBinary(i,j) = 0;
                end      
            end
        end
    end
    
    % Reduce to correct area
    newtempBinary = newtempBinary(2:height+1,2:width+1);

    % Connected Components Calculation
    labelTable = zeros(height, width);
    conflict = [0 0];
    conflictIndex = 0;
    objectIndex = 0;
    for i=1:height    
        for j=1:width
            if newtempBinary(i,j) == 1
                if j-1 ~=0 && i-1 ~=0        
                    if labelTable(i,j-1) ~= 0 && labelTable(i-1,j) == 0
                       labelTable(i,j) = labelTable(i,j-1);
                    elseif labelTable(i-1,j) ~= 0 && labelTable(i,j-1) == 0
                       labelTable(i,j) = labelTable(i-1,j);
                    elseif labelTable(i-1,j) ~= 0 && labelTable(i,j-1) ~= 0
                        labelTable(i,j) = min(labelTable(i-1,j),labelTable(i,j-1));
                        conflictNum = max(labelTable(i-1,j),labelTable(i,j-1));
                        if labelTable(i-1,j) ~= labelTable(i,j-1)                        
                            conflictIndex = conflictIndex + 1;                            
                            conflict(conflictIndex, :) = [conflictNum labelTable(i,j)];
                        end
                    else
                        objectIndex = objectIndex+1;
                        labelTable(i,j) = objectIndex;                   
                    end
                elseif j-1 ~=0  && i-1 ==0
                    if labelTable(i,j-1) ~= 0
                       labelTable(i,j) = labelTable(i,j-1);
                    else
                        objectIndex = objectIndex+1;
                        labelTable(i,j) = objectIndex;                   
                    end                
                elseif j-1 ==0  && i-1 ~=0
                    if labelTable(i-1,j) ~= 0
                       labelTable(i,j) = labelTable(i-1,j);
                    else
                        objectIndex = objectIndex+1;
                        labelTable(i,j) = objectIndex;                   
                    end                    
                else
                    objectIndex = objectIndex+1;
                    labelTable(i,j) = objectIndex;                
                end
            end
        end
    end
    
    % Deal with the number with belong the other class
    for c=1:conflictIndex
        for i=1:height    
            for j=1:width
                if labelTable(i,j) == conflict(c,1)
                    labelTable(i,j) = conflict(c,2);
                end
            end
        end
    end
    
    % Count the object number
    totalUniqueNumber = unique(labelTable);
    [uniqueNumber,~] = size(totalUniqueNumber);
    objectNumber = 0;
    for i=1:uniqueNumber
        if sum(sum(labelTable == totalUniqueNumber(i,1))) > 30 && totalUniqueNumber(i,1) ~= 0
            objectNumber = objectNumber + 1;
        end
    end
end

