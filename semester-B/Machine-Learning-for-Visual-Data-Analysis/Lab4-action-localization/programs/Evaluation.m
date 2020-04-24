function Evaluation()
%Evaluation predict these image sequences into a class,
%   calculate the error rate and draw the confusion matrix 

load('struct_TP_FP');

% predict each image sequence into a class and the predicted 
% results are stored into predict_label 
predict_label = ones(3,10);
for i = 1:3 
    cl_sz = size(struct_TP_FP.class(i).seq,2);   
    for j = 1:cl_sz
        predict_label(i,j) = struct_TP_FP.class(i).seq(j).array(3,1);       
    end
end

% calculate the error rate
num_c = 3; % the number of class
num_pc = 10; % the number of predicted sequences for each class 
error_n = zeros(num_c,1); % the error number for each class
for k = 1:num_c
    error_n(k) = num_pc-length(find(predict_label(k,:)==k));
end 
err = error_n/num_pc; % the misclassification rate for each class 
err_all = sum(error_n)/(num_pc*num_c); % the misclassification for all the test data
disp(['error rate for class', num2str(1),': ',num2str(err(1))]);
disp(['error rate for class', num2str(2),': ',num2str(err(2))]);
disp(['error rate for class', num2str(3),': ',num2str(err(3))]);
disp(['the total error rate: ', num2str(err_all)]);

% draw the confusion matrix
num_class = 3;
confusion_matrix = ones(num_class);
class_names={...
    'boxing'
    'handclapping'
    'handwaving'
    };
for ci = 1:num_class
    for cj = 1:num_class
        confusion_matrix(ci,cj)=length(find(predict_label((ci-1)*1+1:ci,:)==cj))/num_pc;
    end 
end

figure;
draw_cm(confusion_matrix,class_names,num_class);

end

