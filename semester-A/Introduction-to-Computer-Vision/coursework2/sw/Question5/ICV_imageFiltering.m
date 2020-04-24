function [newImage] = ICV_imageFiltering(image, kernel)
%ICV_imageFiltering  filter the image
%   Detailed explanation goes here

gray_img = ICV_rgb2grayscale(image);
[H, W] = size(gray_img);
newImage = zeros(H, W, 'uint8');

% normalization of mask
kernel = ICV_Normalization(kernel);

% calculate the size of the kernel 
[h, h] = size(kernel);
% find the boundary of the convolution computation
i_start = round(h/2);
half_h= (round(h/2) - 1);
i_end = H - half_h;
j_start = round(h/2);
j_end = W - half_h;

 for i = i_start : i_end
     for j = j_start : j_end
         Matrix=double(gray_img(i-half_h:i+half_h, j-half_h:j+half_h)).* kernel;
         newImage(i, j) =  round(sum(sum(Matrix)));
     end
 end

end

