%Given a cdf and x_values returns a sample and the index of that sample
function [sample,index] = cdf_randomdraw(cdf,x_values)
rng('shuffle');
% init random draw
z = rand;
%draw sample
index = find(cdf>z, 1 );
sample = x_values(index);
end
