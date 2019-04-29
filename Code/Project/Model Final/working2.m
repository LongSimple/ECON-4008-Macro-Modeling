%Powerpoint: Research Questions, Motivation, Lit Review, Contribution

load btcchoice_model.mat

sample_size = 819; %sample size (time periods) take off 200 at end
[stockstates_sample_path_index, index] = deal(3); % starting state(index) for CDF Random Draw
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


% all_time_returns=sum(stock_sim_returnstest);

average_returns = mean(stock_sim_returnstest); 
stdev_returns = std(stock_sim_returnstest); 
% lagcorr = stock_sim_returnstest(1:end - 1, :)\stock_sim_returnstestlag; 
% 
% 
disp(average_returns) %We want this to equal 0.025441798
disp(stdev_returns) %We want this to equal 0.083099504
% disp(lagcorr) %We want this to equal -0.01500449