%Bitcoin Treasury Bill Tradeoff Model using a Bootstrap Markov Chain(Including Simulation Code)
clear; close all; clc; 

%Parameters
beta= .95; %Depreciation
gamma=.5;%Risk Aversion
rb=1.0225; %Bond Return
Y = 1; %An initial endowment 

%Import Markov Chain
importmarkovdata;
importmarkovstates;
stockstates=exp(stockstates);
znum=length(stockstates);

%Utility Function
utility=@(x)(x.^(1-gamma)-1)/(1-gamma);

%Init Variables
accuracy=10;
maxholdings=1;
numberofbonds=linspace(0,maxholdings,accuracy); %bond allocation number
numberofstocks=numberofbonds; %stock allocation number
[TV,V,G] = deal(zeros(length(numberofstocks),length(numberofstocks),length(stockstates)));
bondstates=transpose(rb*ones(length(stockstates),1));%risk-free rate

%Successive Approximation Parameters
precision = .005;
distance = 2*precision;
iteration = 0;

%Successive Approximation Algorithim
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

%Simulation
simulation_runs = 10;%Run Simulation x times


for runs = 1:simulation_runs

%Variables for Random Draw
sample_size=819; %sample size (time periods)
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

stockstates_sample_pathlag = stockstates_sample_path(2:end); 
stock_sim_returnslag = stock_sim_returns(2:end); 


average_returns(runs) = mean(stockstates_sample_path);
average_returns_drule(runs) = mean(stock_sim_returns);
stdev_returns(runs) = std(stockstates_sample_path);
stdev_returns_drule(runs) = std(stock_sim_returns);
lagcorr(runs) = stockstates_sample_path(1:end - 1)/stockstates_sample_pathlag;
lagcorr_drule(runs) = stock_sim_returns(1:end - 1)/stock_sim_returnslag;

end

average_returns_val = mean(average_returns);
average_returns_drule_val = mean(average_returns_drule);

stdev_returns_val = mean(stdev_returns);
stdev_returns_drule_val = mean(stdev_returns_drule);

lagcorr_val = mean(lagcorr);
lagcorr_drule_val = mean(lagcorr_drule);

