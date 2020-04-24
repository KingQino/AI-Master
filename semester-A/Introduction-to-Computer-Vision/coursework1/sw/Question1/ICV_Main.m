%% 1.(a)
% A = imread('ICV_Q1.png');
% figure(1), imshow(ICV_imageRotate(A,30));
% figure(2), imshow(ICV_imageRotate(A,60));
% figure(3), imshow(ICV_imageRotate(A,120));
% figure(4), imshow(ICV_imageRotate(A,-50));

%please uncomment this part to implement ICV_imageSkew() function
A = imread('ICV_Q1.png');
figure(1), imshow(ICV_imageSkew(A,10));
figure(2), imshow(ICV_imageSkew(A,40));
figure(3), imshow(ICV_imageSkew(A,60));

%% 1.(b)
A = imread('ICV_Q1.png');
theta1 = 20;
theta2 = 50;
B = ICV_imageSkew(ICV_imageRotate(A,theta1),theta2);
C = ICV_imageRotate(ICV_imageSkew(A,theta2),theta1);

figure(1), imshow(B);
figure(2), imshow(C);
