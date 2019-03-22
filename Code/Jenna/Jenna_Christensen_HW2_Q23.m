%Jenna Christensen 
%ECON 4008-01
%Professor Yang
%March 12, 2019

%Assignment 2 

%Question 2

%Solve the stochastic dynamic programming problem of the one-sector growth
%model using discrete state space dynamic programming. 
%Declare the parameters 

alpha = .36; %Capital share of output 
d = .069; %Capital depreciation rate 
beta = .96; %Subjective discount rate 
sigma = 2; %Risk aversion parameter 
A = 1; %Aggregate TFP

%Set the state space for k, capital 

Kl = .1; 
Kh = 6; 
Knum = 250; 

Kgrid = linspace(Kl, Kh, Knum); 

%Declare Zgrid Parameters

%Define the parameters 
rho = .859; %Persistence 
sigma_e = .014; %Standard deviation
Nz = 9; %Nine different states- shock grid size 
mu = 0; %Mean of standard normal distribution
s = 2.575; %Technical term describing the coverage for the normal distribution

%Save the output
[zgrid, piz] = tauchen(rho, sigma_e, Nz, mu, s); 
zgrid = exp(zgrid); 

Tv = zeros(Knum, Nz); %Tv is the current lifetime value 
V = Tv; %V is the future lifetime value 
G = Tv; %G is the decision rule which is otherwise known as K' 

%Now we will implement a method of successive approximation to solve the
%infinite horizon model

precision = 1e-5; %This describes how precise our model will be (setting what equals zero)
distance = 2 * precision; %This measures the difference between Tv and V 
iteration = 0; %Set a counter to see how many iterations Matlab needs to solve the model 

while distance > precision
    
    %Insert Expected Value 
    ev = zeros(Knum, Nz); %Initiate expected value space
    
    
    for i = 1:Knum  % for each current k
        for iz = 1:Nz  % for each current z
            for jz = 1:Nz  % for each future z'
                ev(i,iz) = ev(i,iz) + piz(iz,jz)*V(i,jz);  % the expected value is summing all possible realization of v'  
                                                           % adjusted by the probability of realizing the state
            end
        end
    end
    
  c0 = zeros(Knum, Nz, Knum); %The first Knum and Nz tells us the current grid dimension- Now given each future K, what is the value of the lifetime value? 
  Tv0 = c0; %This grid will be a matrix with current capital as rows and then columns of future capital- given current k, which k' maximizes the value function and store it
    
    for i = 1:Knum  % current K
        for iz = 1:Nz % current z
            for j = 1:Knum  % future K'
                cval =  zgrid(iz)*(Kgrid(i))^alpha + (1-d)*Kgrid(i) - Kgrid(j); 
                c0(i,iz, j) = max(cval, 0);% c cannot be negative
                Tv0(i,iz, j) = (c0(i,iz,j)^(1-sigma)-1)/(1-sigma) + beta*ev(j,iz);            
            end
        end
    end
    
    % choose the k' that maximizes lifetime value (given each current K and z)
    for i = 1:Knum
        for iz = 1:Nz
            [Tv(i,iz),loc] = max(Tv0(i,iz,:));
            G(i,iz) = Kgrid(loc);
        end
    end    
    
        %We want to evaluate if our guessed value and our optimized value are
    %the same (recall: we started by just guessing)  
    
    %We now have Tv as a single row matrix with highest K' values- we want
    %to make sure the distance is zero 
    
    distance = max(max(max(abs(Tv - V)))); 
    
    %Now update the initial guess so we make sure the values of today and
    %tomorrow are converging- use our current optimized value to replace
    %our guess
    
    V = Tv; 
    
    %Print each step so we know if Matlab is functioning correctly 
    
    s = sprintf( ' iteration %4d ||Tv - V|| = %8.6f ', iteration, distance); 
    disp(s)
    
    %Update the counter- we assumed the iteration was zero- now we need to
    %update it 
    
    iteration = iteration + 1; 
        
end

save uncertainty.mat

figure  % below is the code to generate and export a 3-D graph that we generated

[Zmat, Kmat] = meshgrid(zgrid, Kgrid);

subplot(211)
mesh(Zmat, Kmat, V)
hold on
title ( ' The Value Function ' )

subplot(212)
mesh(Zmat, Kmat, G)
hold on
title ( ' The Decision Rule ' )

%Question 3
%Use the simulated 100 periods of shock values from (1) and the stationary equilibrium values and decision rules from (2), simulate the economy for 100 periods, and report the aggregate output for each period. Assume the period 0 starting capital K(0) = Kgrid(20).


%Use our steady state results from the previous problems to simulate the economy for
%100 periods of time 


% Monte Carlo Simulation for 500 time periods
z_period = 100;
z_sim_vec = zeros(1,z_period); % realized value of z 
z_sim_index = z_sim_vec;   % location of realized value of z in zgrid

% arbitrarily, I start z(1) at the third value of z grid
z_sim_index(1) = 5; 
z_sim_vec(1) = zgrid(5); 

% let Matlab randomly generate numbers between 1-9 that follows the
% probability of the Markov Chain:

prob_1 = piz(1,:); % given current z state, as z1, what's the probability transitioning to any other state
prob_2 = piz(2,:); % given current z state, as z2, what's the probability transitioning to any other state
prob_3 = piz(3,:);
prob_4 = piz(4,:);
prob_5 = piz(5,:); 
prob_6 = piz(6,:); 
prob_7 = piz(7,:); 
prob_8 = piz(8,:); 
prob_9 = piz(9,:); 


for t = 2:z_period
    
    r = rand;  % randomly returns a single number that's uniformly distributed in (0,1)
    % If our previous draw is the first state:
    if z_sim_index(t-1) == 1
        % find where does the randomly generated number r falls in the
        % Markov Chain probability 
        z_sim_index(t) = sum(r >= cumsum([0, prob_1]));  
        z_sim_vec(t) = zgrid(z_sim_index(t));
    % if our previous draw is the second state: 
    elseif z_sim_index(t-1) == 2
        z_sim_index(t) = sum(r >= cumsum([0, prob_2]));
        z_sim_vec(t) = zgrid(z_sim_index(t));  
    elseif z_sim_index(t-1) == 3
        z_sim_index(t) = sum(r >= cumsum([0, prob_3]));
        z_sim_vec(t) = zgrid(z_sim_index(t));
    elseif z_sim_index(t-1) == 4
        z_sim_index(t) = sum(r >= cumsum([0, prob_4]));
        z_sim_vec(t) = zgrid(z_sim_index(t));    
    elseif z_sim_index(t-1) == 5
        z_sim_index(t) = sum(r >= cumsum([0, prob_5]));
        z_sim_vec(t) = zgrid(z_sim_index(t));  
    elseif z_sim_index(t-1) == 6
        z_sim_index(t) = sum(r >= cumsum([0, prob_6]));
        z_sim_vec(t) = zgrid(z_sim_index(t));
    elseif z_sim_index(t-1) == 7
        z_sim_index(t) = sum(r >= cumsum([0, prob_7]));
        z_sim_vec(t) = zgrid(z_sim_index(t));
    elseif z_sim_index(t-1) == 8
        z_sim_index(t) = sum(r >= cumsum([0, prob_8]));
        z_sim_vec(t) = zgrid(z_sim_index(t));
    elseif z_sim_index(t-1) == 9
        z_sim_index(t) = sum(r >= cumsum([0, prob_9]));
        z_sim_vec(t) = zgrid(z_sim_index(t));
        
    end    
 
end 


%Initiate the variables to store the simulated results 
%Convert our simulated K values to our corresponding locations (using gridposition.m function file from
%Sakai)

K_sim_vec = zeros(size(z_sim_vec));
K_sim_index = K_sim_vec;
K_sim_vec(1) = Kgrid(20); %Assume that the starting capital is "Kgrid(20)"
K_sim_index(1) = 20;

for t = 2:z_period
    K_sim_vec(t) = G(K_sim_index(t-1), z_sim_index(t-1));
    K_sim_index(t) = gridposition(Kgrid, K_sim_vec(t));
end

%Now look at how the rest of the economy (Output and consumption)

Y_sim_vec = zeros(1,z_period-1);
C_sim_vec= Y_sim_vec;

for t = 1:z_period-1
    Y_sim_vec(t) = z_sim_vec(t)*K_sim_vec(t)^alpha;
    C_sim_vec(t) = Y_sim_vec(t) + (1-d)*K_sim_vec(t) - K_sim_vec(t+1);
end

figure

subplot (311)
plot(Y_sim_vec)
hold on
title ( ' GDP Simulation of 100 Periods ' )

subplot (312)
plot(K_sim_vec)
hold on
title ( ' Capital Simulation of 100 Periods ' )


subplot (313)
plot(C_sim_vec)
hold on
title ( ' Consumption Simulation of 100 periods ' )

    

