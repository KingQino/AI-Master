ICV_Main.m is the main script. There has been all solutions of the questions in this assignment, and you can use it to run any ICV functions which I have finished. Please remember that you maybe need to uncomment or comment the code to implement different parts in this script.

The key functions:
1.[newImage] = ICV_imageRotate(image, angle)
--Rotate the image by angle degree(s) colockwise. And return a new image.
e.g. A = imread('ICV_Q1.png');
     imshow(ICV_imageRotate(A,30));
---------------------------------------------------------------------------
2.[newImage] = ICV_imageSkew(image, angle)
--Skew the image by angle degree(s) along the y-axis. And return a new image.
e.g. A = imread('ICV_Q1.png');
     imshow(ICV_imageSkew(A,30));
---------------------------------------------------------------------------
3.[newImage] = ICV_imageFiltering(image, kernel)
--Using the kernel to make convolution operation with the image. And return a new image.
e.g. I = imread('DatasetA/car-1.jpg');
     kernel = ones(3, 3);
     outputImage = ICV_imageFiltering(I, kernel);
     imshow(outputImage);
---------------------------------------------------------------------------
4.[Histogram] = ICV_colorHistogram(image)
--Input image, the function will return the Histograms of the image. 
e.g. I = imread('DatasetA/car-1.jpg');
     H = ICV_colorHistogram(I);
---------------------------------------------------------------------------
5.[output] = ICV_histogramIntersection(Histogram1,Histogram2)
--Input two Histograms, the function will return the intersection of them.
e.g. I1 = imread('DatasetA/car-1.jpg');
     I2 = imread('DatasetA/car-2.jpg');
     H1 = ICV_colorHistogram(I1);
     H2 = ICV_colorHistogram(I2);
     output = ICV_histogramIntersection(H1, H2);

Other assistant functions:
1.[gray_img] = ICV_rgb2grayscale(image)
--Input an image, return the gray level of the image
e.g. I = imread('DatasetA/car-1.jpg');
     grayImg = ICV_rgb2grayscale(I);
---------------------------------------------------------------------------
2.normalizedKernel = ICV_Normalization(kernel)
--Input the kernel, and return the normalized kernel
e.g. Kernel = ones(3);
     nKernel = ICV_Normalization(Kernel);
---------------------------------------------------------------------------
3.mask = ICV_LaplacianMask(n)
--Input a number n, return a Laplacian mask of n by n
e.g. L = ICV_LaplacianMask(7);

