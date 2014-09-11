clear; clc; close all

load iris_dataset;

irisInputs = [(irisInputs - mean(irisInputs)/std(irisInputs)); .99*ones(1, size(irisInputs,2))]';
irisTargets = irisTargets';

numIn = size(irisInputs,2);
numHidden = 4;
numOut = size(irisTargets,2);

Wij = rand(numIn,numHidden) - 0.5;
Wjk = rand(numHidden+1,numOut) - 0.5;
alpha = .01;
%err = zeros(size(irisInputs,1),numOut);
training = [irisInputs(1:40,:); irisInputs(51:90,:); irisInputs(101:140,:); ];
trainTarg = [irisTargets(1:40,:); irisTargets(51:90,:); irisTargets(101:140,:)] ;
testing = [irisInputs(41:50,:); irisInputs(91:100,:); irisInputs(141:150,:)];



iter = 1000;

for i = 1:iter

   %% FEED-FORWARD
   % hidden layer output
   Xj = training;
   Yj = [1./(1+exp(-Xj*Wij)), .99*ones(size(training,1),1)]; 
   % final layer output
   Yk = 1./(1+exp(-Yj*Wjk));
   %% BACK PROPOGATION
   % output error
   Tj = trainTarg;
   err(:,:,i) = (Tj - Yk);
   % derivative with respect to output
   fprimeK = Yk .* (1 - Yk);
   % derivative with respect to inout weights
   fprimeJ = Yj .* (1 - Yj);
   % delta rule for output weights
   deltaK = err(:,:,i).*fprimeK;
   %delta rule for hidden weights
   deltaJ = (deltaK*Wjk')'.*fprimeJ';
   
   
   DelK = alpha*deltaK'*Yj;
   DelJ = alpha*deltaJ*Xj;
   
   Wij = Wij + DelJ(1:numHidden,:)';
   Wjk = Wjk + DelK';
   
   MSE(i,1) = mean(mean(err(:,:,i).^2));
end

plot(MSE);