nuke;
beta=.1001;
rho = .859; 
sigma_e = .014; 
znum = 10; 
mu = 0; 
s = 2.575;
[realstockstates, stockstatesmarkov] = tauchen(rho, sigma_e, znum, mu, s);
realstockstates=realstockstates*1000;

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
todaysvalue = (c.^(1-gamma)-1)/(1-gamma);

        for sprime =1:length(numberofstocks)
            for bprime =1:length(numberofbonds) 
                addthis(sprime,bprime,states)=beta*eV(sprime,bprime,states);
            end 
        end 
todaysvalue=todaysvalue+addthis;

test2=flip(todaysvalue,2);

for states=1:length(stockstates)
test3(:,states)=diag(test2(:,:,states),1);
test5(:,:,states)=diag(test3(:,states),1);
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
    V=todaysvalue;
    iteration = iteration + 1;
    s = sprintf ( ' iteration %4d    ||TV-V|| = %8.6f ', iteration, distance);
    disp(s) 
    
end
vsave(:,:,runtest)=V;
end