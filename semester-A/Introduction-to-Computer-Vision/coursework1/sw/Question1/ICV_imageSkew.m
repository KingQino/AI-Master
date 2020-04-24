function [newImage] = ICV_imageSkew(image, angle)
%ICV_imageSkew Shear the image along x-axis
%   1. S -- shear the image
%   2. Interpolation -- Nearest Neighbour interpolation

% Caculate the size of the new image
[Height,Width,~] = size(image);
Width_new = ceil(Width + Height*abs((1/tand(angle))));
newImage = zeros(Height, Width_new, 3, 'uint8');

% The shear matrix
S = [1 1/tand(angle) 0;0 1 0 ; 0 0 1];

% The implementation of transformation
for y = 1:Height
    for x = 1:Width
        pos = S*[x;y;1];
        x_new = ceil(pos(1));
        y_new = ceil(pos(2));
        newImage(y_new, x_new, :) = image(y, x, :);
    end
end

% Nearest Neighbour interpolation
for y = 1 : Height
    for x = 1 : Width_new-2
        if (sum(newImage(y,x,:)) > 0) && (sum(newImage(y,x+1,:)) == 0) && (sum(newImage(y,x+2,:)) > 0) 
            newImage(y,x+1,:) = newImage(y,x,:);
        end             
    end
end

end


% % mirror about x-axis
% mirrorImage = zeros(Height, Width_new, 3, 'uint8');
% T = [1 0 0;0 -1 0; 0 0 1];
% for y = 1:Height
%     for x = 1:Width_new
%         pos = T*[x;y;1];
%         x_new = ceil(pos(1));
%         y_new = ceil(pos(2))+Height+1;
%         mirrorImage(y_new, x_new, :) = newImage(y, x, :);
%     end
% end
