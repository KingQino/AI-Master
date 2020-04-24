function [Prediction] = ICV_4c(Frame1,Frame2,block_size,search_window_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
GaussianKernel = [ 1 2 1; 2 4 2; 1 2 1];
Prediction = Frame1;
Frame1 = ICV_imageFiltering(Frame1,GaussianKernel);
Frame2 = ICV_imageFiltering(Frame2,GaussianKernel);
[BlockPosCells] = ICV_divideBlocks(Frame1,block_size);
[M, N] = size(BlockPosCells);
BlockNewPosCells = cell(M,N);
Frame2 = ICV_paddingZeros(Frame2,search_window_size);

for i = 1:M
    for j =1:N
       blockPosition = BlockPosCells{i,j};
       block = Frame1(blockPosition(1,1):blockPosition(1,2),blockPosition(2,1):blockPosition(2,2));
       BlockNewPosCells{i,j} = ICV_blockMatching_4c(block,blockPosition,search_window_size,Frame2);       
    end
end

X = zeros(M*N,1);
Y = zeros(M*N,1);
X1 = zeros(M*N,1);
Y1 = zeros(M*N,1);
for i = 1:M
    for j = 1:N
        pos_orginal = BlockPosCells{i,j};
        pos_moved = BlockNewPosCells{i,j};
        
        X((i-1)*N+j,1) = pos_orginal(1,1);
        Y((i-1)*N+j,1) = pos_orginal(2,1);
        X1((i-1)*N+j,1) = pos_moved(1,1);
        Y1((i-1)*N+j,1) = pos_moved(2,1);
    end
end

for i =1:M
    for j =1:N
        pos_orginal = BlockPosCells{i,j}; 
        h_min = pos_orginal(1,1);
        h_max = pos_orginal(1,2);
        w_min = pos_orginal(2,1);
        w_max = pos_orginal(2,2);
        
        pos_moved = BlockNewPosCells{i,j};
        h_min_new = pos_moved(1,1);
        h_max_new = pos_moved(1,2);
        w_min_new = pos_moved(2,1);
        w_max_new = pos_moved(2,2);

        Prediction(h_min_new:h_max_new,w_min_new:w_max_new,:) = Prediction(h_min:h_max,w_min:w_max,:);        
   
    end
end

end

