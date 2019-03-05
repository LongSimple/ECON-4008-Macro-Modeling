close; clear; clc;

%construct statespace
statelow=0.01;
statehigh=6;
statenum=250;
statespace = linspace(statelow,statehigh,statenum);

rho=0.909;
sigma_e=0.014;
znum=7;
Mu=1;
s=10;
[Z,P]=tauchen(rho,sigma_e,znum,Mu,s);