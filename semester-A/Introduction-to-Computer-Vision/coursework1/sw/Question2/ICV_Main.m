%% 2.(a)
I = imread('../DatasetA/car-1.jpg');
meanKernel = ones(3, 3);
outputImage = ICV_imageFiltering(I, meanKernel);
imshow(uint8(outputImage));

%% 2.(b)
I = imread('../DatasetA/car-1.jpg');
kernel_A = [ 1 2 1; 2 4 2 ; 1 2 1];
kernel_B = [ 0 1 0; 1 -4 1; 0 1 0];
imgA = ICV_imageFiltering(I, kernel_A);
imgB = ICV_imageFiltering(I, kernel_B);
figure(1),imshow(uint8(imgA));
figure(2),imshow(uint8(imgB));

%% 2.(c)
I = imread('../DatasetA/car-1.jpg');
kernel_A = [ 1 2 1; 2 4 2; 1 2 1];
kernel_B = [ 0 1 0; 1 -4 1; 0 1 0];

C1_AA = ICV_imageFiltering(I, kernel_A);
C1_AA = ICV_imageFiltering(C1_AA, kernel_A);

C2_AB = ICV_imageFiltering(I, kernel_A);
C2_AB = ICV_imageFiltering(C2_AB, kernel_B);

C3_BA = ICV_imageFiltering(I, kernel_B);
C3_BA = ICV_imageFiltering(C3_BA, kernel_A);

figure(1), imshow(uint8(C1_AA));
figure(2), imshow(uint8(C2_AB));
figure(3), imshow(uint8(C3_BA));

%% 2.(d)
I = imread('../DatasetA/car-1.jpg');
% %kernel (5*5)
A5=[0.0005    0.0049    0.0108    0.0049    0.0005;
    0.0049    0.0521    0.1142    0.0521    0.0049;
    0.0108    0.1142    0.2504    0.1142    0.0108;
    0.0049    0.0521    0.1142    0.0521    0.0049;
    0.0005    0.0049    0.0108    0.0049    0.0005;];
B5 =[0     0     0     0     0;
     0     0     1     0     0;
     0     1    -4     1     0;
     0     0     1     0     0;
     0     0     0     0     0;];
 
% %kernel (7*7)
A7=[0.0000    0.0000    0.0001    0.0002    0.0001    0.0000    0.0000;
    0.0000    0.0005    0.0049    0.0108    0.0049    0.0005    0.0000;
    0.0001    0.0049    0.0520    0.1140    0.0520    0.0049    0.0001;
    0.0002    0.0108    0.1140    0.2500    0.1140    0.0108    0.0002;
    0.0001    0.0049    0.0520    0.1140    0.0520    0.0049    0.0001;
    0.0000    0.0005    0.0049    0.0108    0.0049    0.0005    0.0000;
    0.0000    0.0000    0.0001    0.0002    0.0001    0.0000    0.0000;];
B7 =[0     0     0     0     0     0     0;
     0     0     0     0     0     0     0;
     0     0     0     1     0     0     0;
     0     0     1    -4     1     0     0;
     0     0     0     1     0     0     0;
     0     0     0     0     0     0     0;
     0     0     0     0     0     0     0;];

% Alternative Laplacian mask, we can try to use different methods to
% generate our larger size Laplacian masks. The result is very interesting. 
% B5 = ICV_LaplacianMask(5);
% B7 = ICV_LaplacianMask(7);
    
D1_AA = ICV_imageFiltering(I, A5);
D1_AA = ICV_imageFiltering(D1_AA, A5);

D2_AB = ICV_imageFiltering(I, A5);
D2_AB = ICV_imageFiltering(D2_AB, B5);

D3_BA = ICV_imageFiltering(I, B5);
D3_BA = ICV_imageFiltering(D3_BA, A5);

%please comment the replicate part above and 
%uncomment this part to implement the function of 7*7 kernel
% D1_AA = ICV_imageFiltering(I, A7);
% D1_AA = ICV_imageFiltering(D1_AA, A7);
% 
% D2_AB = ICV_imageFiltering(I, A7);
% D2_AB = ICV_imageFiltering(D2_AB, B7);
% 
% D3_BA = ICV_imageFiltering(I, B7);
% D3_BA = ICV_imageFiltering(D3_BA, A7);

figure(1), imshow(uint8(D1_AA));
figure(2), imshow(uint8(D2_AB));
figure(3), imshow(uint8(D3_BA));
