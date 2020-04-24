function [X, Y, U, V] = ICV_4a(Frame1,Frame2,block_size,search_window_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
GaussianKernel = [ 1 2 1; 2 4 2; 1 2 1];
Frame1 = ICV_imageFiltering(Frame1,GaussianKernel);
Frame2 = ICV_imageFiltering(Frame2,GaussianKernel);
[BlockPosCells] = ICV_divideBlocks(Frame1,block_size);
[M, N] = size(BlockPosCells);
BlockNewPosCells = cell(M,N);

for i = 2:M-1
    for j =2:N-1
       blockPosition = BlockPosCells{i,j};
       block = Frame1(blockPosition(1,1):blockPosition(1,2),blockPosition(2,1):blockPosition(2,2));
       BlockNewPosCells{i,j} = ICV_blockMatching(block,blockPosition,search_window_size,Frame2);       
    end
end

BlockPosCells = BlockPosCells(2:M-1,2:N-1);
BlockNewPosCells = BlockNewPosCells(2:M-1,2:N-1);
[num_h, num_w] = size(BlockPosCells);

X = zeros(num_h*num_w,1);
Y = zeros(num_h*num_w,1);
X1 = zeros(num_h*num_w,1);
Y1 = zeros(num_h*num_w,1);
for i = 1:num_h
    for j = 1:num_w
        pos_orginal = BlockPosCells{i,j};
        pos_moved = BlockNewPosCells{i,j};
        
        X((i-1)*num_w+j,1) = pos_orginal(1,1);
        Y((i-1)*num_w+j,1) = pos_orginal(2,1);
        X1((i-1)*num_w+j,1) = pos_moved(1,1);
        Y1((i-1)*num_w+j,1) = pos_moved(2,1);
    end
end

U = X1 - X;
V = Y1 - Y;

end

