function[x,V]=KirchofffSolve(st,r,listAnode,listCnode)
% function[x,V]=KirchoffSolve(st,r,listAnode,listCnode)
% We need to generate a dummy anode and cathode (two extra nodes),
% and extra edges, with zero resistance, that connect them to the
% nodes in listAnode and listCathode.
% This will be done by operating on the st and r data.
numNode = max(max(st));
numEdge = size(st,1);
% the total number of nodes including the anode and cathode nodes
dummyAnode = numNode+1;
dummyCnode = numNode+2;
% the index of the dummy anode and cathodes
numNewNode = numNode+2;
% the number of nodes including the dummies
st = [st; ...
      dummyAnode*ones(length(listAnode),1) listAnode;...
      listCnode dummyCnode*ones(length(listCnode),1)];
% add the edges from the dummy anode to the anode nodes
% resp. from the cathode nodes to the dummy cathode.
numNewEdge = size(st,1);
% the number of edges including the dummies
r = [r; zeros(length(listAnode),1); zeros(length(listCnode),1)];
% dummy edges have zero resistance - add them to the list
s=spalloc(numNewNode,1,2);
s(dummyAnode)=-1;
s(dummyCnode)=+1;
% construct the right hand source vector - zero except at dummy anode
% and cathode - NB use sparse matrices!!
H=spdiags(r,0,numNewEdge,numNewEdge);
% construct the Hermitian, use sparse matrix
B = spalloc(numNewNode,numNewEdge,2*numEdge);
for i=1:numNewEdge
    B(st(i,1),i)=-1;  % start node
    B(st(i,2),i)=+1;  % terminal node
end
% construct the B matrix - best to use sparse formulation, for large probs
% NB this loop can be optimised if you are very clever
options=optimoptions('quadprog','Algorithm','interior-point-convex',...
    'Diagnostics','on','Display','iter-detailed','LinearSolver','sparse');
%'OptimalityTolerance',1e-18,...
%'StepTolerance',1e-16...
% useful options for quadprog
[x,fval,exitflag,output,options]=...
    quadprog(H,zeros(numNewEdge,1),[],[],B,s,[],[],[],options);
% call quadprog - x are the edge flows and fval is energy dissipated
potentialDrop = r.*x;
% potential dropped across each edge for this solution for currents - 
G=digraph(st(:,1),st(:,2),potentialDrop);
% set these as edge weights for a directed graph
V=distances(G,dummyAnode)';
% computes the shortest path distances (actually distance is path indpt)
% from dummy Anode to every other node.
x=x(1:numEdge);
V=V(1:numNode);
% trim the currents and flows to eliminate the dummies
end
