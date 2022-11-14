%% Build big random standard maximisation problems
m = 100;  % number of constraints
n = 100;   % number of dimensions.
% play with these parameters - make them bigger, in steps
%%
f = -rand(n,1); % set up a random objective function.
lambda=1; % a parameter which controls the A coefficients
mu = 1; % a parameter which controls the b coefficients
A=lambda*ones(m,n)+rand(m,n);
b=mu*ones(m,1)+rand(m,1);
%%
