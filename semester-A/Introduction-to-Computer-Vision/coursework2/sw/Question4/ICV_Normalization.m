function normalizedKernel = ICV_Normalization(kernel)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

S = sum(sum(kernel));

if S == 0 
    normalizedKernel = kernel;
else
    normalizedKernel = kernel*(1/S);
        


end

