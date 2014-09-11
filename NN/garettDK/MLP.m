function [MSE,error,ySub1toNH,zSub1to10]=MLP(X,wji,wkj)
%Inputs are matrix X of observations/inputs (has expected outputs as first
%column, w1-first layer of weights, w2-the second/top layer of weights
Label=X(:,1);
X=X(:,2:end);
%output of hidden layer
    %nety=X*wji;
    ySub1toNH=tansig(X*wji');
%output Z (the output of the top layer)
    %netz=ySub1toNH*wkj;
    zSub1to10=tansig(ySub1toNH*wkj');
%target t:
    tMatrix=-.9*(ones(size(zSub1to10)));
    for i=1:length(tMatrix);
        tMatrix(i,Label(i,1)+1)=.9;
    end
%calculate error
    error=tMatrix-zSub1to10;
    MSE=mean(error.^2,1);