% one-dimensional advection-diffusion by the FTCS scheme!
clear; clc; close all

n=21; 
nstep=100; 
length=2.0; 
h=length/(n-1); 
dt=0.05; D=0.05;
f=zeros(n,1); 
y=zeros(n,1); 
ex=zeros(n,1); 
time=0.0;

for i=1:n, 
    f(1,i)=0.5*sin(2*pi*h*(i-1)); 
end; % initial conditions!
 figure; 

for m=1:nstep, m, time
%     for i=1:n, 
%         ex(i)=exp(-4*pi*pi*D*time)*0.5*sin(2*pi*(h*(i-1)-time)); 
%     end; % exact solution !
%     hold off; 
    plot(f(m,:),'linewidt',2); 

    axis([1 n -2.0, 2.0]); % plot solution!
    
%     hold on; 
%     plot(ex,'r','linewidt',2);
    pause; % plot exact solution!
    
    y=f(m,:); % store the solution!
    
    for i=2:n-1
        f(m+1, i)=y(i)-0.5*(dt/h)*(y(i+1)-y(i-1))+...
             D*(dt/h^2)*(y(i+1)-2*y(i)+y(i-1)); % advect by centered differences!
    end;
    
    f(m+1,n)=y(n)-0.5*(dt/h)*(y(2)-y(n-1))+...
         D*(dt/h^2)*(y(2)-2*y(n)+y(n-1)); % do endpoints for!
    f(m+1, 1)=f(m+1, n); % periodic boundaries!
    time=time+dt;
end;