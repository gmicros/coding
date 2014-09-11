%% BINOMIAL DIST

close all; clc; clear

%% BINOMIAL DISTRIBUTION 
obs = 10000; 
n = 50; 
p = 0.2; 

X = binornd(50*ones(1,obs),p);

for i = 0:50;
   pX(1,i+1) = sum(X==i); 
end
pX = pX/obs;
plot(pX);

for i = 1:obs
    x(1,i) = sum(rand(1,n) <=p);
end

for i = 0:50;
   px(1,i+1) = sum(X==i); 
end
px = px/obs;
figure;
plot(px, '-r');

bino = binopdf(0:50, 50, 0.2);
figure;
plot(bino, '-k');