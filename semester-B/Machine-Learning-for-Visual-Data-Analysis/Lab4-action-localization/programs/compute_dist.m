function D = compute_dist(X,B)
%compute_dist Compute the Euclidean distance between the dictionary
%elements and the descriptors extracted in an image sequence
%   X: the patches/features in the image sequence (eg. 34-by-162)
%   B: the codebook (eg. 550-by-162)
%   D: the Euclidean distance matrix between codewords and features 
%      (eg. 550-by-34)
nframe = size(X, 1);
nbase=size(B,1);
XX = sum(X.*X, 2);
BB = sum(B.*B, 2);
D  = repmat(XX, 1, nbase)-2*X*B'+repmat(BB', nframe, 1);
D  = D';
end

