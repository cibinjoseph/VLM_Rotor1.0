clc; clear; 
A=dlmread('Results/r01forceHist.txt');
A(1,:)=[];
CL=mean(A(100:150,2))
