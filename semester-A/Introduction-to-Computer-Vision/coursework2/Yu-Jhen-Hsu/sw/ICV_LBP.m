function [windows, LBPwindows, frequencyBins, globalDescriptor] = ICV_LBP(image,windowSize)
    
    % Step 1 -> Create tempImage
    [imageHeight, imageWidth] = size(image);
    tempImage = uint8(zeros(imageHeight+2, imageWidth+2));
    tempImage(2:imageHeight+1,2:imageWidth+1) = image;

    % Corner mirroring
    tempImage(1,1) = image(1,1);
    tempImage(1,imageWidth+2) = image(1,imageWidth);
    tempImage(imageHeight+2,1) = image(imageHeight,1);
    tempImage(imageHeight+2,imageWidth+2) = image(imageHeight,imageWidth);

    % Border mirroring
    tempImage(1,2:imageWidth+1) = image(1,:);
    tempImage(imageHeight+2,2:imageWidth+1) = image(imageHeight,:);
    tempImage(2:imageHeight+1,1) = image(:,1);
    tempImage(2:imageHeight+1,imageWidth+2) = image(:,imageWidth);

    % Step 2 -> Create LBPImage
    LBPImage = uint8(zeros(imageHeight,imageWidth));
     binaryMatrix = [1 2 4; 128 0 8; 64 32 16];

    for h=2:imageHeight+1
        for w=2:imageWidth+1
            logicalMatrix = tempImage(h-1:h+1,w-1:w+1) > tempImage(h,w);
            value = sum(sum(logicalMatrix .* binaryMatrix)) ;
            LBPImage(h-1, w-1) = value;
        end
    end

    % Step 3 -> Window Size Checking (Make sure every pixels is inside one of the windows)

    while mod(imageHeight, windowSize) ~= 0 || mod(imageWidth, windowSize) ~= 0
        windowSize = windowSize + 1;
    end

    windowHeight = imageHeight/windowSize;
    windowWidth = imageWidth/windowSize;
    windowNumber = windowSize^2;

    % Step 4 -> Create windows and LBP windows
    windows = uint8(zeros(windowHeight, windowWidth, windowNumber));
    LBPwindows = uint8(zeros(windowHeight, windowWidth, windowNumber));

    windowNum = 1;
    for i=1:windowHeight:imageHeight
        for j=1:windowWidth:imageWidth
            windows(:,:,windowNum) = image(i:i+windowHeight-1, j:j+windowWidth-1);
            LBPwindows(:,:,windowNum) = LBPImage(i:i+windowHeight-1, j:j+windowWidth-1);
            windowNum = windowNum + 1;
        end
    end

    % Step 5 -> Create Frequency Bins
    frequencyBins = zeros(256, windowNumber);

    for i=1:windowNumber
        for h=1:windowHeight
            for w=1:windowWidth
                frequencyBins(LBPwindows(h,w,i)+1, i) = frequencyBins(LBPwindows(h,w,i)+1, i) + 1;
            end
        end
    end

    % Step 6 -> Normalisation
    frequencyBins = frequencyBins / ((windowHeight)*(windowWidth));
    
    % Step 7 -> GlobalDescriptor
    globalDescriptor = zeros(256*windowNumber,1);
    windowNum = 1;
    for i=1:256:256*windowNumber
        globalDescriptor(i:256+i-1) = frequencyBins(:, windowNum);
        windowNum = windowNum + 1;
    end
    globalDescriptor =  globalDescriptor / (windowSize^2);
end


