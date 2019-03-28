close; clear all; clc;
beta=.1001;
rho = .859; 
sigma_e = .014; 
znum = 9; 
mu = 0; 
s = 2.575;
[zgrid, piz] = tauchen(rho, sigma_e, znum, mu, s); 
bgrid=linspace(0.1,1,10);
sgrid=linspace(10,1,10);
ugrid=bgrid-sgrid;
TV = zeros(Knum, znum);
V = TV; 
G = TV; 
precision = 1e-5;
distance = 2*precision;
iteration = 0;
while distance > precision
 eV = zeros(Knum,znum);  
    for b = 1:length(brgid)
        for s = 1:length(sgird)
            for jz=1:length(zgrid)
                eV(s,b,iz) = eV(s,b,iz) + beta*(piz(iz,jz)*V(b,s,jz));
            end
        end
    end
    Tv0=zeros(length(bgrid),length(sgrid),length(zgrid));
    C0=Tv0;
    
    
    
    distance = max(max((abs(TV - V)))); 
    V = TV;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, distance);
    disp(s)   
end
