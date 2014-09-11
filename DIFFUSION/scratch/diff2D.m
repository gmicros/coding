%% HEAT EQUATION

clear; clc; close all

%%  VARIABLES

x0      = 0;
x1      = 1;
numX    = 100;
dX      = (x1 - x0)/(numX-1);
x       = x0:dX:x1;

y0      = 0;
y1      = 1;
numY    = 100;
dY      = (y1 - y0)/(numY-1);
y       = y0:dY:y1;

numT    = 600;
time    = .01;
dT      = time/(numT-1);
%% INITIAL CONDITIONS
Umax = 2;
X = .5;
Y = .5;
R = .2;
K = 1;

%% EXPLICIT SOLUTION
Uexpl = Umax*(exp(-((x - X)/R).^2)'* (exp(-((y - Y)/R).^2)));

rx      = K*(dT/dX^2);
e       = ones(numX,1);
explX   = spdiags([rx.*e, (0.5-2*rx).*e, rx.*e], -1:1, numX, numX);

ry      = K*(dT/dY^2);
e       = ones(numY,1);
explY = spdiags([ry.*e, (0.5-2*ry).*e, ry.*e], -1:1, numY, numY);


L = kron(explX, speye(numX)) + kron(speye(numY), explY);


Uexpl = reshape(Uexpl,1,10000);
for i = 1:numT
    %U = explX*U + U*explY;
    Uexpl = Uexpl*L;
    
    % Boundrary Condition
    Uexpl = reshape(Uexpl, 100, 100);
    Uexpl(1,:)   = 0;
    Uexpl(end,:) = 0;
    Uexpl(:,1)   = 0;
    Uexpl(:,end) = 0;
    
    % elapsed plotting
    surf(Uexpl, 'EdgeColor', 'none');
    axis([0 numX 0 numY 0 Umax]);
    pause(0.01);
    % reshape to array
    Uexpl = reshape(Uexpl,1,10000);
end
Uexpl = reshape(Uexpl, 100, 100);
max(max(Uexpl))

% final solution plotting
% figure;
% surf(Uexpl, 'EdgeColor', 'none');
% axis([0 numX 0 numY 0 Umax]);
%% IMPLICIT SOLUTION
Uimpl = Umax*(exp(-((x - X)/R).^2)'* (exp(-((y - Y)/R).^2)));

rx      = K*(dT/dX^2);
e       = ones(numX,1);
implX   = spdiags([-rx.*e, (0.5+2*rx).*e, -rx.*e], -1:1, numX, numX);

ry      = K*(dT/dY^2);
e       = ones(numY,1);
implY = spdiags([-ry.*e, (0.5+2*ry).*e, -ry.*e], -1:1, numY, numY);

L = kron(implX, speye(numX)) + kron(speye(numY), implY);
Uimpl = reshape(Uimpl,1,10000);
for i = 1:numT
    %    U = inv(explX)*U + U*inv(explY);
    Uimpl = reshape(Uimpl,1,10000);
    Uimpl = Uimpl/L;
    
    % Boundrary Condition
    Uimpl = reshape(Uimpl, 100, 100);
    Uimpl(1,:)   = 0;
    Uimpl(end,:) = 0;
    Uimpl(:,1)   = 0;
    Uimpl(:,end) = 0;
    
    
    surf(Uimpl, 'EdgeColor', 'none');
    axis([0 numX 0 numY 0 Umax]);
    pause(0.001);
    
    Uexpl = reshape(Uexpl,1,10000);
end
max(max(Uimpl))
Uimpl = reshape(Uimpl, 100, 100);
% figure;
% surf(Uimpl, 'EdgeColor', 'none');
% axis([0 numX 0 numY 0 Umax]);