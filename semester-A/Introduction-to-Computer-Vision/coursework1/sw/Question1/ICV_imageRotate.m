function [newImage] = ICV_imageRotate(image, angle)
%ICV_imageRotate Rotate the image with a specified angle 
%   1. M*R*B*image(i,j) -- M:move the image to the center 
%                       -- R:rotate the image clockwise
%                       -- B:move back the picture to the orginal position 
%   2. Interpolation -- In this case, choosing Nearest Neighbour interpolation


% Caculate the size of the new image
[Height,Width,~] = size(image);
Height_new = ceil(Width * abs(sind(angle)) + Height * abs(cosd(angle)));
Width_new  = ceil(Height * abs(sind(angle)) + Width * abs(cosd(angle)));
newImage = zeros(Height_new, Width_new, 3, 'uint8');

% The matrix: move the picture to the center of the coordinate
moveToCentre = [1 0 -round(Width/2); 0 1 -round(Height/2); 0 0 1];
% The rotation matrix
R = [cosd(angle) -sind(angle) 0;sind(angle) cosd(angle) 0 ; 0 0 1];

% Move back the picture to the orginal position 
minDistanceWmove = 0;
minDistanceHmove = 0;
for y=1:Height
    for x=1:Width
        tmp = R * moveToCentre * [x ; y; 1];
        if (minDistanceWmove > tmp(1) )
            minDistanceWmove = tmp(1);
        end   
        if (minDistanceHmove > tmp(2) )
            minDistanceHmove = tmp(2);
        end    
    end
end
% The matrix: move back the picture to the orginal position 
moveBackFromCentre = [1 0 abs(ceil(minDistanceWmove)); 0 1 abs(ceil(minDistanceHmove)); 0 0 1];

% The implementation of transformation -- Inverse mapping 
T = moveBackFromCentre * R * moveToCentre ;
for y=1:Height_new
    for x=1:Width_new
        pos_original = T^-1*[x; y; 1];
        x_original = ceil(pos_original(1));
        y_original = ceil(pos_original(2));
        if (x_original >= 1) && (x_original <= Width) && (y_original >= 1) && (y_original <= Height)
            newImage(y, x, :) = image(y_original, x_original, :);
        end
    end
end

% Nearest Neighbour interpolation
for y = 1 : Height_new 
    for x = 1 : Width_new-2
        if (sum(newImage(y,x,:)) > 0) && (sum(newImage(y,x+1,:)) == 0) && (sum(newImage(y,x+2,:)) > 0) 
            newImage(y,x+1,:) = newImage(y,x,:);
        end             
    end
end

end

% Alternative parts

% The implementation of transformation -- Forward mapping
% T = moveBackFromCentre * R * moveToCentre ;
% for y=1:Height
%     for x=1:Width
%         pos = T * [x ; y; 1];
%         x_new = ceil(abs(pos(1)));
%         y_new = ceil(abs(pos(2)));
%         newImage(y_new, x_new, :) = image(y, x, :);
%     end
% end

% Bilinear interpolation
% for y = 2 : Height_new -1
%     for x = 2 : Width_new-1
%         a = (1/2) * newImage(y-1, x-1, :) + (1/2) * newImage(y-1, x+1, :);
%         b = (1/2) * newImage(y+1, x-1, :) + (1/2) * newImage(y+1, x+1, :);
%         newImage(y, x, :) = ceil((1/2) * a +(1/2) * b);
%     end
% end


