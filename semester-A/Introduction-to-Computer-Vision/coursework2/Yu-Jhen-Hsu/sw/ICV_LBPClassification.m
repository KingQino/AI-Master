function [testGlobalDescriptor, minDifference] = ICV_LBPClassification(testImage, windowSize)

    % Get all of train image
    faceImage = imread('face-1.jpg');
    faceImage2 = imread('face-2.jpg');
    faceImage3 = imread('face-3.jpg');
    carImage = imread('car-1.jpg');
    carImage2 = imread('car-2.jpg');
    carImage3 = imread('car-3.jpg');
    
    % Change to grey image
    faceImage = 0.2989 * faceImage(:,:,1) + 0.5870 * faceImage(:,:,2)+ 0.1140 * faceImage(:,:,3);
    carImage = 0.2989 * carImage(:,:,1) + 0.5870 * carImage(:,:,2)+ 0.1140 * carImage(:,:,3);
    faceImage2 = 0.2989 * faceImage2(:,:,1) + 0.5870 * faceImage2(:,:,2)+ 0.1140 * faceImage2(:,:,3);
    carImage2 = 0.2989 * carImage2(:,:,1) + 0.5870 * carImage2(:,:,2)+ 0.1140 * carImage2(:,:,3);
    faceImage3 = 0.2989 * faceImage3(:,:,1) + 0.5870 * faceImage3(:,:,2)+ 0.1140 * faceImage3(:,:,3);
    carImage3 = 0.2989 * carImage3(:,:,1) + 0.5870 * carImage3(:,:,2)+ 0.1140 * carImage3(:,:,3);    
    testImage = 0.2989 * testImage(:,:,1) + 0.5870 * testImage(:,:,2)+ 0.1140 * testImage(:,:,3);

    % LBP calculation
    [~,~,faceFrequencyBins, faceGlobalDescriptor] = ICV_LBP(faceImage,windowSize);
    [~,~,carFrequencyBins, carGlobalDescriptor] = ICV_LBP(carImage,windowSize);
    [~,~,faceFrequencyBins2, faceGlobalDescriptor2] = ICV_LBP(faceImage2,windowSize);
    [~,~,carFrequencyBins2, carGlobalDescriptor2] = ICV_LBP(carImage2,windowSize);    
    [~,~,faceFrequencyBins3, faceGlobalDescriptor3] = ICV_LBP(faceImage3,windowSize);
    [~,~,carFrequencyBins3, carGlobalDescriptor3] = ICV_LBP(carImage3,windowSize);
    [~,~,testFrequencyBins, testGlobalDescriptor] = ICV_LBP(testImage,windowSize);
    
    % Get the classifier
    faceGlobalDescriptor = (faceGlobalDescriptor + faceGlobalDescriptor2 + faceGlobalDescriptor3)/3;
    carGlobalDescriptor = (carGlobalDescriptor + carGlobalDescriptor2 + carGlobalDescriptor3)/3;
    faceFrequencyBins = (faceFrequencyBins + faceFrequencyBins2 + faceFrequencyBins3)/3;
    carFrequencyBins = (carFrequencyBins + carFrequencyBins2 + carFrequencyBins3)/3;
    
    % Classification based on globel descriptor
    faceDifference = sum((testGlobalDescriptor-faceGlobalDescriptor).^2);
    carDifference = sum((testGlobalDescriptor-carGlobalDescriptor).^2);
    isGlobalFace = true;
    if faceDifference < carDifference
        minDifference = faceDifference;
    else
        minDifference = carDifference;
        isGlobalFace = false;
    end
    
    % Classification based on local descriptor
    carSimilarityBlock = 0;
    faceSimilarityBlock = 0;
    [~, windowNum] = size(faceFrequencyBins);
    for i=1:windowNum
        faceLocalDifference = sum((testFrequencyBins(:,i)-faceFrequencyBins(:,i)).^2);
        carLocalDifference = sum((testFrequencyBins(:,i)-carFrequencyBins(:,i)).^2);
        if faceLocalDifference < carLocalDifference
            faceSimilarityBlock = faceSimilarityBlock + 1;
        else
            carSimilarityBlock = carSimilarityBlock + 1;
        end
    end
    
    isLocalFace = true;
    maxSimilarityBlock = 0;
    if faceSimilarityBlock > carSimilarityBlock
        maxSimilarityBlock = faceSimilarityBlock;
    else
        maxSimilarityBlock = carSimilarityBlock;
        isLocalFace = false;
    end
    
    % Show the result
    if isLocalFace && isGlobalFace
        disp("This is face( global difference: " + string(minDifference) + " Similarity Blocks: " + maxSimilarityBlock + "/" + string(windowNum) +")");
    elseif ~isLocalFace && ~isGlobalFace
        disp("This is car( global difference: " + string(minDifference) + " Similarity Blocks: " + maxSimilarityBlock + "/" + string(windowNum) +")");
    else
        disp("Not Sure");
    end
end

