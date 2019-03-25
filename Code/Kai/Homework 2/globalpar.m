global A alpha beta d Tv Knum Kgrid rho s Kh Kl sigma sigma_e Nz piz Mu V v G P_dist precision distance iteration zgrid sample_size

%parameters
alpha=.36;
d=.069;
beta=.96;
sigma=2;
A=1;
%capital
Kl=.1; 
Kh=6; 
Knum=250; 
Kgrid=linspace(Kl, Kh, Knum); 
%states
rho=.859;
sigma_e=.014;
Nz=9;
Mu=0;
s=2.575;
%etc
Tv=zeros(Knum, Nz);
v=Tv;
G=Tv;
precision=1e-5;
distance=2*precision;
iteration=0;
Tv=zeros(Knum, Nz);
sample_size=100;
%generate states
[zgrid,piz]=tauchen(rho,sigma_e,Nz,Mu,s); 
zgrid=exp(zgrid);
V=Tv;
P_dist=[];
unused = {'Kh','Kl','Mu'};
clear (unused{:});
