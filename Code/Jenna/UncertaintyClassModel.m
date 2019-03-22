%Class Exercise (Optimum Growth Model- Infinite Horizon with Uncertainty)
%February 28, 2019 

clear; close all; clc; 

%Declare the parameters 

alpha = .36; %Capital share of output 
d = .069; %Capital depreciation rate 
beta = .96; %Subjective discount rate 
sigma = 2; %Risk aversion parameter 
A = 1; %Aggregate TFP

%Set the state space for k, capital 

Kl = .01; 
Kh = 6; 
Knum = 250; 

Kgrid = linspace(Kl, Kh, Knum); 

%Declare Zgrid Parameters

%Define the parameters 
rho = .859; %Persistence 
sigma_e = .014; %Standard deviation
Nz = 5; %Five different states- shock grid size 
mu = 0; %Mean of standard normal distribution
s = 2.575; %Technical term describing the coverage for the normal distribution

%Save the output
[zgrid, piz] = tauchen(rho, sigma_e, Nz, mu, s); 
zgrid = exp(zgrid); 


%Initiate values for the model

Tv = zeros(Knum, Nz); %Tv is the current lifetime value 
V = Tv; %V is the future lifetime value 
G = Tv; %G is the decision rule which is otherwise known as K' 

%Now we will implement a method of successive approximation to solve the
%infinite horizon model

%Set the stopping rules 
precision = 1e-5; %This describes how precise our model will be (setting what equals zero)
distance = 2 * precision; %This measures the difference between Tv and V 

%Note: Our goal is to minimize the distance between Tv and V- we are
%essentially setting them equal to eachother but approximating what we
%consider zero to be 

iteration = 0; %Set a counter to see how many iterations Matlab needs to solve the model 

%Now create a while loop for a successive approximation 

while distance > precision % continue until precision is not less than distance 
    
    %Insert Expected Value 
    ev = zeros(Knum, Nz); %Initiate expected value space

%Calculate future expected values given current K(i) and current Z(i)

for i = 1: Knum %Current K location
    for iz = 1:Nz %Current Z location
        for jz = 1:Nz %Future Z location 
         
            %Store the epected value 
           
            ev(i, iz) = ev(i, iz)+ piz(iz, jz) * V(i, jz); 
            
        end 
    end
end
    

    c0 = zeros(Knum, Nz, Knum); %The first Knum and Nz tells us the current grid dimension- Now given each future K, what is the value of the lifetime value? 
    Tv0 = c0; %This grid will be a matrix with current capital as rows and then columns of future capital- given current k, which k' maximizes the value function and store it
    
    for i = 1:Knum %For each current choice of K on Kgrid 
        for iz = 1:Nz %This is for each current shock state we are in (which row we are picking from)
        for j = i: Knum %For each future choice of capital, K' 
        
            %Find the possible consumption while constrained to a budget 
            c0(i, iz, j) = max(zgrid(iz)*Kgrid(i)^alpha + (1-d)*Kgrid(i) - Kgrid(j), 0); %Choose the max because consumption cannot be below zero
            Tv0(i, iz, j) = log(c0(i, iz,j)) + beta*ev(i, iz);  %This finds all of the possible candidates 
            
        end
        end 
    end 

    %Given each current level of capital, find the future level of capital
    %that maximizes the lifetime value, Tv
    
    for i = 1:Knum
        for iz = 1:Nz 
       
        %We are going to store the maximum values and locations for later
        %use with the decision rule 
        
       [val, loc] = max(Tv0(i, iz, :)); 
       
       %Store all the optimized values and their corresponding locations in
       %Tv
       
       Tv(i, iz) = val; 
       
       %We not only want to solve the lifetime value but we also want to
       %know which capital provides the solution 
       
       G(i, iz) = Kgrid(loc); 
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

%Create a 3d plot of Tv and G

sur(Tv)
surf(G)

