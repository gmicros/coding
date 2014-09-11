%% NUMERICAL ERROR

clear; clc; close all
x = pi/4;
h = 01; 
iter = 20;
for i = 1:iter
   a(i) = (cos(x+h) - cos(x))/h;
   b(i) = -sin(x);
   h = h/10;
end

err = abs(a - b);
plot(err)