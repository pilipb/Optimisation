
% define function
fun = @(x) x(1).^3 + 2*x(2).^2 + x(3).^4 - x(1);

% linear equality constraint
% z = 0.5

% A_eq = [0,0,1];
% 
% b_eq = 0.5;
% 
% % linear inequality constraint
% % x + y >= 1
% % -x - y <= -1
% 
% A = [-1,-1,0];
% b = -1;

% starting  value
x0 = [2,100,0.5];

% [x, fval] = fmincon(fun,x0,A,b,A_eq,b_eq)



nonlcon = @spherecon;

[x, fval, exitflag, output, lambda, grad, hessian] = fmincon(fun,x0,[],[],[],[],[],[],nonlcon)

% non linear constraint
function [c,ceq] = spherecon(x)
c = x(1)^2 + x(2)^2 + x(3)^2 - 1;
ceq = [];
end 
