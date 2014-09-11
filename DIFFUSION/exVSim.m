% EXPLICIT VS IMPLICIT FINITE DIFFERENCE

clear; clc; close all


x0 = 0; 
x1 = 1; 
numX = 10; 
dx = (x1 - x0)/(numX-1);
x = x0:dx:x1;

dur = .01;
numT = 1000; 
dt = dur/(numT - 1);


sig = dt/(dx^2);
iter = 1/dt;

A = zeros(floor(numX), floor(numT)-1); 
A(:,1) = sin(pi*x);
B = A;
C = A;
exact = sin(pi*x)'*exp(-(0:dt:dur)*pi^2);

explX = spdiags([sig*ones(numX,1), (1-2*sig)*ones(numX,1), sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);           
implX = spdiags([-sig*ones(numX,1), (1+2*sig)*ones(numX,1), -sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);
            
            
explC = spdiags([sig*ones(numX,1), (2-2*sig)*ones(numX,1), sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);            
implC = spdiags([-sig*ones(numX,1), (2+2*sig)*ones(numX,1), -sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);            
for i = 1:numT
   A(:,i+1) = explX*A(:,i); 
   B(:,i+1) = implX\B(:,i);
   C(:,i+1) = implC\explC*C(:,i);
   
   A(1,i+1) = 0; A(end,i+1) = 0;
   B(1,i+1) = 0; B(end,i+1) = 0;
   C(1,i+1) = 0; C(end,i+1) = 0;
end

U_exact = exp(-pi^2*dur)*sin((pi)*x);

MSE1 = mean((B(:,end)' - U_exact).^2);
MSE2 = mean((C(:,end)' - U_exact).^2);

fprintf(1,'%d\t%f\t%f\t%f \n', numX, sig, MSE1, MSE2)

surf(A(:,1:end-1), 'EdgeColor', 'none');
figure;
surf(B(:,1:end-1), 'EdgeColor', 'none');
figure; 
surf(exact, 'EdgeColor', 'none');
figure; 
surf(C(:,1:end-1), 'EdgeColor', 'none');


figure;
plot(x, exact(:,end),'--r');
hold on;
plot(x, C(:,end),'--b');
figure;
plot(x, exact(:,end),'--r');
hold on;
plot(x, B(:,end),'--b');
figure;
plot(x, exact(:,end),'--r');
hold on;
plot(x, A(:,end),'--g');