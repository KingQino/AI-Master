function [gray_img] = ICV_rgb2grayscale(image)
%ICV_rgb2grayscale This function returns the grey scale image of the input image
%   In detail, the function will judge whether the input image is gray
%   level image, and return the orginal image if so; return the image with 
%   the gray level processing 
    
[M,N,~] = size(image);
    
% judge whether the input image is two-dimensional     
    if  length(size(image)) == 2
        gray_img = image;
        return;
    end

    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);
    
    
    gray_img = zeros(M, N, 'uint8');
    
    for i=1:M
        for j=1:N
            gray_img(i, j)=(R(i, j)*0.2989)+(G(i, j)*0.5870)+(B(i, j)*0.114);
        end
    end
end