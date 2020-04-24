function [Test_dataset,numdata] = ICV_importFiles(SamplePath,fileExt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

files = dir(fullfile(SamplePath,fileExt)); 
numdata = size(files,1);
Test_dataset = cell(1,numdata);
for i = 1:numdata
   fileName = strcat(SamplePath,files(i).name); 
   image = imread(fileName);
   image = ICV_rgb2grayscale(image);
   Test_dataset{1,i} = image;
end


end

