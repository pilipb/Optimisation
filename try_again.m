clear, clc

c = readmatrix("ProblemRankData.csv");


[students, groups] = size(c);
total = students*groups;

f = reshape(c,1,total);

% Make A matrices:

% A for one student can only do one project

% [110000
%  001100
%  000011] etc

A_circ = zeros(1, total);
A_circ(1:groups) = 1;

A1 = A_circ;
for i = 1:students-1
    A_new = circshift(A_circ, i*groups);
    A1 = [A1; A_new];
end

% b for one student can only do one project

b1 = ones(1, students);

% A for max and min group size
minGroup = 3;
maxGroup = 5;

A2 = eye(groups);
A2 = repmat(A2, 1, students);
A3 = A2;

% b for max and min group size
b2_min = minGroup * ones(1,groups);
b3_max = maxGroup * ones(1,groups);

% intcon
intcon = ones(students,1);

% bounds
lb = zeros(total, 1);
ub = ones(total, 1);

% Arranging for intlinprog

A = [-A2;A3];
b = [ -b2_min'; b3_max'];

A_eq = A1;
b_eq = b1;


% objective = minimise the sum of x * c
% constraints 

% A*x <= b
% -A*x <= -b
% A*x >= b



[x, fval] = intlinprog(f, intcon, A, b, A_eq, b_eq,lb, ub);
X = reshape(x,students,groups);

% check total assignments
sum(sum(X))

group_totals = [];
for i = 1:groups
    group_totals(i) = sum(X(:,i));
end
close all
figure
bar(groups, group_totals)








