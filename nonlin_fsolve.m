%% Using fsolve, fmincon

% x = fmincon(fun, x0, A, b, ... ,)
% fun is a function or inline function with @

% example

fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;

x0 = [-1,2];
A = [1,2];
b = 1;
x = fmincon(fun,x0,A,b)

%% example 2

x0 = [0.5,0];
A = [1,2];
b = 1;
Aeq = [2,1];
beq = 1;
x = fmincon(fun,x0,A,b,Aeq,beq)

%% bound constraints:

fun = @(x)1+x(1)/(1+x(2)) - 3*x(1)*x(2) + x(2)*(1+x(1));

lb = [0,0];
ub = [1,2];

A = [];
b = [];
Aeq = [];
beq = [];

x0 = (lb + ub)/2;

x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub)


