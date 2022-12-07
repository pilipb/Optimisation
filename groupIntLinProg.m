%% Import random data
c = readmatrix("ProblemRankData.csv");

[students, groups] = size(c);
% p students and q groups

%% solving using transportation code



total=students*groups;
I=[1:students]'; K=[1:total]';
[KK,II]=meshgrid(K,I);
tmp=KK-(II-1)*students;

% One student can only do one project
ASupply = double((tmp>=1)&(tmp<=groups));
bSupply = ones(1,students);

J=[1:groups]'; K=[1:total]';
[KK,JJ]=meshgrid(K,J);

% Each project can have minGroup and a maxGroup size
minGroup = 1;
maxGroup = 10;
ADemand= double(mod(KK-1,students)+1 == J);
bMinGroup= minGroup*ones(1,groups);
bMaxGroup= maxGroup*ones(1,groups);

A = [ADemand; -ADemand];
b = [ -bMinGroup; bMaxGroup];

intcon = ones(students,1);

% equality: 
A_eq = ASupply;
b_eq = bSupply;

% bouns
lb = zeros(total,1);
ub = ones(total,1);

[x, Fval] = intlinprog(c,intcon,A,b,A_eq,b_eq,[],[])
% [x, FVAL] = intlinprog(c,intcon,A,b,[],[],[],ub);
X=reshape(x,students,groups)


%% visualising solution:

% for column in x find how many students in each group
% group_totals = [];
% for i = 1:groups
%     group_totals(i) = sum(X(i,:));
% end
% 
% group_totals
