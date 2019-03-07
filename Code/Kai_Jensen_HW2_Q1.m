close; clear; clc;
global P_dist
rho=0.909;
sigma_e=0.014;
Mu=0.0;
znum=9;
s=2.575; %amount of normal distribution covered
[zgrid_part_a,piz]=tauchen(rho,sigma_e,znum,Mu,s);  
sample_size=100;

%allocate memory
P_dist=[];
%convert each row of piz into a distribution
n=length(piz);
for i=1:n
P_dist = [P_dist,cumsum(piz(i,:))];
end
P_dist=transpose(reshape(P_dist,9,9));

%generate the sample path

%for t=1:sample_size-1
%X=[X,randomdrawfunction(P_dist(X(t))];
%end
