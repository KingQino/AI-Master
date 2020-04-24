function [p] = ICV_plotHistogram(descriptor)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[num,d] = size(descriptor);

X = (0: 255);
% bar(X,descriptor');
for i = 1:num
    p = bar(X*i,d(i,:)');
end

end

