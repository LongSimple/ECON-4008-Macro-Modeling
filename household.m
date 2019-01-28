clear; close all; clc;
z=1;
s=10;
gamma=1.5;
beta=.96;

utility = @(x)(x^1-gamma)/(1-gamma);


c=(d(x))+(p(x)*s)+(w(x))-(p(x)s2);%Placeholder d(x)
max(utility(c)+beta;