function [histogram_matrix] = ICV_normalization(histogram_matrix)
%ICV_normalization Normalize the histogram
%   input: histogram matrix (256,3)
%   return: normalized histogram matrix

sum_r = sum(histogram_matrix(:,1));
sum_g = sum(histogram_matrix(:,2));
sum_b = sum(histogram_matrix(:,3));
histogram_matrix(:,1) = histogram_matrix(:,1) / sum_r;
histogram_matrix(:,2) = histogram_matrix(:,2) / sum_g;
histogram_matrix(:,3) = histogram_matrix(:,3) / sum_b;

end

