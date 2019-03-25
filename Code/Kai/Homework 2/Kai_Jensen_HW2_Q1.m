close; clear; clc;
globalpar;
index = 5;
x_sim = zgrid(index);
for i = 1:length(piz)
    P_dist = [P_dist, cumsum(piz(i, :))];
end
P_dist = transpose(reshape(P_dist, Nz, Nz));
for i = 1:sample_size - 1
    [sample, index] = cdf_randomdraw(P_dist(index, :), zgrid);
    x_sim = [x_sim, sample];
end
plot(x_sim);