function image = ICV_colorFilter(image)

    % Parameter 
    filter = [1 2 1; 2 4 2; 1 2 1];
    
    % Doing filter in each channel
    for i=1:3
        image(:,:,i) = ICV_filter(image(:,:,i), filter);
    end
 
end

