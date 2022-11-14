%% transportation problem solution
% We assume randomTransportationProblem has been run for p factories 
% and q markets and a p-vector s of supplies, q-vector d of demands, 
% and a pxq matrix of costs C, have been set up - along with some
% other coordinate variables used later on.
% There pxq decision variables (the flows), p factory constraints,
% q market constraints, and pxq non-negativity constraints.
% Let xij be the flow from factory i to market j.
% Let the state variable be
% (x11,x21,...,xp1,x12,x22,...,xp2,... ...,x1q,x2q,...,xpq)'
% which is how matlab would unravel the matrix 
% X={xij} as a vector if you just did X(:).
% A sum over all factories for the first market 1 involves a row
% of coefficients like
% (1 1 ... 1, 0,...0)
% with p 1s in that first block. For the second market, the block of 1s
% moves along by p places, and so on.
% A sum over all markets for the first factory 1 involves a row of coeffs
% like (1 0...0, 1 0...0, ..., 1 0...0)
% with q repeating blocks of p elements. The position of the 1 moves
% along as we move to the second factory etc.
% The required matrix constraints can be built by loops - but below is one
% shorthand way of doing it.
%% Matrix set-up - some important tricks here.
pq=p*q;
I=[1:q]'; K=[1:pq]';
[KK,II]=meshgrid(K,I);
tmp=KK-(II-1)*p;
Amarkets = double((tmp>=1)&(tmp<=p));
bmarkets = d;
% Amarkets*x = bmarkets is an equality
% constraint - as no point in oversupplying markets
J=[1:p]'; K=[1:pq]';
[KK,JJ]=meshgrid(K,J);
Afactories= double(mod(KK-1,p)+1 == J);
bfactories=s;
% NB Afactories*x <= bfactories is an inequality constraint
%% Solve operation
%X = linprog(f,A,b,Aeq,beq,LB,UB)
[x,fval]=linprog(C(:),Afactories,bfactories,Amarkets,bmarkets,zeros(pq,1),[]);
X=reshape(x,p,q); 
% which shows the structure in the flows that are used - note that in
% general only a small subset of the total possible flows are needed.
% QUESTION - how does the number of non-zero flows relate to p and q? -
% EXPERIMENT.
%% Graphical interpretation - just this needs fixing.
% In fact, each factory and market was put at a specific location, and
% the cost was defined to be the distance between them.
% So, I'll plot the factories and markets in the plane, and straight lines
% joining them for the used flows.
figure;
plot(Xs,Ys,'r*'); hold on % positions of factories as red stars
plot(Xd,Yd,'g*');         % positions of markets as green stars
axis equal; axis([0 1 0 1]);

for i = 1:p
    for ii = 1:q
        if X(i,ii) == 0
            continue
        end
        plot([XXs(i,ii); XXd(i,ii)],[YYs(i,ii); YYd(i,ii)],'k-', LineWidth=20*X(i,ii));
    end
end

legend('Factories', 'Markets','Supply Routes',Location='best');

% plot([XXs(X>0)'; XXd(X>0)'],[YYs(X>0)'; YYd(X>0)'],'k-',LineWidth=X);
% As you can see, the nearby factories and markets tend to be joined up -
% as you would expect.
% For Bonus marks - work out how to make the edgewidths represent the
% weight in each flow.
%%

