%% ADVECTION-DIFFUSION EQUATION 
%   Ut + Ux = Uxx
%   forward time, centered space

clear; %clc; close all;

xmax = 2*pi;
tmax = 1;

m = 41;
j = 51;

h = xmax/(m-1);
k = tmax/(j-1);

x = (0:h:xmax)';
t = (0:k:tmax)';
U = zeros(m,j);

% initial  conditions 
U(1:end-1,1) = sin(x(1:end-1));
U(end,1) = U(1,1);     
exact_U = exp(-t(j)).*sin(x-t(j));
for jj = 2:j
    for mm = 2:m-1
        U(mm,jj) = ((2+h)*k/(2*h^2))*U(mm-1,jj-1) + ...
                   (1-(2*k/h^2))*U(mm,jj-1) + ...
                   ((2-h)*k/(2*h^2))*U(mm+1,jj-1);
    end
    U(1,jj) = ((2+h)*k/(2*h^2))*U(end-1,jj-1) + ...
              (1-(2*k/h^2))*U(1,jj-1) + ...
              ((2-h)*k/(2*h^2))*U(2,jj-1);
    U(m,jj) = U(1,jj);
%     close all;figure;
%     plot(x,U(:,jj)); axis([0, xmax, -1, 1]);
%     hold on; plot(x,exact_U, '-r');
%     F(jj-1) = getframe;
end
errors = abs(exact_U-U(:,jj));
fprintf('\n');
fprintf('U \t\t Exact U \t\t Rel Error\n\n');
for ii = 1:m
    fprintf('%7.5f \t%7.5f \t%7.5f\n',U(ii,jj), exact_U(ii), errors(ii));
end
% movie(F,1);
fprintf('%12.10f\n',mean(errors))