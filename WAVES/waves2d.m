


clear; clc; close all

numX = 100;
dx = 1/numX;

numY = 100;
dy = 1/numY;

dt = .001;

iter = 50000;

sig = dt^2/(dx^2);



for j = 1:numY
    for i = 1:numX
       C(i,j,1) = 10*exp(-(((j-50)^2)/20 + ((i-50)^2)/20));
    end
end

% surf(C)

for j = 2:numY-1
    for i = 2:numX-1
       C(i,j,2) = (1-sig)*C(i,j,1) + (sig/2)*C(i-1,j,1) + (sig/2)*C(i+1,j,1)...
           + (sig/2)*C(i,j-1,1) + (sig/2)*C(i,j+1,1);
    end
end


lineX = [sig, -2*sig, sig];
diagX = diag(repmat(lineX(1),numX-1,1),-1)...
        + diag(repmat(lineX(2),numX,1),0)...
        + diag(repmat(lineX(3),numX-1,1),1);
        

lineY = [sig, -2*sig, sig];
diagY = diag(repmat(lineY(1),numX-1,1),-1)...
        + diag(repmat(lineY(2),numX,1),0)...
        + diag(repmat(lineY(3),numX-1,1),1);
    
    
for k = 3:iter
    
    % free surface
    C(1,:,k-1) = C(2,:,k-1);
    C(end,:,k-1) = C(end-1,:,k-1);
    
    C(:,1,k-1) = C(:,2,k-1);
    C(:,end,k-1) = C(:,end-1,k-1);
    
%     C(:,:,k) = 2*C(:,:,k-1) + diagX*C(:,:,k-1) + C(:,:,k-1)*diagY  - C(:,:,k-2);
    
    C(2:end-1,2:end-1,k) = (2*C(2:end-1,2:end-1,k-1)...
                    + diagX(2:end-1,2:end-1)*C(2:end-1,2:end-1,k-1)...
                    + C(2:end-1,2:end-1,k-1)*diagY(2:end-1,2:end-1) - C(2:end-1,2:end-1,k-2));
                
                
    
    
    [az, el] = view;
    surf(C(:,:,k));
    axis([0 numX 0 numY -5 5]);
    view(az, el);
    pause(.00001);
end    
    

% for k = 3:iter
%     C(2,:,k-1) = C(3,:,k-1);
%     C(end-2,:,k-1) = C(end-3,:,k-1);
%     
%     C(:,2,k-1) = C(:,3,k-1);
%     C(:,end-2,k-1) = C(:,end-3,k-1);
%     
%    for i = 2:numX-1
%       for j = 2:numY-1
%           
%           
%           C(i,j,k) = 2*(1-2*sig)*C(i,j,k-1) + sig*C(i-1,j,k-1) + sig*C(i+1,j,k-1) - C(i,j,k-2)...
%               + sig*C(i,j-1,k-1) + sig*C(i,j+1,k-1); 
%       end
%    end    
% end
% 
% 
% for i = 1:iter
%    surf(C(:,:,i));
%    axis([0 numX 0 numY -10 10]);
%    pause(.00001);
% end