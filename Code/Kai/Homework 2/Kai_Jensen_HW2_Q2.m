clear; close all; clc; 
alpha = .36;
d = .069;
beta = .96;
sigma = 2;
A = 1;
Kl = .01; 
Kh = 6; 
Knum = 250; 
Kgrid = linspace(Kl, Kh, Knum); 
rho = .859;
sigma_e = .014;
Nz = 5;
mu = 0;
s = 2.575;
[zgrid, piz] = tauchen(rho, sigma_e, Nz, mu, s); 
zgrid = exp(zgrid);
Tv = zeros(Knum, Nz);
v = Tv;
G = Tv;
precision = 1e-5;
distance = 2 * precision;
iteration = 0;

while distance > precision
    ev = zeros(Knum, Nz);
    c0 = zeros(Knum, Nz, Knum);
    Tv0 = c0;
    
    for i=1:Knum
        for iz =1:Nz
            for jz =1:Nz
                ev(i, iz)= ev(i,iz)+piz(iz,jz)*v(i,jz);
            end
        end
    end
    for i = 1:Knum
         for iz=1:Nz
            for j = 1:Knum
                c0(i,iz,j) =  max(zgrid(iz)*(Kgrid(i))^alpha + (1-d)*Kgrid(i) - Kgrid(j), 1e-5);  % c cannot be negative
                Tv0(i,j) = (c0(i,j)^(1-sigma)-1)/(1-sigma)+ beta*v(j); %correct utility function  
                %Tv0(i,iz,j)=log(c0(i,iz,j))+beta*ev(i,iz);
            end
        end
    end

    for i = 1:Knum
        for iz = 1:Nz 
       [val,loc] = max(Tv0(i,iz,:)); 
       Tv(i,iz) = val; 
       G(i,iz) = Kgrid(loc); 
        end
    end
    
    distance = max(max(max(abs(Tv - v)))); 
    v = Tv; 
    s = sprintf( ' iteration %4d ||Tv - V|| = %8.6f ', iteration, distance); 
    disp(s)
    iteration = iteration + 1;    
end 