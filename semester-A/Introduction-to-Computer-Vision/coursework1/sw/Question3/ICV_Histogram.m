function  [Histogram_matrix] = ICV_Histogram(image)
%ICV_colorHistogram 
% input: an colour image 
% output: a colour histogram of input image
% return value: a matrix which saves the frequency of each pixel value for each channel
% e.g. histogram_matrix = ICV_Histogram('face-3.jpg')

[H, W, C] = size(image);

% There is a range from 0 to 255 for each pixel value in the 'uint8' image, 
% which means we need 256 numbers to store these values.
Histogram_matrix = zeros(256,3);

for k = 1:C
    for y = 1:H
        for x = 1:W
            image(y,x,k);
            Histogram_matrix(image(y,x,k)+1,k) = Histogram_matrix(image(y,x,k)+1,k) + 1;
        end
    end
end

% There is a option about whether to normalize the histogram
% Histogram_matrix = ICV_normalization(Histogram_matrix);

% figure();

subplot(3,1,3)
bar((0:255),Histogram_matrix(:,3), 0.9, 'b');
xlabel('The pixel value in blue channel');
ylabel('Frequency');

subplot(3,1,2)
bar((0:255),Histogram_matrix(:,2), 0.9, 'g');
xlabel('The pixel value in green channel');
ylabel('Frequency');

subplot(3,1,1)
bar((0:255),Histogram_matrix(:,1), 0.9, 'r');
xlabel('The pixel value in red channel');
ylabel('Frequency');

end
