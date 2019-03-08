close; clear all; clc;

global Tv0

A=1; % aggregate productivity
alpha=0.36; % capital share of output (alpha)
beta=0.96; % subjective discoun;ting (beta)
depreciation=0.069;% depreciation
sigma=2;

%init kgrid
klow=0.01;
khigh=6;
Knum=250;
Kgrid = linspace(klow,khigh,Knum);

%functions
utilityfunction = @(x)((x^(1-sigma))-1)/(1-sigma); %utility function
productionfunction = @(x)(A*(x.^alpha)); %production function

%values
Tv = zeros(size(Kgrid));
v = Tv; 
G = Tv; %decision rule

%iteration counter
precision=1e-5;
distance=2*precision;
iteration=0;

while distance > precision %stopping rule
    Tv0 = zeros(Knum, Knum);
    c0 = Tv0;
    for i=1:Knum
        for j=1:Knum
            c0(i,j)=productionfunction(Kgrid(i))+(1-depreciation)*Kgrid(i)-Kgrid(j);
            Tv0(i,j)=utilityfunction(c0(i,j)+beta*v(j));
        end
    end
    for i=1:Knum
        [Tv(i),loc] = max(Tv0(i,:));
        G(i) = Kgrid(loc);
    end
    distance = max(max((abs(Tv - v))));
    v = Tv;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||Tv-v|| = %8.6f ', iteration, distance);
    disp(s)
end