function mask = ICV_LaplacianMask(n)
% ICV_LaplacianMask  generate a specified size Laplacian Mask
%   It does not belong to the assignment, but it is a kind of try to
%   implement Lplacian masks.
    mask = ones(n);
    mask(ceil((n^2)/2)) = 1 - n^2;
end