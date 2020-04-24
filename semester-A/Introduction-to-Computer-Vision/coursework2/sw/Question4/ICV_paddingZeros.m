function [output] = ICV_paddingZeros(image,padding_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[H,W] = size(image);
newH = H + 2*padding_size;
newW = W + 2*padding_size;
output = zeros(newH,newW);
output(padding_size+1:H+padding_size,padding_size+1:W+padding_size)= image;

end

