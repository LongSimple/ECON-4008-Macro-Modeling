clear all; close; clc;
globalpar;
while distance > precision
    [c0, Tv0, ev] = deal(zeros(Knum, Nz, Knum), zeros(Knum, Nz, Knum), zeros(Knum, Nz));
    for iz = 1:Nz
        for jz = 1:Nz
            ev(1:Knum, iz) = ev(1:Knum, iz) + piz(iz, jz) * v(1:Knum, jz);
        end
        for j = 1:Knum
            cval = zgrid(iz) * (Kgrid(1:Knum)).^alpha + (1 - d) * Kgrid(1:Knum) - Kgrid(j);
            c0(1:Knum, iz, j) = max(cval, 0);
        end
    end
    for j = 1:Knum
        Tv0(1:Knum, 1:Nz, j) = (c0(1:Knum, 1:Nz, j).^(1 - sigma) - 1) / (1 - sigma) + beta .* ev(j, 1:Nz);
    end
    for i = 1:Knum
        for iz = 1:Nz
            [Tv(i, iz), loc] = max(Tv0(i, iz, :));
            G(i, iz) = Kgrid(loc);
        end
    end
    distance = max(max(abs(Tv-v)))
    v = Tv;
end
unused = {'Tv', 'Knum', 'j', 'c0', 'Tv0', 'A', 'beta', 'cval', ...
    'iteration', 'rho', 's', 'precision', 'distance', 'sigma', ...
    'sigma_e', 'loc', 'iz', 'jz', 'Mu'};
clear(unused{:});
clc;
[z_sample_path_index, index] = deal(3); % starting state(index) for CDF Random Draw
K_sample_path_index(1) = 20; %starting capital index
z_sample_path = zgrid(index);
[Y_sample_path, C_sample_path, K_sample_path] = deal(zeros(1, sample_size-1), zeros(1, sample_size-1), Kgrid(K_sample_path_index));
for i = 1:length(piz)
    P_dist = [P_dist, cumsum(piz(i, :))];
end
P_dist = transpose(reshape(P_dist, Nz, Nz));
for i = 1:sample_size - 1
    [sample, index] = cdf_randomdraw(P_dist(index, :), zgrid);
    [z_sample_path, z_sample_path_index] = deal([z_sample_path, sample], [z_sample_path_index, index]);
end
for t = 2:sample_size
    K_sample_path(t) = G(K_sample_path_index(t-1), z_sample_path_index(t-1));
    K_sample_path_index(t) = find(Kgrid == K_sample_path(t));
end
Y_sample_path(1:sample_size-1) = z_sample_path(1:sample_size-1) .* K_sample_path(1:sample_size-1).^alpha;
C_sample_path(1:sample_size-1) = Y_sample_path(1:sample_size-1) + (1 - d) .* K_sample_path(1:sample_size-1) - K_sample_path((1:sample_size - 1)+1);
figure
[Zmat, Kmat] = meshgrid(zgrid, Kgrid);
subplot(211)
mesh(Zmat, Kmat, v)
hold on
title(' Value Function ')
subplot(212)
mesh(Zmat, Kmat, G)
hold on
title(' Decision Rule ')
saveas(gcf, 'decisionrule_valuefunction.png')
figure
plot(z_sample_path)
hold on
title([' TFP for ', num2str(sample_size), ' periods starting in state ', num2str(z_sample_path_index(1)), ''])
saveas(gcf, 'TFP.png')
figure
subplot(311)
plot(K_sample_path)
hold on
title([' Capital for ', num2str(sample_size), ' periods starting at ', num2str(Kgrid(K_sample_path_index(1))), ''])
subplot(312)
plot(Y_sample_path)
hold on
title([' GDP for ', num2str(sample_size), ' periods '])
subplot(313)
plot(C_sample_path)
hold on
title([' C for ', num2str(sample_size), ' periods '])
saveas(gcf, 'simulated_economy.png')
save Kai_Jensen_HW2_Q3.mat