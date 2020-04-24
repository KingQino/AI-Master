function [LBPimage, P] = ICV_LBP(inputImage,num_blocks_h,num_blocks_w)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[M,N] = size(inputImage);
LBPimage = ICV_LBPimage(inputImage);

% get the size of each window(block)
num_blocks = num_blocks_h*num_blocks_w;
block_size_h = round(M/num_blocks_h);
block_size_w = round(N/num_blocks_w);
featureDescriptors = zeros(num_blocks,256);

% Returns the feature descriptor (histogram) for all windows using the variable -- 
% featureDescriptors
for i = 1:num_blocks_h
    for j = 1:num_blocks_w
        block = LBPimage(1+(i-1)*block_size_h:block_size_h*i, 1+(j-1)*block_size_w:block_size_w*j);
        featureDescriptors(i+(j-1)*num_blocks_h,:) = ICV_featureDescriptor(block);        
    end
end

% normalize the feature discriptors
NormailzedFeatureDiscriptors = ICV_normalizeHistogram(featureDescriptors);

X = (0: 255);
for i = 1:num_blocks
    P = bar(X*i,NormailzedFeatureDiscriptors(i,:)');
end


% for test
% figure(2),imshow(LBP);

end

