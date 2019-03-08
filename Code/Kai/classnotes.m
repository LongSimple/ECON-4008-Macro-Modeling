close; clear; clc;

%construct statespace

rho=0.909;
sigma_e=0.014;
Mu=0.0;
znum=9;
s=2.575; %amount of normal distribution covered
[zgrid,piz]=tauchen(rho,sigma_e,znum,Mu,s);

Knum = 250; %calculate future EV given 
ev = zeros(Knum,znum); %init ev
v= zeros(Knum, znum);

for i=1:Knum %current K location
    for iz =1:znum %current z location
        for jz =1:znum %future z location
            ev(i, iz)= piz(iz,jz)*v(i,jz);
        end
    end
end

%change 1 all variables have to be 2 dimensions
%solve for ev and change v for ev