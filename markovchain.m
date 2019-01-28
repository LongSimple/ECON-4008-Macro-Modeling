clear; close all; clc;
alpha=.66; %this is working now
rho=.909;
sigmasquaredsube=0.014;
errorterm=0;
z=100;
w=30;
productivityshock = @(x)x^rho+(exp(1)^(errorterm));
ndividendfunction = @(x)-((z*(x^alpha)-(w*x))); %x= number of workers
zprime=productivityshock(z);%calculate z in next state
n3= fminbnd(ndividendfunction,1,100000000); %minimize negative dividend function
div2 = (z*(n3^alpha))-(w*n3);
Y=z*(n3^alpha);