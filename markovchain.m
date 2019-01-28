clear; close all; clc;
alpha=.66; %this is working now
rho=.909;
sigmasquaredsube=0.014;
errorterm=0;
z=100;
w=30;
productivityshock = @(x)x^rho+(exp(1)^(errorterm));
dividendfunction = @(x)(w*x)-(z*(x^alpha)); %x= number of workers
zprime=productivityshock(z);%calculate z in next state
n3= fminbnd(dividendfunction,1,100000000);
div2 = (z*(n3^alpha))-(w*n3);
Y=z*(n3^alpha);