close; clear all; clc;
%Initial parameter values
Mu=0;
rho=0.909;
s=2.575; %amount of normal distribution covered
sample_size=100;
sigma=2;
sigma_e=0.014;
znum=9;
%markov
[zgrid,piz]=tauchen(rho,sigma_e,znum,Mu,s); 
zgrid=exp(zgrid);
%allocate memory for CDF Random Draw
index=5;% starting state(index) for CDF Random Draw
x_sim=zgrid(index);
P_dist=[];
%convert each row of piz into a cdf
n=length(piz);
for i=1:n
P_dist = [P_dist,cumsum(piz(i,:))];
end
P_dist=transpose(reshape(P_dist,znum,znum));

%generate the sample path
for i=1:sample_size-1
    [sample,index]=cdf_randomdraw(P_dist(index,:),zgrid);
    x_sim=[x_sim,sample];
end

%plot
plot(x_sim);