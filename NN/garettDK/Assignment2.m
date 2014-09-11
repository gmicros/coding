
%=====================
%   Garett Johnson
%    Assignment 2
%=====================


%% ==========================================================================
% The  objective  of  this  assignment  is  to  correctly  classify  10  
% handwritten  digits  using  a neural  network. The  assigment2.mat  data 
% set  found  on Blackboard  contain  training  and testing data, both 
% having the same format:  The first column of the matrix is the label(0-9)
% and the remaining columns represent the intensities (range=[0:16]) of the
% pixels of the 8 x 8 digital images, arranged in a raster scan.  Using 
% this data, write original Matlab code to perform the following analyses:  
%==========================================================================
clear all; close all; clc;
load('assignment2.mat');
%I don't like all these variables it loads in, so clear some of the
%redundant ones, and remove those unsightly capital letters
Training=TRAINING; Testing=TESTING; 
clear NUMERIC RAW TESTING TRAINING TXT ans
%% ==========================================================================
%A. Using the training data set, apply the delta rule to train a single 
%   perceptron having a tansigmoid activation function to output a 0.9 (1) 
%   if the input pattern is a written 2, and to output a -0.9 (-1) for all
%   other written characters. 
%   i.  Plot the error curve during training and report the final weights. 
%   ii.  Test the network using the test data set and report the accuracy. 
%==========================================================================

%Apply Delta Rule to train a single perceptron:   
  %generate validation set from training set
     Validation=Training(round(.75*length(Training)):end,:); 
     Training=Training(1:round(.75*length(Training))-1,:);     
  %append column of 1s to account for DC offset   
     Training=[Training ones(size(Training,1),1)];
     Validation=[Validation ones(size(Validation,1),1)];
  %generate initial weights:  
     WeightCurrent=2*rand(1,65)-1;
     SS=.1;
  %train until validation error starts to rise or until 40 epochs ...
  %whichever comes first
  check=0;cntr=1;
   while cntr<=40 & check==0
    %get my training error for this epoch!
       %multiply inputs by the current weights 
        X=Training(:,2:end);
        W=repmat(WeightCurrent,size(X,1),1);
        Result=dot(X,W,2);
       %perform nonlinearity 
        y=tansig(Result);
       %get error 
        ind1=find(Training(:,1)==2);
        ind2=find(Training(:,1)~=2);
        clear error;
        error(ind1,1)=.99-y(ind1);
        error(ind2,1)=-.99-y(ind2);        
        MSTE(cntr)=mean(error.^2);
    %update weights!
        Fprime=((2/3)/(1.716))*(1.716-y).*(1.716+y);
        WeightNext=WeightCurrent+((SS)*error.*Fprime)'*X;
        WeightOld=WeightCurrent;
        WeightCurrent=WeightNext;        
    %get my validation error!
        X=Validation(:,2:end);
        W=repmat(WeightOld,size(X,1),1);
        Result=dot(X,W,2);
        y=tansig(Result);
        ind1=find(Validation(:,1)==2);
        ind2=find(Validation(:,1)~=2);
        clear error;
        error(ind1,1)=.99-y(ind1);
        error(ind2,1)=-.99-y(ind2);        
        MSVE(cntr)=mean(error.^2);
    %check if validation error has increased from previous! make sure to
    %perform at least 6 iterations to train...
        if cntr>12
              if MSVE(cntr) > MSVE(cntr-1)
                 check=1;
              end
        end
        cntr=cntr+1;               
   end
 Weights=WeightOld;
 Weights=Weights(1:end-1);
%    i.  Plot the error curve during training and report the final weights.
    figure; subplot(1,2,1), plot(MSTE); title('Training Error Curve');
            ylabel('Mean Square Error');xlabel('Iteration');
            xlim([1 cntr-1]);
            subplot(1,2,2), plot(MSVE); title('Validation Error Curve');
            ylabel('Mean Square Error');xlabel('Iteration');
            xlim([1 cntr-1]);
%   ii.  Test the network using the test data set and report the accuracy. 
   acc=0;
    for i = 1:length(Testing)
        X=Testing(i,2:end)';
        y=tansig(Weights*X);
        if (y>=0 & Testing(i,1)==2) | (y<0 & Testing(i,1)~=2)
            acc=acc+1;
        end
    end
    acc=acc/i;
    fprintf(1,'The final test accuracy for Part A is %g%%\n',acc*100);
   
%% ==========================================================================
%B.  Using  the  training  data  set,  apply  backpropagation  to  train  
%    a  three-layer MLP having a tansigmoid activation functions.  The 
%    output should consist of 10 units, each corresponding to a digit.  
%    Each unit will output 0.9 (1) for its respective digit and -0.9 (-1) 
%    otherwise.  The hidden layer should consist of 10 units. 
%   i.  Plot the error curve during training and report the final weights. 
%   ii.  Test the network using the test data set and report the accuracy. 
%   iii.  Provide the confusion matrix.     
%==========================================================================    
clear all; load('assignment2.mat');
%I don't like all these variables it loads in, so clear some of the
%redundant ones, and remove those unsightly capital letters
Training=TRAINING; Testing=TESTING;
clear NUMERIC RAW TESTING TRAINING TXT ans  
  %stepSize
     SS=1;
  %generate validation set from training set
     Validation=Training(round(.75*length(Training)):end,:); 
     Training=Training(1:round(.75*length(Training))-1,:);
  %scale inputs   
     X=Training; X(:,2:end)=(X(:,2:end)-8)/160;
     Y=Validation; Y(:,2:end)=(Y(:,2:end)-8)/160;
     Testing(:,2:end)=(Testing(:,2:end)-8)/160;
  %number of hidden nodes   
     nodes=15;
  %generate initial weights:  
     Wji=1*rand(nodes,64)-.5;     
     Wkj=1*rand(10,nodes)-.5;
  %train until validation error starts to rise or until 40 epochs ...
  %whichever comes first
  check=0;cntr=1;  
   %Batch Backpropagation
   while cntr<=1000 & check==0      
      %feed weights forward to get errors 
       [MSVE(cntr,:),error,yj,zk]=MLP(Y,Wji,Wkj); 
       [MSTE(cntr,:),error,yj,zk]=MLP(X,Wji,Wkj);
      %find F'(net)
       FprimeK=((2/3)/(1.716))*(1.716-zk).*(1.716+zk);
       FprimeJ=((2/3)/(1.716))*(1.716-yj).*(1.716+yj);
      %find delk 
       delk=error.*FprimeK;     
       deltaWkj=zeros(10,nodes);             
       deltaWji=zeros(nodes,64);       
       for i = 1:length(X)
            deltaWkj=deltaWkj+SS*delk(i,:)'*yj(i,:);
           %find delj
            summ=zeros(1,nodes);
            dk=delk(i,:);
            for k=1:10
               summ=summ+Wkj(k,:)*dk(k); 
            end
            delj=FprimeJ(i,:).*summ;
            deltaWji=deltaWji+SS*delj'*X(i,2:end);           
       end
       %update the weights
       WjiOld=Wji;
       Wji=Wji+deltaWji/length(X);
       WkjOld=Wkj;
       Wkj=Wkj+deltaWkj/length(X);
      %check if validation error has increased from previous! make sure to
      %perform at least 6 iterations to train...    
      msve=mean(MSVE,2);
      mste=mean(MSTE,2);
      if cntr>60         
             if mean(MSVE(cntr,:)) > mean(MSVE(cntr-1,:))
                check=1;
             end
       end
       cntr=cntr+1;              
   end 
%%   ii.  Test the network using the test data set and report the accuracy.
%   iii.  Provide the confusion matrix. 
Weight1=WjiOld;
Weight2=WkjOld;
[MSTestingE,error,yj,zk]=MLP(Testing,Weight1,Weight2); 
acc=0;
Confusion=zeros(10,10);
for i=1:length(Testing)
    hh=max(zk(i,:));    
    if length(hh)==1 
        hhh=find(zk(i,:)==hh);
        if hhh==Testing(i,1)+1;       
            acc=acc+1;
            Confusion(hhh,hhh)=Confusion(hhh,hhh)+1;
        end     
        if hhh~=Testing(i,1)+1;       
            Confusion(Testing(i,1)+1,hhh)=Confusion(Testing(i,1)+1,hhh)+1;
        end     
    end
end
Acc=acc/length(Testing)*100;
fprintf(1,'The Confusion Matrix is as follows:\n');
disp(Confusion)
fprintf(1,'The Testing Accuracy is %g\n',Acc);
clear FprimeJ FprimeK MSTE MSVE SS Wji WjiOld Wkj WkjOld X Y acc check delj
clear delk deltaWji deltaWkj dk error hh hhh i k summ yj
%==========================================================================
%C.  Repeat part b using 5 and 15 hidden units
%==========================================================================
%       This can be done by changing the value set at line 129, and
%       re-running the code.  Looping this would take too long to run.

%==========================================================================
%D.  Discuss
%==========================================================================
%       Please see attached document for discussion!








