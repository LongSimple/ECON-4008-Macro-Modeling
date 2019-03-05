close; clc;
global Tv0
A=1; % aggregate productivity
alpha=0.36; % capital share of output (alpha)
beta=0.96; % subjective discoun;ting (beta)
depreciation=0.069;% depreciation
sigma=2;

%init kgrid (capital)
klow=0.01;
khigh=6;
Knum=250;
Kgrid = linspace(klow,khigh,Knum);

%iteration counter
precision=1e-5;
distance=2*precision;
iteration=0;

%functions
utilityfunction = @(x)((x^(1-sigma))-1)/(1-sigma); %utility function
productionfunction = @(x)(A*(x.^alpha)); %production function

Tv = zeros(size(Kgrid)); %init current period value
v = Tv; %init future period value
G = Tv; %init decision rule

    for i = 1:Knum  % current K (row in matrix)
        for j = 1:Knum  % future K' (column in matrix)
            c0(i,j) =  max(A*(Kgrid(i))^alpha + (1-depreciation)*Kgrid(i) - Kgrid(j), 0);  % c cannot be negative so set max at 0
        end
    end

while distance > precision %init successive approximation 
    
    % same as the two period model algorithm, our purpose is to find the
    % choice of K' that makes the life time value the highest, and we store
    % the value of K' in decision rule G. 
    
    % Difference is that instead of computing directly the future (second
    % period) value, we assume it a starting value 0, and taken it as given
    % to find K' to maximize Tv = u(c) + beta*v with the assumed v. 
    
    % At the end of each iteration, we update our assumption of V (future
    % value), since we know in steady state (stationary equilibrium), Tv =
    % V. 
    
    % We successfully found our solution when Tv = V. This is done through
    % updating the "distance" our maxstopping criteria. 
    
    Tv0 = zeros(Knum, Knum); %future capital k'(rows) current capital(columns) % Tv0 records all the possible candidates of lifetime value currently, given all future possible choices of K'
    i = 1:Knum; % current K (row in matrix)
        for j = 1:Knum  % future K' (column in matrix)
            Tv0(i,j) = (c0(i,j).^(1-sigma)-1)/(1-sigma)+ beta*v(j);            
        end
    
    for i = 1:Knum %for each k (row) choose the k' that maximizes lifetime value
        [Tv(i),loc] = max(Tv0(i,:)); %i(row index) j(column index) (find max in every row) 
        G(i) = Kgrid(loc); % G = value capital that gives max tv
    end     
    
    distance = max(max((abs(Tv - v))));
    v = Tv; %save max vs for next run
    
    % this is how I want to display the result. Telling me how many times
    % it has been iterated upon; and how close our guess is each time. 
    s = sprintf ( '||Tv-v|| = %8.6f ', distance);
    disp(s)    
        
end


figure

subplot(211)
plot(Kgrid, v)
hold on
title ( ' the value function ' )

subplot(212)
plot(G,Kgrid,Kgrid, Kgrid)
hold on
title ( ' the decision rule ' )

saveas(gcf,'optimal_certain_infinite.png')
