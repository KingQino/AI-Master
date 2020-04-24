function noBorderImage = ICV_FillBorder(image, filter)

    % Parameter
    [height, width] = size(image);
    [fSize, ~] = size(filter);
    fSize = floor(fSize/2);  
    normalise = 1;
    
    % ormalisation allows the pixel intensity will fall in [0 - 255]
    if sum(filter(1, : )) > 1
        normalise = sum(filter(1, : ))^2;
    end    
    
    % Output Image
    tempImage = uint8(zeros(height*3-(fSize*2), width*3-(fSize*2)));

    % Doing mirroring temporary image
    for i=0:2
        for j=0:2
            if i == 0
                startH = (height * i) + 1;
            else
                startH = (height * i) - (fSize*i) + 1;
            end
            if j == 0
                startW = (width * j) + 1;
            else
                startW = (width * j) - (fSize*j) + 1;
            end

            if i == 1 || j == 1
                if (i == 0 || i == 2) && j == 1
                    tempImage(startH:startH+height-1, startW:startW+width-1) = image(height:-1:1, :);
                elseif (j == 0 || j == 2) && i == 1
                    tempImage(startH:startH+height-1, startW:startW+width-1) = image(:, width:-1:1);
                else
                    tempImage(startH:startH+height-1, startW:startW+width-1) = image;
                end
            else
                tempImage(startH:startH+height-1, startW:startW+width-1) = image(height:-1:1, width:-1:1);
            end

        end
    end
    
    % Start applying filter from the inner border
    for f=fSize-1:-1:0
        for i=height-fSize+1+f:height*2-fSize-f
            if i == height-fSize+1+f || i == height*2-fSize-f
                for j=width-fSize+1+f:width*2-fSize-f
                    tempImage(i, j) = uint8(sum(sum(double(tempImage(i-fSize:i+fSize, j-fSize:j+fSize)) .* filter))/normalise);
                end
            else
                tempImage(i, width-fSize+1+f) = uint8(sum(sum(double(tempImage(i-fSize:i+fSize, j-fSize:j+fSize)) .* filter))/normalise);
                tempImage(i, width*2-fSize-f) = uint8(sum(sum(double(tempImage(i-fSize:i+fSize, j-fSize:j+fSize)) .* filter))/normalise);        
            end
        end
    end

    noBorderImage = tempImage(height-fSize+1:(height*2)-fSize,width-fSize+1:(width*2)-fSize);
end

