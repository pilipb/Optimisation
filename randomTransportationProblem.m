%% Build random transportation problem data
p=10; % num factories
q=9; % num markets
totalSupply=1;
totalDemand=1;
% Experiment with these bits
%% set up demands and supplies
s=rand(p,1);
s=totalSupply*s/sum(s);
d=rand(q,1);
d=totalDemand*d/sum(d);
%% set up coords of supplies and demands
Xs=rand(p,1); Ys=rand(p,1);
Xd=rand(q,1); Yd=rand(q,1);
%% compute a cost matrix
XXs=repmat(Xs,1,q); YYs=repmat(Ys,1,q);
XXd=repmat(Xd',p,1); YYd=repmat(Yd',p,1);
C=((XXs-XXd).^2 + (YYs-YYd).^2).^0.5;  % cost matrix
% do you see what I am trying to do here?