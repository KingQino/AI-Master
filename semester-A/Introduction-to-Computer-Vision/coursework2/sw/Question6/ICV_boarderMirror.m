function [paddingImage] = ICV_boarderMirror(inputImage)
%ICV_boarderMirror Deal with the boarder problem of the image using the
%mirroring method
%   This function only pads a circle whose size is 1 pixel
[M,N] = size(inputImage);

paddingImage = uint8(zeros(M+2,N+2));
paddingImage(2:M+1,2:N+1) = inputImage;
paddingImage(1,2:N+1) = inputImage(1,:);
paddingImage(M+2,2:N+1) = inputImage(M,:);
paddingImage(2:M+1,1) = inputImage(:,1);
paddingImage(2:M+1,N+2) = inputImage(:,N);

paddingImage(1,1) = inputImage(1,1);
paddingImage(1,N+2) = inputImage(1,N);
paddingImage(M+2,1) = inputImage(M,1);
paddingImage(M+2,M+2) = inputImage(M,N);

end

