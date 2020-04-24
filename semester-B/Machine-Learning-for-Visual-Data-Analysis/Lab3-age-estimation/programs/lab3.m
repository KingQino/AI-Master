%% information
% facial age estimation
% regression method: linear regression

%% settings
clear;
clc;

% path 
database_path = 'data_age.mat';
result_path = 'results/';

% initial states
absTestErr = 0;
cs_number = 0;


% cumulative error level
err_level = 5;

%% Training 
load(database_path);

nTrain = length(trData.label); % number of training samples
nTest  = length(teData.label); % number of testing samples
xtrain = trData.feat; % feature
ytrain = trData.label; % labels

w_lr = regress(ytrain,xtrain);
   
%% Testing
xtest = teData.feat; % feature
ytest = teData.label; % labels

yhat_test = xtest * w_lr;

%% Compute the MAE and CS value (with cumulative error level of 5) for linear regression 
MAE = mean(abs(yhat_test - ytest));

CS = sum (abs(yhat_test - ytest) <= err_level)/ nTest;

%% generate a cumulative score (CS) vs. error level plot by varying the error level from 1 to 15. The plot should look at the one in the Week6 lecture slides
CS_plot = zeros(15,1);
for err_level = 1:15
    CS_plot(err_level, 1) =  sum (abs(yhat_test - ytest) <= err_level)/ nTest;
end
figure
plot((1:15), CS_plot, 'b--o');
title('Accuracy vs. Error Level (FG-NET)');
xlabel('Error Level (years)');
ylabel('Cumulative Score');

%% Compute the MAE and CS value (with cumulative error level of 5) for both partial least square regression and the regression tree model by using the Matlab built in functions.
err_level = 5;

% Partial least square regression
[~, ~, ~, ~, BETA] = plsregress(xtrain, ytrain);
yhat_test_pls = [ones(size(xtest,1),1) xtest]*BETA;

MAE_pls = mean(abs(yhat_test_pls - ytest));
CS_pls = sum (abs(yhat_test_pls - ytest) <= err_level)/ nTest;

% the regression tree model
tree = fitrtree(xtrain,ytrain);
yhat_test_tree = predict(tree,xtest);

MAE_tree = mean(abs(yhat_test_tree - ytest));
CS_tree = sum (abs(yhat_test_tree - ytest) <= err_level)/ nTest;

%% Compute the MAE and CS value (with cumulative error level of 5) for Support Vector Regression by using LIBSVM toolbox
addpath(genpath('libsvm-3.14'));

% set the parameters via cross-validation! Elapsed time is 540.564505 seconds.
% bestc=256, bestg=0.03125, bestcv=55.8232
% bestc=0;bestg=0;
% bestcv=99999;
% tic 
% for log2c = -1:10,
%   for log2g = -5:0.1:1.5,
%     cmd = ['-s 3 -v 10 -t 2 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%     cv = svmtrain(ytrain, xtrain, cmd);
%     if (cv <= bestcv),
%       bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
%     end
%     fprintf('(best c=%g, g=%g, rate=%g)\n', bestc, bestg, bestcv);
%   end
% end
% toc 
bestc = 256;
bestg = 0.03125;

options=sprintf('-s 3 -t 2 -c %f -g %f -b 1',bestc,bestg);
model=svmtrain(ytrain, xtrain, options);

[yhat_test_svr, ~, ~] = svmpredict(ytest,xtest, model);

err_level = 5;
MAE_svr = mean(abs(yhat_test_svr - ytest));
CS_svr = sum (abs(yhat_test_svr - ytest) <= err_level)/ nTest;


