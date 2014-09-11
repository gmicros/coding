%% GAUSSIAN ELIMINATION SHITTY CODE
% does not check for zero in the pivot position

clear; clc; close all 


A = magic(4);

% for every column
for j = 1:size(A,2);
    % divide by pivot
    A(j,:) = A(j,:)./A(j,j);
    % for every row
    for i = 1+j:size(A,1)
        A(i,:) = A(i,:) - A(i,j)*A(j,:);
    end
end

A