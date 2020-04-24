function normalizedKernel = ICV_Normalization(kernel)
%ICV_Normalization Normalization of a matrix
%   If the mask is a Laplacian kernel, this mask itself will be returned;
%   The normalized kernel will be returned otherwise. 

S = sum(sum(kernel));

if S == 0 
    normalizedKernel = kernel;
else
    normalizedKernel = kernel*(1/S);
        
end

