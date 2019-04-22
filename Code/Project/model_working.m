%nuke;
beta=.1001;
rho = .859; 
sigma_e = .014; 
znum = 10; 
mu = 0; 
s = 2.575;
gamma=0.5;

[realstockstates, stockstatesmarkov] = tauchen(rho, sigma_e, znum, mu, s);
realstockstates=realstockstates*1000;
utility=@(x)(x.^(1-gamma)-1)/(1-gamma);


for runtest=1:(length(realstockstates))
rb=1.04;
accuracy=10;
gamma=0.5;
maxholdings=1;

stockstates=realstockstates(:,runtest);
numberofbonds=linspace(0,maxholdings,accuracy); %bond allocation number
numberofstocks=numberofbonds; %stock allocation number
TV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates));
V = TV;
G = TV;

bondstates=transpose(rb*ones(length(stockstates),1));%riskfree rate

precision = 1e-20;
distance = 2*precision;
iteration = 0;
while distance > precision
    
eV = zeros(length(numberofstocks),length(numberofstocks),length(stockstates)); %check this    
    for b = 1:length(numberofbonds)
        for s = 1:length(numberofstocks)
            for states=1:length(stockstates)
                for futurestates=1:length(stockstates)
                    eV(s,b,states) = eV(s,b,states) + beta*(stockstatesmarkov(states,futurestates)*V(b,s,futurestates));%look at this
                end
            end
        end
    end
    clear states
    clear futurestates
    c=[];
    
for states = 1:length(stockstates)
        for sprime =1:length(numberofstocks)
            for bprime =1:length(numberofbonds)          
                    c(sprime,bprime,states)=((bondstates(states)*numberofbonds((accuracy/2)))+(stockstates(states)*numberofstocks(accuracy/2)))-((bondstates(states)*numberofbonds(bprime)+(stockstates(states)*numberofstocks(sprime))));
                   c=max(c,0);
            end %make s and b constatnt
        end
end

todaysvalue=[];
todaysvalue = utility(c);

        for sprime =1:length(numberofstocks)
            for bprime =1:length(numberofbonds) 
                addthis(sprime,bprime,states)=beta*eV(sprime,bprime,states);
            end 
        end 
[todaysvalue,todaysvaluetest]=deal(todaysvalue+addthis);

test2=flip(todaysvalue,2);

for states=1:length(stockstates)
test3(:,states)=diag(test2(:,:,states),1);
test5(:,:,states)=diag(test3(:,states),1); %has something to do with our decision rule
end

todaysvalue=flip(test5,2);
indexarray=[];

for states=1:length(stockstates)
    clear max 
    clear index
ctest=todaysvalue(:,:,states);
[max,index] = max(ctest(:));
indexarray(states)=index+((states-1)*(length(todaysvalue)^2));
end
    clear max
    clear index
    todaysvalue=max(todaysvalue,0);
    distance = max(max(abs(todaysvalue-V))); %need to hold a matrix constant once it has been maximized 
    V=todaysvaluetest;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, distance);
    disp(s) 
    
end
vsave(:,:,runtest)=V;
endnuke;
%Parameters
alpha = .36; %Capital share of output 
d = .069; %Capital depreciation rate 
beta = .96; %Subjective discount rate 
sigma = 2; %Risk aversion parameter 
A = 1; %Aggregate TFP
rb=1.05;%bondreturns

%Set the state space for k, capital 

Kl = 0; 
Kh = 1; 
Knum = 250; 
stockchoice = linspace(Kl, Kh, Knum); 

%Declare Zgrid Parameters

%Define the parameters 
rho = .859; %Persistence 
sigma_e = .014; %Standard deviation
Nz = 9; %Nine different states- shock grid size 
mu = 0; %Mean of standard normal distribution
s = 2.575; %Technical term describing the coverage for the normal distribution

%Save the output
[stockstates, returnsstock] = tauchen(rho, sigma_e, Nz, mu, s); 
stockstates = exp(stockstates); 

Tv = zeros(Knum, Nz); %Tv is the current lifetime value 
V = Tv; %V is the future lifetime value 
G = Tv; %G is the decision rule which is otherwise known as K' 

precision = 1e-5; %This describes how precise our model will be (setting what equals zero)
distance = 2 * precision; %This measures the difference between Tv and V 
iteration = 0; %Set a counter to see how many iterations Matlab needs to solve the model 

while distance > precision
    ev = zeros(Knum, Nz); %Initiate expected value space
    for i = 1:Knum  % for each current k
        for iz = 1:Nz  % for each current z
            for jz = 1:Nz  % for each future z'
                ev(i,iz) = ev(i,iz) + returnsstock(iz,jz)*V(i,jz);  % the expected value is summing all possible realization of v'  
                                                           % adjusted by the probability of realizing the state
            end
        end
    end   
  c0 = zeros(Knum, Nz, Knum);
  Tv0 = c0;   
    for i = 1:Knum  % current K
        for iz = 1:Nz % current z
            for j = 1:Knum  % future K'
                cval = ((rb*(1-stockchoice(i)))+ (stockchoice(i)*stockstates(iz)))-((rb*(1-stockchoice(j)))+(stockchoice(j)*.5));%will need to change this here
                c0(i,iz, j) = max(cval, 0);% c cannot be negative
                Tv0(i,iz, j) = (c0(i,iz,j)^(1-sigma)-1)/(1-sigma) + beta*ev(j,iz);            
            end
        end
    end 
    for i = 1:Knum
        for iz = 1:Nz
            [Tv(i,iz),loc] = max(Tv0(i,iz,:));
            G(i,iz) = stockchoice(loc);
        end
    end    
    distance = max(max(max(abs(Tv - V)))); 
    V = Tv; 
    s = sprintf( ' iteration %4d ||Tv - V|| = %8.6f ', iteration, distance); 
    disp(s)
    iteration = iteration + 1; 
        
end

save uncertainty.mat
end