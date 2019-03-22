%Class Exercise (Optimum Growth Model- Infinite Horizon)
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

%Initiate values for the model

Tv = zeros(size(Kgrid)); %Tv is the current lifetime value 
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
    
    c0 = zeros(Knum, Knum); 
    Tv0 = c0; %This grid will be a matrix with current capital as rows and then columns of future capital- given current k, which k' maximizes the value function and store it
    
    for i = 1:Knum %For each current choice of K on Kgrid 
        for j = i: Knum %For each future choice of capital, K' 
        
            %Find the possible consumption while constrained to a budget 
            c0(i,j) = max(A*Kgrid(i)^alpha + (1-d)*Kgrid(i) - Kgrid(j), 0); 
            Tv0(i,j) = log(c0(i,j)) + beta*V(j);  %This finds all of the possible candidates 
            
           
           
        end 
    end 

    %Given each current level of capital, find the future level of capital
    %that maximizes the lifetime value, Tv
    
    
    for i =1:Knum
       
        %We are going to store the maximum values and locations for later
        %use with the decision rule 
        
       [val, loc] = max(Tv0(i,:)); 
       
       %Store all the optimized values and their corresponding locations in
       %Tv
       
       Tv(i) = val; 
       
       %We not only want to solve the lifetime value but we also want to
       %know which capital provides the solution 
       
       G(i) = Kgrid(loc); 
       
    end
    
    %We want to evaluate if our guessed value and our optimized value are
    %the same (recall: we started by just guessing)  
    
    %We now have Tv as a single row matrix with highest K' values- we want
    %to make sure the distance is zero 
    
    distance = max(max(abs(Tv - V))); 
    
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


%Create a visualization of the results 

figure 

%Make two graphs "stacked on top of eachother" 

subplot (211) 
plot(Kgrid, Tv) %Plotting the value function
hold on % Add more features 
title ('The Value Function')
subplot(212) 
plot(Kgrid, G, Kgrid, Kgrid) %Plot the decision rule 
hold on 
title ('The Decision Rule')


        
