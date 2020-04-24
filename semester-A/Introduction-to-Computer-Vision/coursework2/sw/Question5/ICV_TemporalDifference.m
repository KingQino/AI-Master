function [FrameDifferencing, ThresholdResult] = ICV_TemporalDifference(Frame1,Frame2,Threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Frame1 = ICV_rgb2grayscale(Frame1);
Frame2 = ICV_rgb2grayscale(Frame2);
[H, W] = size(Frame1);
FrameDifferencing = zeros(H,W);
ThresholdResult = zeros(H,W);

for i = 1:H
    for j = 1:W
        FrameDifferencing(i,j) = abs(Frame1(i,j)-Frame2(i,j));
        ThresholdResult(i,j) = abs(Frame1(i,j)-Frame2(i,j));
        if ThresholdResult(i,j)<Threshold
            ThresholdResult(i,j) = 0;
        else
            ThresholdResult(i,j) = 255;
        end
    end
end

FrameDifferencing = uint8(FrameDifferencing);
ThresholdResult = uint8(ThresholdResult);

end

