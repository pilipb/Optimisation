p=2;

q = p;
% p men and p women
mFeature=rand(p,1);
fFeature=rand(p,1);
c = mFeature-fFeature';

Xs=rand(p,1); Ys=rand(p,1);
Xd=rand(q,1); Yd=rand(q,1);
%% compute a cost matrix
XXs=repmat(Xs,1,q); YYs=repmat(Ys,1,q);
XXd=repmat(Xd',p,1); YYd=repmat(Yd',p,1);

%% Matrix set-up - some important tricks here.
pq=p*q;
I=[1:q]'; K=[1:pq]';
[KK,II]=meshgrid(K,I);
tmp=KK-(II-1)*p;
Amarkets = double((tmp>=1)&(tmp<=p));
bmarkets = fFeature;
% Amarkets*x = bmarkets is an equality
% constraint - as no point in oversupplying markets
J=[1:p]'; K=[1:pq]';
[KK,JJ]=meshgrid(K,J);
Afactories= double(mod(KK-1,p)+1 == J);
bfactories=mFeature;
% NB Afactories*x <= bfactories is an inequality constraint


%% Solve operation
%X = intlinprog(f,intcon,A,b,Aeq,beq,LB,UB)
[x,fval]=linprog(c(:),p,Afactories,bfactories,Amarkets,bmarkets,zeros(pq,1));
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
% figure;
plot(Xs,Ys,'r*'); hold on % positions of factories as red stars
plot(Xd,Yd,'g*');         % positions of markets as green stars
axis equal; axis([0 1 0 1]);

for i = 1:p
    for ii = 1:q
        if X(i,ii) == 0
            continue
        end
        plot([XXs(i,ii); XXd(i,ii)],[YYs(i,ii); YYd(i,ii)],'k-', LineWidth=5*X(i,ii));
    end
end


% plot([XXs(X>0)'; XXd(X>0)'],[YYs(X>0)'; YYd(X>0)'],'k-',LineWidth=X);
% As you can see, the nearby factories and markets tend to be joined up -
% as you would expect.
% For Bonus marks - work out how to make the edgewidths represent the
% weight in each flow.
%%


