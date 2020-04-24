function [NormailzedHistogram] = ICV_normalizeHistogram(inputHistogram)
%ICV_normalizeHistogram Normalize the input histogram
%   e.g. The input histogram is a matrix of M by N
%        this function will normalize each of the M histogram respectively
[M,N] = size(inputHistogram);
NormailzedHistogram = zeros(M,N);


for i = 1:M
    for j = 1:N
        Sum = sum(inputHistogram(i,:));
        NormailzedHistogram(i,j)= inputHistogram(i,j)/Sum;
    end
end

end

