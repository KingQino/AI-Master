function [newImage] = ICV_imageFiltering(image, kernel)
%ICV_imageFiltering  filter the image with the specified kernel
%   Firstly, the image will be tranfered into gray image
%   Then, normalize the kernel
%   Finally, convoling the image without boarder handling (border is not filtered)

gray_img = ICV_rgb2grayscale(image);
gray_img = double(gray_img);
[Height, Width] = size(gray_img);
newImage = zeros(Height, Width,'double');

% normalization of mask
kernel = ICV_Normalization(kernel);

% calculate the size of the kernel 
[h, ~] = size(kernel);
% find the boundary of the convolution computation
y_start = round(h/2);
half_h= (round(h/2) - 1);
y_end = Height - half_h;
x_start = round(h/2);
x_end = Width - half_h;

 for y = y_start : y_end
     for x = x_start : x_end
%          Matrix=double(gray_img(y-half_h:y+half_h, x-half_h:x+half_h)).* kernel;
         Matrix=gray_img(y-half_h:y+half_h, x-half_h:x+half_h).* kernel;
         newImage(y, x) =  round(sum(sum(Matrix)));
     end
 end

%  newImage = uint8(newImage);
end

