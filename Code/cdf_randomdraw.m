function [sample,zIdx] = cdf_randomdraw(cdf,x_values)
rand('seed',12345);
% init random draw
x = x_values;
Cx = cdf;
z = rand;
%draw sample
zIdx = min(find(Cx>z));
sample = x(zIdx);
end