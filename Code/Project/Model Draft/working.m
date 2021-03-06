%Working Model (Including Simulation Code)
clear; close all; clc; 
%We will adjust rho, sigma, and mu to match the mean (.002738743), standard deviation (.045007658),
%and AR 1 correlation coefficient (-.01500449) in the observed returns of Bitcoin 
beta= .95;
rho = -.999995; %Adjust this
sigma_e = 0.083099504; %Adjust this
mu = 0.025441798; %Adjust this
s = 2.575;
gamma=2;
importmarkovdata;
importmarkovstates;
znum=length(stockstates);utility=@(x)(x.^(1-gamma)-1)/(1-gamma);
rb=1.0225;
accuracy=10;
maxholdings=1;
stockstates=exp(stockstates);
Y = 1; %An initial endowment 
numberofbonds=linspace(0,maxholdings,accuracy); %bond allocation number
numberofstocks=numberofbonds; %stock allocation number
TV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates));
V = TV;
G = TV;
bondstates=transpose(rb*ones(length(stockstates),1));%risk-free rate

precision = .0005;
distance = 2*precision;
iteration = 0;
while distance > precision   
eV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates)); %check this    
    for b = 1:length(numberofbonds)
        for s = 1:length(numberofstocks)
            for states=1:length(stockstates)
                for futurestates=1:length(stockstates)
                    eV(s,b,states) = eV(s,b,states) +(stockstatesmarkov(states,futurestates)*V(s,b,futurestates));%look at this
                end
            end
        end
    end
    clear states
    clear futurestates
    c=[];
for states = 1:length(stockstates)
    for s = 1:length(numberofstocks)
        for b = 1:length(numberofbonds)
        for sprime =1:length(numberofstocks)
            for bprime =1:length(numberofbonds)          
                    c(s,b,sprime,bprime,states)= numberofbonds(b) + numberofstocks(s) + Y - ((1/(bondstates(states)))*numberofbonds(bprime)) - ((1/(stockstates(states)))*numberofstocks(sprime)); 
                    Tv0(s,b,sprime,bprime,states) = utility(c(s,b,sprime,bprime,states)) + beta*eV(sprime,bprime,states);
            end
        end
        end
    end
end
% Tv0 = utility(c)+ beta*eV;
for s = 1:length(numberofstocks)
    for b = 1:length(numberofbonds)
        for bprime = 1:length(numberofbonds)
            for states = 1:length(stockstates)
                [Tv1(s,b,bprime,states),loc1(s,b,bprime,states)] = max(Tv0(s,b,:,bprime,states));
            end
        end
    end 
end 

for s =1:length(numberofstocks)
    for b =1:length(numberofbonds) 
        for states = 1:length(stockstates)
            [Tv(s,b,states),loc] = max(Tv1(s,b,:,states));
            G(s,b,states)=numberofbonds(loc);
            G2(s,b,states)=numberofstocks(loc1(s,b,loc,states));
        end
    end
end

    distance = max(max(max(abs(Tv-V)))); %need to hold a matrix constant once it has been maximized 
    V=Tv;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, distance);
    disp(s) 
    
end

save btcchoice_model.mat

sample_size = 1019; %sample size (time periods) take off 200 at end
[stockstates_sample_path_index, index] = deal(41); % starting state(index) for CDF Random Draw
stockstates_sample_path = stockstates(index);

%Make Probability Distribution
P_dist=[];
for i = 1:length(stockstatesmarkov)
    P_dist = [P_dist, cumsum(stockstatesmarkov(i, :))];
end
P_dist = transpose(reshape(P_dist, znum, znum));

%Random Draw
for i = 1:sample_size - 1
    [sample, index] = cdf_randomdraw(P_dist(index, :), stockstates);
    [stockstates_sample_path, stockstates_sample_path_index] = deal([stockstates_sample_path, sample], [stockstates_sample_path_index, index]);
end
%Initiate the variables to store the simulated results
[s_sim_value,b_sim_value] = deal(zeros(1, sample_size)); %Simulated stock value path 
 
%Starting with the state variable: s at t = 1- we previously supposed that
%the first value is 1

  s_sim_location(1) = 1; 
  s_sim_value(1) = numberofstocks(s_sim_location(1));
  
  b_sim_location(1) = s_sim_location(1); 
  b_sim_value(1) = numberofbonds(b_sim_location(1)); 
  
 %Use decision rule
  for t = 2:sample_size-1 
     s_sim_value(t) = G2(s_sim_location(t-1), b_sim_location(t-1), stockstates_sample_path_index(t-1)); %s value 
     s_sim_location(t) = find(numberofstocks == s_sim_value(t));
     b_sim_location(t) = find(numberofbonds == b_sim_value(t)); 
  end 
for q = 1:length(stockstates_sample_path)
    stock_sim_returns(q)=s_sim_value(q)*stockstates_sample_path(q);
end

n=200;%truncate this
stock_sim_returnstest=transpose(stock_sim_returns);
stock_sim_returnstest=stock_sim_returnstest(n+1:end,:);
% stock_sim_returnstestlag = stock_sim_returnstest(2:end,:); 


all_time_returns=sum(stock_sim_returnstest);

% average_returns = mean(stock_sim_returnstest); 
% stdev_returns = std(stock_sim_returnstest); 
% lagcorr = stock_sim_returnstest(1:end - 1, :)\stock_sim_returnstestlag; 
% 
% 
% disp(average_returns) %We want this to equal 0.025441798
% disp(stdev_returns) %We want this to equal 0.083099504
% disp(lagcorr) %We want this to equal -0.01500449