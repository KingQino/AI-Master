function [gray_img] = ICV_rgb2grayscale(image)
    [Height, Width, ~] = size(image);
    
 % judge whether the input image is two-dimensional     
    if  length(size(image)) == 2
        gray_img = image;
        return;
    end

    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);
    
    
    gray_img = zeros(Height, Width, 'uint8');
    
    for y=1:Height
        for x=1:Width
            gray_img(y, x)=(R(y, x)*0.2989)+(G(y, x)*0.5870)+(B(y, x)*0.114);
        end
    end
end