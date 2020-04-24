%% 6.(a)
I1 = imread('DatasetA/face-3.jpg');
I1 = ICV_rgb2grayscale(I1);
Windows =  ICV_divideWindows(I1,4,4);
w1 = Windows{1};
w2 = Windows{8};
w3 = Windows{16};
figure(1), imshow(w1);
figure(2), imshow(w2);
figure(3), imshow(w3);

LBP_w1 = ICV_LBPimage(w1);
LBP_w2 = ICV_LBPimage(w2);
LBP_w3 = ICV_LBPimage(w3);
figure(4), imshow(LBP_w1);
figure(5), imshow(LBP_w2);
figure(6), imshow(LBP_w3);

h1_LBP = ICV_featureDescriptor(LBP_w1);
h2_LBP = ICV_featureDescriptor(LBP_w2);
h3_LBP = ICV_featureDescriptor(LBP_w3);
nor_h1_LBP = ICV_normalizeHistogram(h1_LBP);
nor_h2_LBP = ICV_normalizeHistogram(h2_LBP);
nor_h3_LBP = ICV_normalizeHistogram(h3_LBP);
X = (0: 255);
figure(7), bar(X,nor_h1_LBP(1,:)');
figure(8), bar(X,nor_h2_LBP(1,:)');
figure(9), bar(X,nor_h3_LBP(1,:)');

%% 6.(b)
I1 = imread('DatasetA/face-3.jpg');
I1 = ICV_rgb2grayscale(I1);
figure(1),imshow(I1);
descriptor1 = ICV_descriptorOfTheWholeImage(I1, 4, 4);
figure(2)
X = (0: 255);
for i = 1:size(descriptor1,1)
    bar(X*i,descriptor1(i,:)');
end

I2 = imread('DatasetA/car-1.jpg');
I2 = ICV_rgb2grayscale(I2);
figure(3),imshow(I2);
descriptor2 = ICV_descriptorOfTheWholeImage(I2, 4, 4);
figure(4)
for i = 1:size(descriptor2,1)
    bar(X*i,descriptor1(i,:)');
end

%% 6.(c)
face1 = imread('DatasetA/face-1.jpg');
face1 = ICV_rgb2grayscale(face1);
descriptor_face_1 = ICV_descriptorOfTheWholeImage(face1, 4, 4);
car1 = imread('DatasetA/car-1.jpg');
car1 = ICV_rgb2grayscale(car1);
descriptor_car_1 = ICV_descriptorOfTheWholeImage(car1, 4, 4);
% Label the two classes -- FACE & CAR
class_face = descriptor_face_1;
class_car = descriptor_car_1;
% class_face = ICV_averagedDescriptor(descriptor_face_1,descriptor_face_2);
% class_car = ICV_averagedDescriptor(descriptor_car_1,descriptor_car_2);

% import images
SamplePath = 'DatasetA/';
fileExt = '*.jpg';
[Test_dataset, numdata] = ICV_importFiles(SamplePath,fileExt);

confidence = zeros(1,numdata);

for i = 1:numdata
    greyImage = Test_dataset{1,i};
    sample = ICV_descriptorOfTheWholeImage(greyImage, 4, 4);
    [output, distance1, distance2]= ICV_classifier(class_face,class_car,sample);
    
    if output==1
        disp('Prediction: The input sample belongs to the first class FACE. ');
        if i <=3 % We have known that the previous three images are the class CAR
            confidence(1,i) = distance1/(distance1+distance2);
        else
            confidence(1,i) = distance2/(distance1+distance2);
        end           
    else
        disp('Prediction: The input sample belongs to the second class CAR. ');
        if i <=3 
            confidence(1,i) = distance1/(distance1+distance2);
        else
            confidence(1,i) = distance2/(distance1+distance2);
        end
    end   
    
end
X = 1:1:numdata;
figure
plot(X, confidence);
xlabel('sample');
ylabel('confidence');

%% 6.(d)(e)
% read a patch of files
SamplePath = 'DatasetA/';
fileExt = '*.jpg';
[Test_dataset, numdata] = ICV_importFiles(SamplePath,fileExt);

numbers_window = [1 4 9 16 25 36 49 64 81 100 121 144 169 196]; % 
n_sqrt = sqrt(numbers_window);
accuracy = zeros(1,size(numbers_window,2));
confidence = zeros(numdata, size(numbers_window,2));

   
for i = 1:size(numbers_window,2)
    window_size = n_sqrt(1,i);
    
    car1 = imread('DatasetA/car-1.jpg');
    car1 = ICV_rgb2grayscale(car1);
    face1 = imread('DatasetA/face-1.jpg');
    face1 = ICV_rgb2grayscale(face1);
    class_Car = ICV_descriptorOfTheWholeImage(car1, window_size, window_size);
    class_Face = ICV_descriptorOfTheWholeImage(face1, window_size, window_size);
    
    numPredictedCar = 0;
    numPredictedFace = 0;
    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;
    
    for j = 1:numdata
        image = Test_dataset{1,j};
        image = ICV_rgb2grayscale(image);
        sample = ICV_descriptorOfTheWholeImage(image, window_size, window_size);
        [prediction, distance_Car, distance_Face]= ICV_classifier(class_Car,class_Face,sample);
        
        % We have known that the previous 5 samples are class CAR, and the
        % latter 7 samples are Face
        if prediction == 1
            numPredictedCar= numPredictedCar +1;
            if j <= 3
                TP = TP +1;
                confidence(j, i) = distance_Face/(distance_Face+distance_Car);
            else
                FP = FP +1;
                confidence(j, i) = distance_Car/(distance_Face+distance_Car);
            end
        else
            numPredictedFace = numPredictedFace +1;
            if j <= 3
                FN = FN +1;
                confidence(j, i) = distance_Face/(distance_Face+distance_Car);
            else
                TN = TN +1;
                confidence(j, i) = distance_Car/(distance_Face+distance_Car);
            end              
        end
        
    end
    
    accuracy(1,i) = (TP+TN)/(TP+FP+FN+TN);
    
end

figure
plot(numbers_window, accuracy,'-o');
title('Classification Evaluation 1');
xlabel('Window Number');
ylabel('Accuracy');

figure
plot(numbers_window, confidence,'-o');
title('Classification Evaluation 2')
xlabel('Window Number');
ylabel('Confidence');



