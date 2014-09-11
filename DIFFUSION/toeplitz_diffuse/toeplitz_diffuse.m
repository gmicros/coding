%%  TOEPLITZ DIFFUSE

clear; clc; close all ;


numX = 50; 
numY = 50;
numT = 200;

dx = 1/(numX + 1);
dy = 1/(numY + 1);
dt = .000005;

T = 100;
X = 25;
Y = 25;
R = 20;
K = 1;

B = zeros(numX, numY);

B(1,:) = 0;
B(numX,:)= 0;

B(:,1) = 0;
B(:,numY)= 0;

for i = 2:numX-1
    for j = 2:numY-1
        B(i,j) = T*( (((i-X)/R)^2 + ((j-Y)/R)^2) < 1);
    end
end
 
% X diffusion matrix
lineX = [K*(dt/(dx^2)).*[1 , -2, 1], zeros(1, numX-2)]; 
coefX = toeplitz([dt/(dx^2) zeros(1,numX)], lineX);
coefX = coefX(1:end-1, 2:end);
% Y diffusion matrix
lineY = [K*(dt/(dy^2)).*[1, - 2, 1], zeros(1, numY-2)]; 
coefY = toeplitz([dt/(dy^2) zeros(1,numY)], lineY);
coefY = coefY(1:end-1, 2:end);



for i = 1:1000;
    
    B(1,2:end-1) = B(2,2:end-1);
    B(end,2:end-1) = B(end-1,2:end-1);
    
    B(2:end-1,1) = B(2:end-1,2);
    B(2:end-1,end) = B(2:end-1, end-1);      
    
    B = B + coefX*B + B*coefY;
%     B(2:end-1,2:end-1) = B(2:end-1,2:end-1) + coefX(2:end-1,2:end-1)*B(2:end-1,2:end-1) + B(2:end-1,2:end-1)*coefY(2:end-1,2:end-1);
    

    
    energy(i) = squeeze(sum(sum(B(2:end-1,2:end-1),1),2));
    
    
    
    imagesc(B);
%     surf(B(2:end-1,2:end-1), 'EdgeColor', 'none');
%     axis([0 numX 0 numY 0 T+.1*T]);
    pause(.0000001);
end

figure;
plot(energy)



