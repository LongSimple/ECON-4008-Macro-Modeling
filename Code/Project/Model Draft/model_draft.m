%nuke;
beta=.1001;
rho = .859; 
sigma_e = .014; 
znum = 10; 
mu = 0; 
s = 2.575;
gamma=0.5;

[stockstates, stockstatesmarkov] = tauchen(rho, sigma_e, znum, mu, s);
stockstates=stockstates*1000;
utility=@(x)(x.^(1-gamma)-1)/(1-gamma);

rb=1.04;
accuracy=10;
gamma=0.5;
maxholdings=1;

numberofbonds=linspace(0,maxholdings,accuracy); %bond allocation number
numberofstocks=numberofbonds; %stock allocation number
TV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates));
V = TV;
G = TV;

bondstates=transpose(rb*ones(length(stockstates),1));%riskfree rate

precision = 1e-5;
distance = 2*precision;
iteration = 0;
while distance > precision
    
eV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates)); %check this    
    for b = 1:length(numberofbonds)
        for s = 1:length(numberofstocks)
            for states=1:length(stockstates)
                for futurestates=1:length(stockstates)
                    eV(s,b,states) = eV(s,b,states) +(stockstatesmarkov(states,futurestates)*V(b,s,futurestates));%look at this
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
                    c(s,b,sprime,bprime,states)=((bondstates(states)*numberofbonds(b)+(stockstates(states)*numberofstocks(s))- (numberofbonds(bprime)-numberofstocks(sprime))));
                   c=max(c,1e-4);
            end %make s and b constatnt
        end
        end
    end
end
Tv0 = utility(c)+ beta*eV;


for s = 1:length(numberofstocks)
    for b = 1:length(numberofbonds)
                    for bprime = 1:length(numberofbonds)
        for states = 1:length(stockstates)
            [Tv1(s,b,bprime,states),loc1(s,b,bprime,states)] = max(Tv0(s,b,bprime,states,:));
    
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

save uncertainty.mat


%Below is what I think should be our simulation. There's an error somewhere
%in it, but I'm not sure where. This is indicated by the fact that the
%s_sim_value is zero for all 500 entries



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
   
   end 
end

%Initiate the variables to store the simulated results
  s_sim_value = zeros(1, tperiod); %Simulated stock value path 
  
%Starting with the state variable: s at t = 1- we previously supposed that
%the first value is 1
  
  s_sim_location(1) = 1; 
  s_sim_value(1) = numberofstocks(s_sim_location(1));
  
   %Now that we have the first period, we need to store for the rest of the
  %periods 
  
  for t = 2:tperiod 
     %We already solved the decision rule- now we only need to call up those solved values 
     
     s_sim_value(t) = G2(s_sim_location(t-1), stockstates_sim_location(t-1)); %This is our s value 
     
     %Convert our simulated stock values to our corresponding locations (using gridposition.m function file from
     %Sakai)
     
     s_sim_location(t) = gridposition(numberofstocks, s_sim_value(t));   
  end 

