%Working Model (Including Simulation Code)
clear; close all; clc; 

load btcchoice_model.mat

%Use our steady state results from last time to simulate the economy for
%500 periods of time 

tperiod = 500; %Say we want to look at 500 total periods of time 

stockstates_sim_value = zeros(1, tperiod); %Realized TFP shock Values stored for each period 

%We also need to store the corresonding location 

stockstates_sim_location = stockstates_sim_value; %Store the location of each simulated shock value from the grid 

%Pick each current TFP state and store the transition probability from the
%Markov Chain 

prob_1 = stockstatesmarkov(1, :); %The First TFP state- Do this for all probability states
prob_2 = stockstatesmarkov(2, :); 
prob_3 = stockstatesmarkov(3, :); 
prob_4 = stockstatesmarkov(4, :); 
prob_5 = stockstatesmarkov(5, :); 
prob_6 = stockstatesmarkov(6, :); 
prob_7 = stockstatesmarkov(7, :); 
prob_8 = stockstatesmarkov(8, :); 
prob_9 = stockstatesmarkov(9, :); 
prob_10 = stockstatesmarkov(10, :); 
prob_11 = stockstatesmarkov(11, :); %The First TFP state- Do this for all probability states
prob_12 = stockstatesmarkov(12, :); 
prob_13 = stockstatesmarkov(13, :); 
prob_14 = stockstatesmarkov(14, :); 
prob_15 = stockstatesmarkov(15, :); 
% prob_16 = stockstatesmarkov(16, :); 
% prob_17 = stockstatesmarkov(17, :); 
% prob_18 = stockstatesmarkov(18, :); 
% prob_19 = stockstatesmarkov(19, :); 
% prob_20 = stockstatesmarkov(20, :);

%Suppose the starting stocks at t=1  is numberofstocks(1) and starting probability is stockstates(3)

stockstates_sim_location(1) = 3; %The first z is the third row of the matrix 
stockstates_sim_value(1) = stockstates(stockstates_sim_location(1)); 


%Now we need to fill in the rest of the periods for the TFP (the remaining
%499 periods) 
for t = 2:tperiod
   r = rand; %Generate random numbers between zero and 1 with uniformly distributed probability 
   if stockstates_sim_location(t-1) == 1 %Find where we are in the first period following our probability process      
       
       %Store the current location from this period 
       
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_1])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
       elseif stockstates_sim_location(t-1) == 2
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_2])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
       elseif stockstates_sim_location(t-1) == 3
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_3])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
               
       elseif  stockstates_sim_location(t-1) == 4
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_4])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
                   
       elseif stockstates_sim_location(t-1) == 5                
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_5])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
   
       elseif  stockstates_sim_location(t-1) == 6
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_6])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
       elseif  stockstates_sim_location(t-1) == 7
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_7])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
     elseif  stockstates_sim_location(t-1) == 8
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_8])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
      
      elseif  stockstates_sim_location(t-1) == 9
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_9])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
         
       elseif  stockstates_sim_location(t-1) == 10
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_10])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
   
       elseif stockstates_sim_location(t-1) == 11
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_11])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
       elseif stockstates_sim_location(t-1) == 12
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_12])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
       elseif stockstates_sim_location(t-1) == 13
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_13])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
               
       elseif  stockstates_sim_location(t-1) == 14
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_14])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
       
                   
       elseif stockstates_sim_location(t-1) == 15                
       stockstates_sim_location(t) = sum(r >= cumsum([0, prob_15])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
       stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
   
%        elseif  stockstates_sim_location(t-1) == 16
%        stockstates_sim_location(t) = sum(r >= cumsum([0, prob_16])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
%        stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
%        
%        elseif  stockstates_sim_location(t-1) == 17
%        stockstates_sim_location(t) = sum(r >= cumsum([0, prob_17])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
%        stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
%        
%      elseif  stockstates_sim_location(t-1) == 18
%        stockstates_sim_location(t) = sum(r >= cumsum([0, prob_18])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
%        stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
%       
%       elseif  stockstates_sim_location(t-1) == 19
%        stockstates_sim_location(t) = sum(r >= cumsum([0, prob_19])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
%        stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
%          
%        elseif  stockstates_sim_location(t-1) == 20
%        stockstates_sim_location(t) = sum(r >= cumsum([0, prob_20])); %If we draw a random number if it will transition us to a particular state- this manipulates Matlab to use uniformly randomly generated numbers to fit ino ur Markov transition probability 
%        stockstates_sim_value(t) = stockstates(stockstates_sim_location(t)); %This returns the corresponding value of the TFP z 
%    
       
       
       
       
   end 
end

%Initiate the variables to store the simulated results
  s_sim_value = zeros(1, tperiod); %Simulated stock value path 
  b_sim_value = zeros(1, tperiod); %Simulated bond value path 
  
%Starting with the state variable: s at t = 1- we previously supposed that
%the first value is 1
  
  s_sim_location(1) = 1; 
  s_sim_value(1) = numberofstocks(s_sim_location(1));
  b_sim_location(1) = s_sim_location(1); 
  b_sim_value(1) = numberofbonds(b_sim_location(1)); 
  
 %Now that we have the first period, we need to store for the rest of the periods 
  
  for t = 2:tperiod-1 
     %We already solved the decision rule- now we only need to call up those solved values 
     
     s_sim_value(t) = G2(s_sim_location(t-1), b_sim_location(t-1), stockstates_sim_location(t-1)); %This is our s value 
     
     %Convert our simulated stock values to our corresponding locations (using gridposition.m function file from
     %Sakai)
     
     s_sim_location(t) = gridposition(numberofstocks, s_sim_value(t));
     b_sim_location(t) = gridposition(numberofbonds, b_sim_value(t)); 
     
  end 

  


