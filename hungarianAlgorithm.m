
%% Generate problem:
% n x n square matrix of non-negative weights for a problem size n

n = 4;

% e.g. workers and jobs
% n jobs and n workers
workCost=randi([1 100],n);

   
%% Cover all zeros with minimum number of lines

subMat = subtraction(workCost)

M1 = subMat;
[x,y] = find(M1 == 0);
locations = [x,y];

[M4, M2] = minNumLinesMat(M1, n);

numberLines = numLines(M4, n);

%% Loop over subraction testing number of lines

%     First, we find that the smallest uncovered number is 6. 
%     We subtract this number from all uncovered elements and add
%     it to all elements that are covered twice. This results in
%     the following matrix:

while(numberLines < n)
    small = min(min(M1(M1>0)));
    M1 = M1 - small;

%    elements covered twice have their column and row total = n
    M5 = zeros(n);
    for row = 1:length(M4)
        if(sum(M4(row,:)) == n)
            for col = 1:length(M4)
                if(sum(M4(:,col)) == n)
                    M5(row,col)=+1;
                end
            end
        end
    end

    M1 = M1 + (3*small*M5);


    [x,y] = find(M1 == 0);
    locations = [x,y];
    [M4, M2] = minNumLinesMat(M1, n);
    numberLines = numLines(M4, n);
end

%% Iterate through rows and columns and check if only a single zero
% is present. It it is, it has to be the solution. If not continue.

M1
SolMat = zeros(n);

for row = 1:length(M1)
    for col = 1:length(M1)
        if((M1(row,col)==0 && ((sum(M1(row,:)=0)) ==1))
            SolMat(row,col)=1;
            M1(row,:)= M1(row,:)+1;
            M1(:,col)= M1(:,col)+1;
        end

    end
end

% currently only works by finding the first zero in each row and selecting
% that for the column

    
    %% for each row subtract row minima:

function subMat = subtraction(workCostMat)

% we start with subtracting the row minimum from each row

    rowMins = (min(workCostMat'))';
    workCost2 = workCostMat - rowMins;
    
%     subract column minima:
    
    colMins = min(workCost2);
    subMat = workCost2 - colMins;

end




%% function calculates how many lines have been used

function numLines = numLines(M4, n)
    rowCount = 0;
    colCount = 0;
    numLines = 0;
    for row = 1:length(M4)
        if(sum(M4(row,:)) == n)
            rowCount= rowCount+1;
        end
    end
    rowCount;
    for col = 1:length(M4)
        if(sum(M4(:,col)) == n)
            colCount= colCount+1;
        end
    end
    colCount;
    numLines = rowCount + colCount
end

%%  function covers all zeros with minimum number of lines

function [M4,M2] = minNumLinesMat(M1, n)
    
    M2 = zeros(n);
    M3 = zeros(n);
    M4 = zeros(n);
    M1x = M1;

    while any(M1x(:) == 0)
    
        M2(M1x>0) = -1;
        
    M2 = M2+1;

        for col = 1:length(M2)
        colSum = sum(M2(:,col));
        for row = 1:length(M2)
            rowSum = sum(M2(row,:));
    
            if(colSum >= rowSum)
                M3(row,col) = colSum;
            else
                M3(row,col) = -rowSum;
            end
        end
        end
        maxRow = max(-M3,[],2);
        maxCol = max(M3,[],1);
    
        [m1,iy] = max(maxRow);
        [m2,ix] = max(maxCol);
    
        if(m1>=m2)
            M4(iy,:)=+1;
        elseif(m2>m1)
            M4(:,ix)=+1;
        end
        M1x = M1x + M4;
    end
end















