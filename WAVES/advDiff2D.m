%% 2D ADVECTION-DIFFUSION EQUATION 
%   Ut + Ux = Uxx
%   forward time, centered space

clear; clc; close all

maxX = 2*pi; 
maxY = 2*pi;
maxT = 10; 

numX = 70; 
numY = 70; 
numT = 5001;


hx = maxX/(numX-1); 
hy = maxY/(numY-1); 
h = hx^2 + hy^2; 
k = maxT/(numT-1);



D = .05;
V = 1;

h
crtr1 = 2*D/V
k
crit2 = h^2/(2*D)

J = zeros(numX, numY); 
% initial  conditions 
x = (0:hx:maxX)';
y = (0:hy:maxY)';

X = numX/2; 
Y = numY/2; 
R = 10;

for i = 2:numX-1
    for j = 2:numY-1
        J(i,j,1) = exp(- (((i-X)/R)^2 + ((j-Y)/R)^2));
    end
end

% J = sin((x - pi) * ((y - pi))');
surf(J,'EdgeColor', 'none')


explX = spdiags((k/(2*hx^2)).*[(2*D-V*hx)*ones(numX,1),...
                                (- 4*D)*ones(numX,1),...
                                (2*D+V*hx)*ones(numX,1)] , [-1,0,1], numX, numX);
                            
explY = spdiags((k/(2*hx^2)).*[(2*D+V*hy)*ones(numX,1),...
                                (- 4*D)*ones(numX,1),...
                                (2*D-V*hy)*ones(numX,1)] , [-1,0,1], numY, numY);
                            
                            
                            
fig1=figure(1);
winsize = get(fig1,'Position');
winsize(1:2) = [0 0];
A=moviein(100,fig1,winsize);                            
                            

for tt = 1:numT
    H = J + J*explX + explY*J;
    
    
    H(1,:) = ((k/(2*h^2))*(2*D + V*h)*J(end-1,:)...
                     + (1 - (2*D*k/(h^2)))*J(end,:)...   
                     + (k/(2*h^2))*(2*D - V*h)*J(2,:));
    
    
    H(:,1) = ((k/(2*h^2))*(2*D + V*h)*J(:,end-1)...
                     + (1 - (2*D*k/(h^2)))*J(:,end)...   
                     + (k/(2*h^2))*(2*D - V*h)*J(:,2));
%     H(:,1) = 0; 
    H(end,:) = (H(1,:));
    H(:,end) = (H(:,1));
%     
    
    J = H;
    
    [az, el] = view;
%     surf(J,'EdgeColor', 'none')
    imagesc(J);
    view(az, el);
 
    pause(.01);
end                            
                            