function [WindowCells] = ICV_divideWindows(inputImage,num_window_H,num_window_W)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[H,W] = size(inputImage);
window_size_H = floor(H/num_window_H);
window_size_W = floor(W/num_window_W);
WindowCells= cell(num_window_H,num_window_W);

% For the 'WindowCells', the block in the first row and column is the first
% window, and the block in the second row and the first column is the second
% window ...
for i = 1:num_window_H
    for j = 1:num_window_W
        block = inputImage(1+(i-1)*window_size_H:window_size_H*i, 1+(j-1)*window_size_W:window_size_W*j);
        WindowCells{i,j} = block;
    end
end

end

