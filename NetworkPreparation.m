%% Clear the workspace, set input parameters
clear; close all; more off
numACNode = 6; 
% number of Anodes (and Cathodes) at x=0 and x=1 resp.
numNode = 500; 
% number of nodes in interior of unit square

%% Position the nodes
x = sort(0.1 + 0.8*rand(numNode,1));
y = 0.1 + 0.8*rand(numNode,1);

% interior nodes well inside the unit square, sorted by x for tidiness
x = [zeros(numACNode,1); x; ones(numACNode,1)];
y = [linspace(0,1,numACNode)'; y; linspace(0,1,numACNode)'];
% add on the anodes and cathodes

%% Define some edges
DT=delaunayTriangulation(x,y);
% Delaunay triangulations give nice pictures...
st=DT.edges;
listAnode=[1:numACNode]'; listCnode=numACNode+numNode+[1:numACNode]';

% if both of the nodes are in the ACnode list, get rid of them
tmp=(st<=numACNode)|(st>=numACNode+numNode+1);
st(find(tmp(:,1).*tmp(:,2)),:)=[];
%inds = find(st(:,1)==1 | st(:,1)==numACNode | st(:,2)==numACNode+numNode+1 | st(:,2)==numNode+2*numACNode)
%st(inds,:)=[];
% NB routine auto orders these s,t pairs so that s<t, as in my notes

%% Set some edge weights or resistances
r = (sqrt(x(st(:,2)-st(:,1)).^2 + y(st(:,2)-st(:,1)).^2)).^4;
% example: resistances just lengths of edges.

%% Call the solver
% [x,V]=KirchoffSolve(st,r,listAnode,listCnode)
% The total source current assumed WLOG equals 1.
% st is the n x 2 list of edges defined by start and terminal nodes.
% r is the n x 1 list of resistances
% listAnode and listCnode: column vectors listing these nodes.
% x resulting edge currents, V resulting node voltages.
[X,V]=KirchoffSolve(st,r,listAnode,listCnode);

% that's that
Vdrop = V(listCnode(1))-V(listAnode(1));
% and this is just the resistance, as the current is prescribed to be 1.
% NB the problem is linear in voltages.


%% Plot what it looks like
figure; 
hp=plot(x(st)',y(st)','r-');
axis equal
axis([-0.1 1.1 -0.1 1.1])
for i=1:length(hp)
   hp(i).LineWidth = max(1e-3,3*abs(X(i))/(max(abs(X)))); 
end
% unfortunately this formulation gives short cuts from the anode to
% the cathode along y=0 and y=1: not ideal for illustration, but never mind
%%
hold on
for i=1:max(max(st)) % ie over nodes
  hr(i)=rectangle('Position',[x(i)-0.005,y(i)-0.005,0.01,0.01],'Curvature',[1 1],'FaceColor',[0 1 0]*(V(i)-min(V))/(max(V)-min(V)));
end
%%
