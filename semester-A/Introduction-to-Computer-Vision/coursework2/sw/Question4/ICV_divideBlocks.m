function [BlockPosCells] = ICV_divideBlocks(inputImage,block_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[H,W,~] = size(inputImage);

num_block_H = round(H/block_size);
num_block_W = round(W/block_size);
% BlockCells = cell(num_block_H, num_block_W);
BlockPosCells = cell(num_block_H, num_block_W);

for i = 1:num_block_H
    for j = 1:num_block_W
%         block = inputImage(1+(i-1)*block_size:block_size*i, 1+(j-1)*block_size:block_size*j);
        block_h_min = 1+(i-1)*block_size;
        block_h_max = block_size*i;
        block_w_min = 1+(j-1)*block_size;
        block_w_max = block_size*j;

        BlockPosCells{i,j} = [block_h_min block_h_max; block_w_min block_w_max];    
%         BlockCells{i,j} = block;
    end
end

end
