close; clear all; clc;
global P_dist x_sim
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
P_dist=transpose(reshape(P_dist,znum,znum));
cdf_test = P_dist(1,:); 
%generate the sample path
[sample_test,index]=cdf_randomdraw(cdf_test,zgrid_part_a);
index=5;
for i=1:sample_size
    [sample,index]=cdf_randomdraw(P_dist(index,:),zgrid_part_a);
    x_sim=[x_sim,sample];
end