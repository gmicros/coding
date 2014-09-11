%% IMPLICIT DIRECTIONAL


clear; clc; close all

%% SETTING UP GRID 
% x grids points
x0 = 0; 
x1 = 1;
numX = 60; 
dx = (x1 - x0)/(numX - 1);

% y grid points
y0 = 0; 
y1 = 1;
numY = 60; 
dy = (y1 - y0)/(numY - 1);

% time steps
dur = 5;
numT = 1000; 
dt = dur/(numT - 1);

% diffusion coeeficients
K = .5;
C = 0;


Kx = linspace(0,K,numX).^2;
Ky = linspace(0,K,numY).^2;

Cx = linspace(1,C,numX).^2;
Cy = linspace(0,0,numY).^2;

rx = (Kx*dt/(dx^2))';
ry = (Ky*dt/(dy^2))';

sx = (Cx*(dt/dx))';
sy = (Cy*(dt/dy))';


Ax = spdiags([-rx + sx/2, 2*ones(numX,1) + 2*rx, -rx - sx/2], -1:1, numX, numX);
Ay = spdiags([-ry + sy/2, 2*ones(numY,1) + 2*ry, -ry - sy/2], -1:1, numY, numY);

Bx = spdiags([sx/2, ones(numX,1), -sx/2], -1:1, numX, numX);
By = spdiags([sy/2, ones(numY,1), -sy/2], -1:1, numY, numY);

%% inital grid
x = linspace(x0,x1,numX);
y = linspace(y0,y1,numY);

U = exp(-50*(y-0.5).^2)'*exp(-50*(x-0.5).^2);
% U = sin(pi*y)'*sin(pi*x);

%% iteration
for i =   1:numT
    U = inv(Ax)*U + U*inv(Ax);
%    U = (U'/(Ay))' + U/Ax;
%    U = (U'/(By))' + U/Bx; 
   U(:,1) = (U(:,end)'/(Ay)) + U(:,end)'/Ax;
   U(:,end) = U(:,1);
%    U(:,1) = U(:,end);
   
   [az, el] = view;
   surf(U, 'EdgeColor', 'none');
%    caxis([0 1]);
%    axis([1, numX, 1, numY, 0, 3]);
   view([az, el]);
   pause(.01);
end

% U_exact = exp(-pi^2*dur)*(sin(pi*y')*sin(pi*x));
% 
% MSE = mean(mean((U-U_exact).^2))
% 
% surf(U, 'EdgeColor', 'none');
% axis([1, numX, 1, numY, 0, 1]);
% figure; 
% surf(U_exact, 'EdgeColor', 'none');
% axis([1, numX, 1, numY, 0, 1]);