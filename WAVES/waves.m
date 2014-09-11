%% 1D WAVE EQUATION


clear; clc; close all

numX = 100;
dx = 1/numX;

dt = .001;

iter = 10000;

% 
% for i = 1:numX
%    C(i,1) = double(sin(pi*i/50));
% end

% plot(C(:,1))

for i = 1:numX
   C(i,1) = exp(-((i-50)/10)^2) ;
end


C(1,1:iter) = 0;
C(numX,1:iter) = 0;

sig = dt^2/dx^2;

for i = 2:numX-1
   C(i,2) = (1-sig)*C(i,1) + (sig/2)*C(i-1,1) + (sig/2)*C(i+1,1); 
end

for j = 3:iter
    for i = 2:numX-1
        C(i,j) = 2*(1-sig)*C(i,j-1) + sig*C(i-1,j-1) + sig*C(i+1,j-1) - C(i,j-2); 
    end
end


for i = 1:iter
   plot(C(:,i));
   axis([0 100 -1.5 1.5]);
   pause(.00001);
end

