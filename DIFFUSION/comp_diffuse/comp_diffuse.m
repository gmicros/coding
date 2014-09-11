%% COMPARATIVE METHODS 
%% i)   for loop to evaluat each time point
%% ii)  toeplitz matrix of diffusion 
%% iii) applied to the same matrix

clear; clc; close all


numX = 50; 
numY = 50;
numT = 2;

dx = 1/(numX + 1);
dy = 1/(numY + 1);
dt = .000005;

T = 2;
X = 10;
Y = 10;
R = 5;
K = 1;

C = zeros(numX, numY, numT);

C(1,:,1) = 0;
C(numX,:,1)= 0;

C(:,1,1) = 0;
C(:,numY,1)= 0;

for i = 2:numX-1
    for j = 2:numY-1
        C(i,j,1) = T*( (((i-X)/R)^2 + ((j-Y)/R)^2) < 1);
    end
end
 
lineX = [K*(dt/(dx^2)).*[1 , 1 - 2, 1], zeros(1, numX-2)]; 
coefX = toeplitz([dt/(dx^2) zeros(1,numX)], lineX);
coefX = coefX(1:end-1, 2:end);

lineY = [K*(dt/(dy^2)).*[1, - 2, 1], zeros(1, numY-2)]; 
coefY = toeplitz([dt/(dy^2) zeros(1,numY)], lineY);
coefY = coefY(1:end-1, 2:end);


tic;
B = C(:,:,1); 
B = C(:,:,1) + coefX*C(:,:,1) + C(:,:,1)*coefY;
toc

tic
B = C(:,:,1); 
B = B + coefX*B + B*coefY;
toc

tic
for k = 1:numT
   for i = 2:numX-1
      for j = 2:numY-1
         C(i,j,k+1)  = C(i,j,k) +...
         K*dt*((C(i+1,j,k) - 2*C(i,j,k) + C(i-1,j,k))/(dx^2)...
           + (C(i,j+1,k) - 2*C(i,j,k) + C(i,j-1,k))/(dy^2)); 
      end
   end
end
toc


figure;
surf(C(:,:,2))
figure;
B = coefX*C(:,:,1) + C(:,:,1)*coefY; 
surf(B);



