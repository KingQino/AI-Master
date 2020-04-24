function [SumOfMSE] = ICV_MSE(block1,block2)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if size(block1) ~= size(block2)
    disp('The size of the two input blocks are not equal!');
    return;
end
[H, W] = size(block1);
SumOfMSE = double(0);

for i = 1:H
    for j = 1:W
%         x = double((block1(i,j)-block2(i,j)).^2);
%         MSE = sqrt(x);
        MSE = abs(block1(i,j)-block2(i,j));
        SumOfMSE = SumOfMSE + double(MSE);
    end
end


end

