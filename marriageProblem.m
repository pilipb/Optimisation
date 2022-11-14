%% Random marriage problem

p=4;
% p men and p women
mFeature=(rand(p,1));
fFeature=rand(p,1);
c = abs(mFeature-fFeature');

% test matrix
% c = [0.5, 0.5, 0, 0;
%      0.8, 0.8, 1, 0;
%      1, 1, 0, 0;
%      0.8,0.8,0,0]

%% Matrix set-up

I=[1:p]'; K=[1:p^2]';
[KK,II]=meshgrid(K,I);
tmp=KK-(II-1)*p;

J=[1:p]'; K=[1:p^2]';
[KK,JJ]=meshgrid(K,J);

mSupply = double(mod(KK-1,p)+1 == J);
ASupply = mSupply;
bSupply = ones(1,p);

wDemand = double((tmp>=1)&(tmp<=p));
ADemand = wDemand;
bDemand = ones(1,p);

%% Using intlinprog

% [x,fval]=linprog(C(:),Afactories,bfactories,Amarkets,bmarkets,zeros(pq,1),[]);

[x, FVAL] = intlinprog(c,[1,1,1],ASupply, bSupply, ADemand ,bDemand, zeros(p^2,1));
X=reshape(x,p,p)

%% Compare to matchpairs

x_pairs = matchpairs(c,1000)

%% Compare to hungrian algorithm??


