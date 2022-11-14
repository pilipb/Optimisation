clear, clc

c = readmatrix("ProblemRankData.csv");


[students, groups] = size(c)
total = students*groups;

f = reshape(c',[],1);

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
minGroup = 4;
maxGroup = 6;

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

A = [A2;-A3];
b = [ b3_max'; -b2_min'];

A_eq = A1;
b_eq = b1';


% objective = minimise the sum of x * c
% constraints 

% A*x <= b
% -A*x <= -b
% A*x >= b



[x, fval] = intlinprog(f, intcon, A, b, A_eq, b_eq,lb, ub)
solutions = reshape(x, groups,students)'

C = c;
plotSolutions(solutions, C, minGroup, maxGroup)
groups = assignNames(solutions, groups);

%% Andre code for plot:
function groupings = assignNames(solutions, numGroups)
groupings = struct;
for col = 1:numGroups
    students = find(solutions(:,col))
    groupings.(['group' num2str(col)]) = students;
end
end

%% Graphical checks
function plotSolutions(solutions, C, minSize, maxSize)

numGroups = width(C);
realSolutions = solutions .* C;
labels = {'1st Choice', '2nd Choice', '3rd Choice', '4th Choice', ...
    '5th Choice'};
worstChoice = max(max(realSolutions));

close all
figure()

xLabels = {};
plottingData = [];
for i = 1: numGroups
    xLabels{i} = ['Group ' num2str(i)];
    scores = zeros(1, worstChoice);

    for j = 1:worstChoice

        scores(1, j) = sum(realSolutions(:, i)==j);
    end
    plottingData = [plottingData; scores];
end

X = categorical(xLabels);
X = reordercats(X,xLabels);
bar(X, plottingData, 'stacked')
title(['Group sizes: ' num2str(minSize) ' to ' num2str(maxSize)])
ylabel('Number of students per group')
legend(labels{1:worstChoice}, 'location', 'bestoutside')

end







