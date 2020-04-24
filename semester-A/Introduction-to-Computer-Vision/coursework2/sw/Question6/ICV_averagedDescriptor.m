function [outputDescriptor] = ICV_averagedDescriptor(inputDescriptor1,inputDescriptor2,sample)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[M1, N1] = size(inputDescriptor1);
[M2, ~] = size(inputDescriptor2);

if M1 ~= M2
    disp('The size of input decriptors should be equal!!!');
    return;
end

outputDescriptor = zeros(M1,N1);
for i = 1:M1
    for j = 1:N1
        variance = (inputDescriptor1(i,j)+inputDescriptor2(i,j))/2;
        outputDescriptor(i,j) = variance; 
    end
end

end

