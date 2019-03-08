clear; close all; clc;
alpha=.66;
rho=.909;
sigmasquaredsube=0.014;
errorterm=0;% need to determine error term
z=1000; %need to determine first z interval
w=30; %need to determine wage rate
productivityshock = @(x)((exp(1)^errorterm)*(x^rho));% does this work?
ndividendfunction = @(x)-((z*(x^alpha)-(w*x))); %x= number of workers
zprime=productivityshock(z);%calculate z in next state
n3= fminbnd(ndividendfunction,1,1000000000000000); %(minimize negative dividend function)=(maximize dividend function), might want to make upper bound and lower bound variable?
div2 = (z*(n3^alpha))-(w*n3);
Y=z*(n3^alpha);

zarray=z;%testing adding next in step below
zarray = [zarray, productivityshock(z)];
zarray = [zarray, productivityshock(zarray(end))];