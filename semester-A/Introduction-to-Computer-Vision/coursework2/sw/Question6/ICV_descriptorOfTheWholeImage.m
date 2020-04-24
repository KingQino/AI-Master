function [descriptor] = ICV_descriptorOfTheWholeImage(inputImage,num_blocks_H,num_blocks_W)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

Windows =  ICV_divideWindows(inputImage,num_blocks_H,num_blocks_W);

num_blocks = num_blocks_H*num_blocks_W;
featureDescriptors = zeros(num_blocks,256);

for i = 1:num_blocks_H
    for j = 1:num_blocks_W
        w = Windows{i,j};
        block = ICV_LBPimage(w);
        featureDescriptors(i+(j-1)*num_blocks_H,:) = ICV_featureDescriptor(block);        
    end
end

% normalize the feature discriptors
NormailzedFeatureDiscriptors = ICV_normalizeHistogram(featureDescriptors);
descriptor = NormailzedFeatureDiscriptors;

% % X = (0: 255);
% % for i = 1:num_blocks
% %     bar(X*i,NormailzedFeatureDiscriptors(i,:)');
% % end

end

