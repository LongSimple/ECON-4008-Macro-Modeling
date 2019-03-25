clear; close all; clc; 
globalpar;
while distance > precision  
    [c0,Tv0,ev]= deal(zeros(Knum,Nz,Knum),zeros(Knum,Nz,Knum),zeros(Knum,Nz));
    for iz = 1:Nz
            for jz = 1:Nz
                ev(1:Knum,iz) = ev(1:Knum,iz) + piz(iz,jz)*v(1:Knum,jz);                                          
            end
            for j=1:Knum
                cval =  zgrid(iz)*(Kgrid(1:Knum)).^alpha + (1-d)*Kgrid(1:Knum) - Kgrid(j); 
                c0(1:Knum,iz, j) = max(cval, 0);
            end
    end
            for j = 1:Knum
                Tv0(1:Knum,1:Nz, j) = (c0(1:Knum,1:Nz,j).^(1-sigma)-1)/(1-sigma) + beta.*ev(j,1:Nz);            
            end
    for i = 1:Knum
        for iz = 1:Nz
            [Tv(i,iz),loc] = max(Tv0(i,iz,:));
            G(i,iz) = Kgrid(loc);
        end
    end
    distance = max(max(abs(Tv - v)))
    v = Tv; 
end
clc; save Kai_Jensen_HW2_Q2.mat;
figure
[Zmat, Kmat] = meshgrid(zgrid, Kgrid);
subplot(211)
mesh(Zmat, Kmat, v)
hold on
title ( ' Value Function ' )
subplot(212)
mesh(Zmat, Kmat, G)
hold on
title ( ' Decision Rule ' )  
saveas(gcf,'decisionrule_valuefunction.png')


