function [block_new_pos] = ICV_blockMatching_4c(block,blockPos, search_window_size,inputImage)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
block_h_min = blockPos(1,1)+search_window_size;
block_h_max = blockPos(1,2)+search_window_size;
block_w_min = blockPos(2,1)+search_window_size;
block_w_max = blockPos(2,2)+search_window_size;

[block_size, ~] = size(block);% block is a square
padding_distance = (search_window_size - block_size)/2;

% %default set the two impossible values in order to be the conditions of
% %judgement
c_i = padding_distance^2;
c_j = padding_distance^2;
errorMeasure = inf;

for i = -padding_distance : padding_distance
    for j = -padding_distance : padding_distance
        block_new = inputImage(block_h_min+i:block_h_max+i, block_w_min+j:block_w_max+j);
        differenceValue = ICV_MSE(block, block_new);
        if differenceValue < errorMeasure
            errorMeasure = differenceValue;
            c_i = i;
            c_j = j;
        end
    end
end

if c_i == padding_distance^2
    block_new_pos = [block_h_min block_h_max; block_w_min block_w_max];
else
    block_new_pos = [block_h_min+c_i block_h_max+c_i; block_w_min+c_j block_w_max+c_j];
end
        


end

