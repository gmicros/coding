%% 2D CRANK NICHOLSON

clear; clc; close all;


numX = 50;
dx = 1/numX;

numY = 50;
dy = 1/numY;



dt = .0001;

T = 100;
X = 25;
Y = 25;
R = 10;
K = 1;

iter = 1000;


C(1,:) = 0;
C(numX,:)= 0;

C(:,1) = 0;
C(:,numY)= 0;

for i = 2:numX-1
    for j = 2:numY-1
        C(i,j) = T*( (((i-X)/R)^2 + ((j-Y)/R)^2) < 1);
    end
end

D = C;


sig = dt/(dx^2);



lineX = [sig, 1/2-2*sig, sig];
dirX = diag(repmat(lineX(1),numX-1,1),-1)...
        + diag(repmat(lineX(2),numX,1),0)...
        + diag(repmat(lineX(3),numX-1,1),1);

    
lineY = [sig, 1/2-2*sig, sig];
dirY = diag(repmat(lineX(1),numX-1,1),-1)...
        + diag(repmat(lineX(2),numX,1),0)...
        + diag(repmat(lineX(3),numX-1,1),1);
    
    
explX = spdiags([sig*ones(numX,1), (1-2*sig)*ones(numX,1), sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);
 
implX = spdiags([-sig*ones(numX,1), (2+2*sig)*ones(numX,1), -sig*ones(numX,1)]...
                , [-1,0,1], numX, numX);


explY = spdiags([sig*ones(numY,1), (1-2*sig)*ones(numY ,1), sig*ones(numY,1)]...
                , [-1,0,1], numY, numY);
  
implY = spdiags([-sig*ones(numY,1), (2+2*sig)*ones(numY ,1), -sig*ones(numY,1)]...
                , [-1,0,1], numY, numY);

   
% d = figure('Unit', 'normalized','position',[0.05, 0.25, .4, .5]);
a = subplot(1,2,1);
surf(D,'EdgeColor', 'none');
axis([0 numX 0 numY 0 T*1.1]);
% c = figure('Unit', 'normalized','position',[0.46, 0.25, .4, .5]);
b = subplot(1,2,2);
surf(C,'EdgeColor', 'none');
axis([0 numX 0 numY 0 T*1.1]);
for i = 1:iter
   Cx = implX\explX*C;
   Cy = C*explY/implY;
   C = Cx + Cy;
   
   D = dirX*D + D*dirY;
   
   subplot(a)
   surf(D,'EdgeColor', 'none');
   axis([0 numX 0 numY 0 T*1.1]);
   subplot(b)
   surf(C,'EdgeColor', 'none');
   axis([0 numX 0 numY 0 T*1.1]);
   pause(0.01);
end


