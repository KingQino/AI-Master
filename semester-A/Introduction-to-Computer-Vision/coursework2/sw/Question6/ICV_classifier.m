function [output, distance1, distance2] = ICV_classifier(labelDescriptor1,labelDescriptor2,sample)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%输入decriptor尺寸要相同，也就是图像尺寸一样
[M1, N1] = size(labelDescriptor1);
[M2, ~] = size(labelDescriptor2);

if M1 ~= M2
    disp('The size of the two label decriptors should be equal!!!');
    return;
end

distance1 = 0;
for i = 1:M1
    for j = 1:N1
        variance = sqrt((labelDescriptor1(i,j) - sample(i,j))^2);
        distance1 = distance1 + variance;
    end
end

distance2 = 0;
for i = 1:M1
    for j = 1:N1
        variance = sqrt((labelDescriptor2(i,j) - sample(i,j))^2);
        distance2 = distance2 + variance;
    end
end

if distance1 < distance2
    output = 1;
else
    output = 2;

end

