%% Quad Prog Problem

% set up

syms x_1 x_2
f = 0.5*x_1^2 + x_2^2 - x_1*x_2 - 2*x_1 - 6*x_2;
H = double(hessian(f,[x_1,x_2]));


% subject to constraints 
%     x_1 + x_2  <= 2
%     -x_1 + 2*x_2 <= 2
%     2*x_1 + x_2 <= 3 

A = [1 1; -1 2; 2 1]; % coefficients 
b = [2; 2; 3];


f_obj = [-2;-6] % read the linear coefficients

x = quadprog(H, f_obj, A, b)