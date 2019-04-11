close; clear all; clc;
alpha = .36; 
d = .069; 
beta = .96;
sigma = 2; 
A = 1; 
rho = .859; 
sigma_e = .014; 
znum = 9; 
mu = 0; 
s = 2.575;
[zgrid, piz] = tauchen(rho, sigma_e, znum, mu, s); 
zgrid = exp(zgrid); 
TV = zeros(Knum, znum);
V = TV; 
G = TV; 
precision = 1e-5;
distance = 2*precision;
iteration = 0;
while distance > precision
    eV = zeros(Knum,znum);  
    for i = 1:Knum
        for iz = 1:znum
            for jz = 1:znum
                eV(i,iz) = eV(i,iz) + piz(iz,jz)*V(i,jz);
            end
        end
    end
    TV0 = zeros(Knum, znum, Knum);
    c0 = TV0;
    for i = 1:Knum
        for iz = 1:znum
            for j = 1:Knum
                cVal =  zgrid(iz)*(Kgrid(i))^alpha + (1-d)*Kgrid(i) - Kgrid(j); 
                c0(i,iz, j) = max(cVal, 0);
                TV0(i,iz, j) = (c0(i,iz,j)^(1-sigma)-1)/(1-sigma) + beta*eV(j,iz);            
            end
        end
    end
    for i = 1:Knum
        for iz = 1:znum
            [TV(i,iz),loc] = max(TV0(i,iz,:));
            G(i,iz) = Kgrid(loc);
        end
    end    
    distance = max(max((abs(TV - V)))); 
    V = TV;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, distance);
    disp(s)    
        
end

save uncertainty.mat

