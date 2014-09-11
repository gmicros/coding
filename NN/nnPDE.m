%% NN PDE

clear; clc; close all

a = 0;
b = 1;
numX = 100; 
dX = (b-a)/(numX - 1);

duration = .2;
numT = 2000 - 1;
dT = duration/numT;

K = 1;

r = K*(dT/dX^2);

e = ones(numX, 1);
A = spdiags([-r*e, (1+2*r)*e, -r*e], -1:1,numX, numX);  
% A(1,:) = 0;
% A(end,:) = 0;


x = zeros(numX,numT);
x(:,1) = sin(pi*(a:dX:b));

for i = 1:numT
   x(:,i+1) = A\x(:,i);
   
   x(1,i+1) = 0;
   x(end,i+1) = 0;
end

surf(x, 'EdgeColor', 'none');
figure;

%%
inputs = numX;
hidden = 100; 
output = numX;
alpha = 0.01;
iter = 500;

G = @(x) tanh(x);
Gprime = @(x) sech(x).^2;


% Weights
Wij = 2*rand(inputs,hidden) - 1;
Wjk = 2*rand(hidden + 1,output); - 1;

X = x(:,1)';
Y = x(:,end/2)';

for i = 0:iter
   
    Hj = X*Wij;
%     Yij = [tanh(Hj), ones(size(trainSet,1),1)];
    Yij = [G(Hj), ones(size(X,1),1)];

    Hk = Yij*Wjk;
    Yjk = G(Hk);    
    
    err = Y - Yjk;
    x_nn(i+1,:) = Yjk;
    
    delYjk = Gprime(Yjk);
    delERR = (err.*delYjk)';
    deltaWjk = alpha.*delERR*Yij;
    
    delYij = Gprime(Yij);
    deltaWij = alpha*((delERR'*Wjk')'.*delYij')*X;
    
    Wjk = Wjk + deltaWjk';
    Wij = Wij + deltaWij(1:end-1,:)';
    
    MSE(i+1) = mean(mean(err.^2));
end


plot(MSE);
title('Training error');
xlabel('iterations');
ylabel('MSE');

% figure;
% surf(x_nn, 'EdgeColor', 'none');
x_final = x(:,1);
% % x_final = [G(x_final(:,1)*Wij), ones(numX,1)]*Wjk;
% 

ts = exp(-100*((a:dX:b)-0.5).^2);
% x_final = G([G(x(:,1)'*Wij), 1]*Wjk);
x_final = G([G(ts*Wij), 1]*Wjk);
figure; plot(x_final);

% figure
% surf(x_final, 'EdgeColor', 'none');
