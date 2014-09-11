%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATH 509                                                                %
% Term Project                                                            %
%                                                                         %
% Authors:  Graeme Melrose                                                %
%           Lindsay Lewis                                                 %
%           Rebecca Edmonson                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization code
clear;clc;close all;

% Problem 1 
% Part (b)

% Assign DeltaX, DeltaT, and nu
dx = 0.001;
dt = 0.0004;
nu = dt/dx;

% Intialize X, T, and U
x = (0:dx:4)';m = length(x);
t = (0:dt:2)';j = length(t);
U = zeros(m, j);
U2 = zeros(m, j);
Exact_U = zeros(m, 1);

% Set Intial Condition for the Derived Numerical Solution
for mm = 1:m
    if(x(mm)<1 && x(mm)>0)
        U(mm, 1) = exp(-16*(x(mm)-0.5)^2)*sin(40*pi*x(mm));
    else
        U(mm, 1) = 0; 
    end
end

% Solve for the Derived Numerical Solution
for jj = 2:j
    for mm = 2:(m-1)
        U(mm, jj) = (nu/2)*(nu-1)*U(mm+1, jj-1) + ...
                    (1-nu^2)*U(mm, jj-1) + ...
                    (nu/2)*(nu+1)*U(mm-1, jj-1);
    end
    U(1, jj) = (nu/2)*(nu-1)*U(2, jj-1) + ...
               (1-nu^2)*U(1, jj-1) + ...
               (nu/2)*(nu+1)*U(m-1, jj-1);
    U(end, jj) = U(1, jj);
end

% Part (c)
% Set Intial Condition for the Upwind Leapfrog Solution
U2(:, 1) = U(:, 1);
for mm = 1:m
    if((x(mm)-t(2))<1 && (x(mm)-t(2))>0)
        U2(mm, 2) = exp(-16*((x(mm)-t(2))-0.5)^2)*sin(40*pi*(x(mm)-t(2)));
    else
        U2(mm, 2) = 0; 
    end
end

% Solve the Upwind Leapfrog Solution
for jj = 3:j
    for mm = 2:m
        U2(mm, jj) = U2(mm-1, jj-2) - (2*nu-1)*(U2(mm, jj-1) - U2(mm-1, jj-1));
    end
    U2(1, jj) = U2(end, jj);
end

% Solve the Exact Solution at t=2
for mm = 1:m
    if((x(mm)-t(end))<1 && (x(mm)-t(end))>0)
        Exact_U(mm) = exp(-16*((x(mm)-t(end))-0.5)^2)*sin(40*pi*(x(mm)-t(end)));
    else
        Exact_U(mm) = 0; 
    end
end

% Plot the Numerical and Analytical Solutions at t=2
figure('Name', 'Problem 1 Whole Range', 'NumberTitle', 'off');
plot(x, U(:, end), ':r');hold on;
plot(x, U2(:, end), ':b');hold on;
plot(x, Exact_U, '-g');
figure('Name', 'Problem 1 Focused Range', 'NumberTitle', 'off');
plot(x, U(:, end), ':r');hold on;
plot(x, U2(:, end), ':b');hold on;
plot(x, Exact_U, '-g');axis([1.95 2.15 -.17 .17]);



% Initialization code
clear;clc;close all;

% Problem 2 
% Part (b) & Part (c)

% Assign DeltaX, DeltaT
xmax = 2*pi;
tmax = 1;
dx = xmax.*[1/4; 1/8; 1/16; 1/32]';dm = length(dx);
dt = tmax.*[1/64; 1/128; 1/256; 1/512]';dj = length(dt);
lambda = zeros(dm, dj);

for dmm=1:dm
    for djj=1:dj
        clear x t U Exact_U; close all;
        % Calculate Lambda
        lambda = dt(djj)/(dx(dmm)^2);
        % Intialize X, T, and U
        x = (0:dx(dmm):xmax)';m = length(x);
        t = (0:dt(djj):tmax)';j = length(t);
        U = zeros(m, j);
        Exact_U = zeros(m,1);
        
        % Set Intial Condition Numerical Solution
        U(:, 1) = sin(x);
        
        % Solve for the Derived Numerical Solution
        for jj = 2:j
            for mm = 2:(m-1)
                U(mm, jj) = lambda*(1-(dx(dmm)/2))*U(mm+1, jj-1) + ...
                            (1-2*lambda)*U(mm, jj-1) + ...
                            lambda*(1+(dx(dmm)/2))*U(mm-1, jj-1);
            end
            U(1, jj) = lambda*(1-(dx(dmm)/2))*U(2, jj-1) + ...
                       (1-2*lambda)*U(1, jj-1) + ...
                       lambda*(1+(dx(dmm)/2))*U(m-1, jj-1);
            U(end, jj) = U(1, jj);
        end
        
        % Solve Exact Solution at t=1
        Exact_U = exp(-t(end)).*sin(x-t(end));
        
        % Plot the Numerical and Analytical Solutions at t=1
        figure('Name', 'Problem 2', 'NumberTitle', 'off');
        plot(x, U(:, end), ':r');hold on;
        plot(x, Exact_U, '-g');
        
        % Print the Errors to Screen
        Errors = abs(Exact_U-U(:,end));
        fprintf('\n\n');
        fprintf('dx = %7.5f \ndt = %7.5f \nAverage Error = %7.5f \n',dx(dmm),dt(djj),mean(Errors));
        fprintf('\n');
        fprintf('U \t\t\tExact U \tAbs Error\n\n');
        for ii = 1:m
            fprintf('%7.5f \t%7.5f \t%7.5f\n',U(ii, end), Exact_U(ii), Errors(ii));
        end
    end
end



% Initialization code
clear;clc;close all;

% Problem 3 
% Part (d)

n = 4; %% Starting value for steps (Pick a power of 2, question uses 16 as baseline)
numb = 10; %% Number of errors to compare
errors = zeros(numb,n*2^(numb-1)); % Intialize the Error Matrix
figure('Name', 'Problem 3', 'NumberTitle', 'off'); % Open a new figure
for ii = 1:numb % for each value of n
    z = zeros(n,1); % Intialize the Z_k values
    x = (0:(2*pi/n):(2*pi*(1-1/n)))'; % Intialize the X Vector
    for k = 0:n-1
        % Calculate the Z_k values
        for j = 0:n-1
            z(k+1) = z(k+1) + (2/n)*(cos(x(j+1))-cos(2*x(j+1)))*exp(-2*pi*1i*j*k/n);
        end
        z(k+1) = real(z(k+1));
        if(abs(z(k+1))<10^-14)   z(k+1)=0;end;
    end
    u = zeros(n,1); % Intialize the U(x,t) Values
    t = 2;
    for j = 0:n-1
        % Calculate the U(x,t) Values
        for k = 0:n-1
            u(j+1) = u(j+1) + z(k+1)*exp(-(k^2)*t)*exp(1i*k*x(j+1));
        end
    end
    u = real(u); % Throw out the imaginary part, should equal 0 anyways
    % Calculate the Analytical solution to U(x,t)
    U = cos(x).*exp(-t)-cos(2.*x).*exp(-4*t);
    % Calculate the Relative Errors
    errors(ii,1:n) = abs((u-U)./(U+1));
    % Plot the Numerical and Analytical Solutions at t=2
    subplot(2,5,ii);
    plot(x, u, ':r');hold on;
    plot(x, U, '-g');
    n = n*2;
end