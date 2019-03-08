clear; close all; clc;
iif = @(varargin) varargin{2 * find([varargin{1:2:end}], 1, 'first')}();
division = @(x)mod(x,2);
even = @(x)x/2;
odd = @(x)(3*x+1);
check = @(x)iif(division(x)==0,true,division(x)==1,false);
matrix = 'Enter an integer: ';% get input
matrix=input(matrix);
while matrix(end) > 1 % calculate members
matrix = [matrix,iif(check(matrix(end)),even(matrix(end)),true,odd(matrix(end)))];
end
disp(['The sequence starting with ' num2str(matrix(1)) ' will have ' num2str(numel(matrix)-1) ' members.']);%output