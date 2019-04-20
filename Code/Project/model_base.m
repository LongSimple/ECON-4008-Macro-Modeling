nuke;
alpha = .36; 
d = .069; 
beta = .96;
%  
sigma = 2; 
A = 1; 
rho = .859; 
sigma_e = .014; 
znum = 9; 
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
iteration = 1;
while delta > error
[c0, TV0, eV] = deal(zeros(Knum, znum, Knum), zeros(Knum, znum, Knum),zeros(Knum, znum));
eV=squeeze(sum(((permute(((permute(piz,[3 2 1])).*V),[1 3 2]))+eV),3));
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
    [delta, V] = deal(max(max(abs(TV - V))),TV); 
    iteration = iteration + 1;
    disp(sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, delta))
end
save uncertainty.mat

