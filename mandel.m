
clear; clc; close all


x = [-1, 1];
y = [-1, 1];

numX = 100; 
numY = 100; 
iter = 100; 

dx = (x(2) - x(1))/numX;
dy = (y(2) - y(1))/numY;

A = zeros(numX, numY);
cnt = 0;


for i = 1:numX
   for j = 1:numY
       xtemp =0;
       ytemp =0;
       x0 =  x(1) + dx*(i-1); 
       y0 =  y(2) - dy*(j-1);
       for k = 1:iter 
          hey = xtemp^2 - ytemp^2 + x0; 
          ytemp = 2*xtemp*ytemp + y0;
          xtemp = hey;
          
          if ((xtemp^2 + ytemp^2) < 4)
            cnt = cnt + 1;
          end
       end
       A(i,j) = cnt;
       cnt = 0;
   end
end







xaxis = linspace(x(1), x(2), numX);
yaxis = linspace(y(1), y(2), numY);
imagesc(A)