%% 

clear; clc; close all

x0 = 0;
x1 = 1;
numX = 50; 
dx = (x1 - x0)/(numX - 1);
x = x0:dx:x1;

y0 = 0; 
y1 = 1;
numY = 50;
dy = (y1 - y0)/(numY - 1);
y = y0:dy:y1;

duration = .2;
numT = 20000;
dt = duration/(numT - 1);

K = 1;
rx = K*(dt/dx)^2;
ry = K*(dt/dy)^2;

sx = K*(dt/dx^2);
sy = K*(dt/dy^2);

U(:,:) = exp(-100*(x-0.5).^2)'* exp(-100*(y-0.5).^2); 
U(:,:,2) = U(:,:,1);

surf(U(:,:,1), 'EdgeColor', 'none');


ex = ones(5, 1);
tempx = spdiags([sx*ex, (-2*sx)*ex, sx*ex], -1:1, 5, 5);
Ax = eye(numX, numX);
Ax(1:5,1:5) = tempx; 
Ax(46:50,46:50) = tempx;


ey = ones(numY,1);
Ay = spdiags([sy*ey, (-2*sy)*ey, sy*ey], -1:1, numY, numY);


for k = 2:10*numT
%    for i = 5:numX-5
%       for j = 5:numY-5
%          U(i,j,k+1) = (2 - 2*rx - 2*ry)*U(i,j,k) +...
%                         rx*(U(i-1,j,k) + U(i+1,j,k)) +...
%                         ry*(U(i,j-1,k) + U(i,j+1,k)) - U(i,j,k-1);
%       end
%    end
    
   U(:,:,k+1) = U(:,:,k) + (Ax*U(:,:,k) + U(:,:,k)*Ax);
   
   [az, el] = view;
   surf(U(:,:,k), 'EdgeColor', 'none');
   axis([0 numX 0 numY 0 1]);
   view(az, el);
   pause(.00001);
end