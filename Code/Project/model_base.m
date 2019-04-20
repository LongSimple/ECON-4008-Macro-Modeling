nuke;
alpha = .36; 
d = .069; 
beta = .96;
%  
sigma = 2; 
A = 1; 
rho = .859; 
sigma_e = .014; 
znum = 250; 
mu = 0; 
s = 2.575;
Knum= znum;
gamma=1;
Kgrid=linspace(10,1,Knum); %stock going to be Piz for tauchen of stock
[zgrid, piz] = tauchen(rho, sigma_e, znum, mu, s); 
zgrid = exp(zgrid);
TV = zeros(Knum, znum);
V = TV;
G = TV; 
error = 0.05;
delta = 2*error;
iteration = 0;



while delta > error
    eV = zeros(Knum,znum);  
    for i = 1:Knum
        for iz = 1:znum
            for jz = 1:znum
                eV(i,iz) = eV(i,iz) + piz(iz,jz)*V(i,jz);
            end
        end
    end
 test3=(permute(((permute(piz,[3 2 1])).*V),[1 3 2]));
 test4=test3(:,:,znum);
 test5=eV+test4;%testing matrix solution
 
    for i = 1:Knum
        for iz = 1:znum
            for jz = 1:znum
                eVtest(i,iz) = piz(iz,jz)*V(i,jz);
            end
        end
    end
    
[TV0,c0] = deal(zeros(Knum, znum, Knum));
calc=(permute((((1-d).*Kgrid)-transpose(Kgrid)),[2 3 1]));
c0=max(((repmat((transpose(Kgrid.^alpha).*zgrid),[1 1 znum]))+(calc(:,1,:).*ones(1,znum))),0);%calculated consumption
calc=(beta.*eV);
TV0=(c0.^(1-sigma)/(1-sigma)+((permute((calc(:,:,1)),[3 2 1])).*ones(znum,znum,znum)))+1;

    for i = 1:Knum
        for iz = 1:znum
            [TV(i,iz),loc] = max(TV0(i,iz,:));
            G(i,iz) = Kgrid(loc);
        end
    end    
    delta = max(max(abs(TV - V))); 
    V = TV;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, delta);
    disp(s)    
        
end

save uncertainty.mat

