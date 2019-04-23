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
                   c=max(c,0);
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
