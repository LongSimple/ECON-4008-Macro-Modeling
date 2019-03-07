function [sample,index] = cdf_randomdraw(cdf,x_values)
rand('seed',12345);
% init random draw
z = rand;
%draw sample
index = min(find(cdf>z));
sample = x_values(index);
end
