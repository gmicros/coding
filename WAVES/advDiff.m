%% ADVECTION-DIFFUSION EQUATION 
%   Ut + Ux = Uxx
%   forward time, centered space

clear; clc; close all

maxX = 2*pi; 
maxT = 2; 

numX = 70; 
numT = 501;

h = maxX/(numX-1); 
k = maxT/(numT-1);



D = .05;
V = 2;

h
crtr1 = 2*D/V
k
crit2 = h^2/(2*D)

U = zeros(numX, numT); 
J = zeros(numX, 1); 
% initial  conditions 
x = (0:h:maxX)';
U(:,1) = sin(x);
J = sin(x)';


explX = spdiags((k/(2*h^2)).*[(2*D-V*h)*ones(numX,1),...
                                ((2*h^2)/k - 4*D)*ones(numX,1),...
                                (2*D+V*h)*ones(numX,1)] , [-1,0,1], numX, numX);


for tt = 1:numT
    
    for xx = 2:numX-1
        U(xx,tt+1) = (k/(2*h^2))*(2*D + V*h)*U(xx-1,tt)...
                     + (1 - (2*D*k/(h^2)))*U(xx,tt)...   
                     + (k/(2*h^2))*(2*D - V*h)*U(xx+1,tt);
    end
    
    U(1,tt+1) = (k/(2*h^2))*(2*D + V*h)*U(end-1,tt)...
                     + (1 - (2*D*k/(h^2)))*U(end,tt)...   
                     + (k/(2*h^2))*(2*D - V*h)*U(2,tt);
    U(end,tt+1) = U(1,tt+1);
                
    H = J*explX;
    
    H(1) = (k/(2*h^2))*(2*D + V*h)*J(end-1)...
                     + (1 - (2*D*k/(h^2)))*J(end)...   
                     + (k/(2*h^2))*(2*D - V*h)*J(2);
    H(end) = H(1);
    J = H;
    
    plot(U(:,tt+1),'-g'); 
    plot(J);
    axis([0, numX, -1, 1]);
    pause(.001);
end
    hold on
    U_exact = exp(-D*maxT)*sin((x-V*maxT));
    plot(U_exact, '-r')

% figure; plot(Y(end,:));
% axis([0, numX, -1, 1]);
% t = 1;
% X = 0.5*exp(-4*pi*pi*D*t)*sin(4*pi*(x*dx - t));
% hold on; plot(X, '-r'); axis([0, numX, -1, 1]);