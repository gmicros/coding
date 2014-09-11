%% DKs NN assignment

%% PART A
% Apply the delta rule train a single percepton using a tansigmoid 
% activation fnction to determine if the inut is '2'
clear; clc; close all

load('assignment2.mat');

trainSet = [(TRAINING(:,2:end)-8)/16, ones(size(TRAINING,1),1)];
trainLab = 2*(TRAINING(:,1) == 2) - 1;

testSet = [(TESTING(:,2:end)- 8)/16, ones(size(TESTING,1),1)];
testLab = 2*(TESTING(:,1) == 2) - 1;

clear TRAINING TESTING NUMERIC RAW TXT ans

inputs = size(trainSet,2);
alpha = 0.1;
iter = 40;
% input weights
Wij = 2*rand(inputs,1) - 1;

 
% TRAIN NETWORK
for i = 1:iter
    % acivaion function of weighted input
    Hj = trainSet*Wij;
    Yij = tanh(Hj);
    % output error
    err = trainLab - Yij;
    
    % derivative of activation function
    delYij = sech(Yij).^2;
    
    % delta rule and weight update
    deltaWij = alpha*(err.*delYij)'*trainSet;  
    Wij = Wij + deltaWij';
    
    MSE(i) = mean(err.^2);
end

plot(1:iter, MSE);
title('Training error');
xlabel('iterations');
ylabel('MSE');

% TEST 
Y = 2*(tanh(testSet*Wij) > 0.9) - 1;
MSE = mean((testLab - Y).^2);
fprintf(1,'MSE:  %g\n', MSE);


%% PART B
% Apply backpropogation to train a three-layer MLP having tansigmoid
% function

clear; clc; close all

load('assignment2.mat');

trainSet = [(TRAINING(:,2:end)-8)/160, ones(size(TRAINING,1),1)];
trainLab = 2*[(TRAINING(:,1) == 0 ),... 
            (TRAINING(:,1) == 1 ),...
            (TRAINING(:,1) == 2 ),...
            (TRAINING(:,1) == 3 ),...
            (TRAINING(:,1) == 4 ),...
            (TRAINING(:,1) == 5 ),...
            (TRAINING(:,1) == 6 ),...
            (TRAINING(:,1) == 7 ),...
            (TRAINING(:,1) == 8 ),...
            (TRAINING(:,1) == 9 )] - 1;
    

testSet = [(TESTING(:,2:end)- 8)/160, ones(size(TESTING,1),1)];
testLab = 2*[(TESTING(:,1) == 0 ),... 
            (TESTING(:,1) == 1 ),...
            (TESTING(:,1) == 2 ),...
            (TESTING(:,1) == 3 ),...
            (TESTING(:,1) == 4 ),...
            (TESTING(:,1) == 5 ),...
            (TESTING(:,1) == 6 ),...
            (TESTING(:,1) == 7 ),...
            (TESTING(:,1) == 8 ),...
            (TESTING(:,1) == 9 )] - 1;

clear TRAINING TESTING NUMERIC RAW TXT ans

inputs = size(trainSet,2);
hidden = 15; 
output = 10;
alpha = 0.001;
iter = 1000;

G = @(x) tanh(x);
Gprime = @(x) sech(x).^2;


% Weights
Wij = 2*rand(inputs,hidden) - 1;
Wjk = 2*rand(hidden + 1,output); - 1;

for i = 1:iter
    Hj = trainSet*Wij;
%     Yij = [tanh(Hj), ones(size(trainSet,1),1)];
    Yij = [G(Hj), ones(size(trainSet,1),1)];

    Hk = Yij*Wjk;
    Yjk = G(Hk);    
    
    err = trainLab - Yjk;
    
    delYjk = Gprime(Yjk);
    delERR = (err.*delYjk)';
    deltaWjk = alpha.*delERR*Yij;
    
    delYij = Gprime(Yij);
    deltaWij = alpha*((delERR'*Wjk')'.*delYij')*trainSet;
    
    Wjk = Wjk + deltaWjk';
    Wij = Wij + deltaWij(1:end-1,:)';
    
    MSE(i) = mean(mean(err.^2));
end


plot(1:iter, MSE);
title('Training error');
xlabel('iterations');
ylabel('MSE');

% TEST 
Y = 2*(([tanh(testSet*Wij), ones(size(testSet,1),1)]*Wjk) > 0.9) - 1;
MSE = mean(mean((testLab - Y).^2));
fprintf(1,'MSE:  %g\n', MSE);