%Jenna Christensen 
%Macro Modeling 
%Professor Yang 
%March 12, 2019 

%Assignment 2

%Question 1a: Set Nz = 9 and develop a Markov Chain to approximate z_t. 
%Question 1b: Develop an algorithm to simulate your Markov Chain for 100
%periods. 

close all; clear; clc;

%Define variables for Tauchen Algorithm
rho = 0.909;
sigma_e = 0.014;
Nz = 9;
mu = 0;
s = 2.575;

%The Tauchen function is saved in the current working directory 

[Zgrid, piz] = tauchen(rho, sigma_e, Nz, mu, s); 
Zgrid = exp(Zgrid); %This will make sure that z_{t+1} = z_t^\rho*\epsilon^\epsilon_t

%Zgrid is now a row of discrete states and piz is a transition probability matrix

%Set space for P_dist and x_sim
global P_dist Simulation 

%Initiate space for P_dist
P_dist=[];

%Make each row of the probability transition matrix into a distribution so
%we can randomly draw from each 

n = length(piz);

for i = 1:n
P_dist = [P_dist,cumsum(piz(i,:))];
end

P_dist = transpose(reshape(P_dist, Nz, Nz));
cdf_test = P_dist(1,:); 

%Create a path 
[sample_test,index] = cdf_randomdraw(cdf_test,Zgrid);
index = 5;

%Set the sample size
sample_size=100;

for i=1:sample_size
    [sample,index]=cdf_randomdraw(P_dist(index,:),Zgrid);
    Simulation = [Simulation,sample];
end

%Simulation is a matrix with 100 simulations of randomly picked numbers