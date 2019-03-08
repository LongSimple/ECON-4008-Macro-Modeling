close; clear; clc;

global cp1 vp1 cp2 vp2 value gk 

A=1; % aggregate productivity
a=0.36; % capital share of output (alpha)
b=0.96; % subjective discoun;ting (beta)
d=0.069;% depreciation

klow=0.1;
khigh=6;
knum=250;
kgrid = linspace(klow,khigh,knum);

u = @(x)log(x); %utility function
p = @(x)(A*(x.^a)); %production function
cp1f =@(x,y)max(p(kgrid(x))+(1-d)*kgrid(x)-kgrid(y),0);

cp2=[cp2,p(kgrid(1:knum))+((1-d)*kgrid(1:knum))]; %period 2
vp2=[vp2,u(cp2(1:knum))];

for i=1:knum %period 1
   for j=1:knum
     cp1(i,j)=cp1f(i,j);
     vp1(i,j)= log(cp1(i,j))+(b*vp2(j));
    end
  value=[value,max(vp1(i,:))];
  [val,loc] = max(vp1(i,:));
  gk=[gk,kgrid(loc)];
end

figure
subplot(211)
plot(kgrid, value)
hold on
title ( ' the value function ' )
subplot(212)
plot(kgrid, kgrid)
hold on
plot(kgrid, gk, '*')
title ( ' the decision rule ' )
saveas(gcf,'optimal2.png')
