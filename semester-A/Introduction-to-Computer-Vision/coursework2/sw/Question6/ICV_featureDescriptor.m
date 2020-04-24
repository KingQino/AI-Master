function [featureDescriptor] = ICV_featureDescriptor(inputLBPblock)
%ICV_featureDescriptor return the feature decriptor (histogram) for the 
%specified window
%   input a LBP window, and the function will return the feature descriptor
[H,W] = size(inputLBPblock);
featureDescriptor = zeros(1,256);

for number = 0:255
    for i = 1:H
        for j = 1:W
            if(inputLBPblock(i,j) == number)
                featureDescriptor(1, number+1) = featureDescriptor(1, number+1)+1;
            end
        end
    end
end

% % for test
% X = (0: 255);
% bar(X,featureDescriptor(1,:)');
end

