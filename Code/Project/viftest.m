nuke;
%Parameters:
gamma=0.5;
beta=0.3;%discount factor
error=0.05;
rb=1.05; %bond returns
rho = .05; 
sigma_e = 1; 
znum = 5; 
mu = 0; 
s = 1;
[states, statespace] = tauchen(rho, sigma_e, znum, mu, s); 

%Functions
utility=@(x)(x.^(1-gamma)-1)/(1-gamma);
reward=@(x,y)((1-x)*rb)+(x*y)  ;%reward of state)


sc=transpose(linspace(0,1,5));
u=zeros(length(sc));

%Variables
delta=0.1;
error=0.00000;
uprime=u;

while delta>error   
for s=1:length(sc)
clear max
clear index
eR=((1-sc)*rb)+(sc.w*states);%expected return
[max,index] = max(eR(:)); %location of maximum values
uprime(s)=reward(s,1.5)+beta.*uprime(s);

if abs(uprime(s)-u(s))>delta
    delta = abs(uprime(s)-u(s))
end
end
end


% while delta>error   
% for s=1:length(states)
%     eR=((1-sc)*rb)+(sc.*states);%expected return
%     eU=utility(eR);%utility of expected return
%     [max,index] = max(eU); %location of maximum values
%     uprime(s)=reward(states(s))+beta*eU;
%     
% if abs(uprime(s)-u(s))>delta
%     delta = abs(uprime(s)-u(s));
% end
% 
% end
% end