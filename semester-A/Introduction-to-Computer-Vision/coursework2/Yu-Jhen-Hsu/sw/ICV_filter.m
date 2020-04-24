function filterImage = ICV_filter(image,filter)

    % Parameter 
    [height, width, color] = size(image);
    [fSize, ~] = size(filter);
    fSize = floor(fSize/2);  
    normalise = 1;

    % If it has already normalised, then don't need to do anything
    % Normalisation allows the pixel intensity will fall in [0 - 255]
    if sum(filter(1, : )) > 1
        normalise = sum(filter(1, : ))^2;
    end

    % Output Image
    filterImage = uint8(zeros(height,width));
    
    % Change to Gray picture if it is still RGB image
    if color > 1
        image = 0.2989 * image(:,:,1) + 0.5870 * image(:,:,2)+ 0.1140 * image(:,:,3);
        image = uint8(image);
    end
    
    % Filiter
    for i=1+fSize:height-fSize
        for j=1+fSize:width-fSize
            % Calculate the value to put into output image
            filterImage(i, j) = uint8(sum(sum(double(image(i-fSize:i+fSize, j-fSize:j+fSize)) .* filter))/normalise);
        end
    end
    
    % ICV_FillBorder(image, filter) -> change the border color by mirorring
    % if the sum of filter is 0, it will not be applied
    if sum(sum(filter)) ~= 0
        filterImage = ICV_FillBorder(filterImage, filter);
    end   
end

