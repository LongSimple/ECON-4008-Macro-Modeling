<<<<<<< HEAD
%Create a function that randomly draws 

function [sample,zIdx] = cdf_randomdraw(cdf,x_values)
=======
function [sample,index] = cdf_randomdraw(cdf,x_values)
>>>>>>> 5400c2178cf0abd0390a7557871a2c7397c96848
rand('seed',12345);
% init random draw
z = rand;
%draw sample
index = min(find(cdf>z));
sample = x_values(index);
end
