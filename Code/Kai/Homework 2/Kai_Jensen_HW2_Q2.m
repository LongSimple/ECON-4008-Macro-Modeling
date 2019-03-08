close; clear all; clc;
global Tv0
globalpar;%init parameters
%functions
utilityfunction = @(x)((x^(1-sigma))-1)/(1-sigma); %utility function
productionfunction = @(x)(A*(x.^alpha)); %production functions
%iteration counter for optimization
precision=1e-5;
distance=2*precision;
iteration=0;
%create markov chain
[zgrid,piz]=tauchen(rho,sigma_e,znum,Mu,s);  
%Model work
Tv = zeros(Knum,znum); %init current period value
G = Tv; %init decision rule
ev = zeros(Knum,znum); %init ev
v = zeros(Knum, znum); %init v



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
    
    for i=1:Knum %current K location
        for iz =1:znum %current z location
            for jz =1:znum %future z location
            ev(i, iz)= piz(iz,jz)*v(i,jz);
            [Tv(i,iz),loc] = max(Tv0(i,:)); %i(row index) j(column index) (find max in every row) 
            G(i) = Kgrid(loc); % G = value capital that gives max tv
            end
        end
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
