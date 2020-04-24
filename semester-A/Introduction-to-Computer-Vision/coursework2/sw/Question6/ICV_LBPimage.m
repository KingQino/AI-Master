function [LBPimage] = ICV_LBPimage(inputImage)
%ICV_LBPimage This function returns the LBP image of the input image
%   Before experiencing the LBP processing, the image will use padding technique
%   to cope with the border problem
[M,N] = size(inputImage);
LBPimage = inputImage;

% Deal with the boarder problem -- Mirroring
paddingImage=ICV_boarderMirror(inputImage);

Weights = [1 2 4; 128 0 8; 64 32 16];
Weights = uint8(Weights);

% Make LBP processing for each pixel of the original image
for i = 2:M+1
    for j = 2:N+1
        temp = paddingImage(i-1:i+1,j-1:j+1);
        temp = temp > temp(2,2);
        temp = uint8(temp);
        feature = sum(sum(temp.*Weights));
        
        LBPimage(i-1,j-1) = feature; 
    end
end

end

