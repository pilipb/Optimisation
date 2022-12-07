
clear; close all; more off; hold off
N_plot = [];
t_plot = [];
efRes = [];
counter = 1;
N = 4;
t = 0;
while t < 200
    [X,V,t,Vdrop] = Kirch_Run(N);
    N_plot(counter) = N;
    t_plot(counter) = t;
    efRes(counter) = Vdrop;
    counter=counter+1;
    N = N*2;
end




% line of best fit for time
g = fittype('a-b*exp(-c*x)');
f0 = fit(N_plot',t_plot',g,'StartPoint',[0 0 0]);
xx = linspace(1,max(N_plot),50);

xlabel("Dimension N")
yyaxis left
plot(N_plot,t_plot,'o','DisplayName','Time Values');
hold on
plot(xx,f0(xx),'-','DisplayName','Exponential line of Best Fit - Time');
ylabel("Time to Compute (s)")


yyaxis right
plot(N_plot,efRes,'o','DisplayName','Effective Resistance')
plot(N_plot,efRes,'-','DisplayName','Effective Resistance Line')

% coeffiecient of ln(N)
a = mean((efRes./(log(N_plot))));

plot(N_plot,a.*log(N_plot),'k--','DisplayName','a*ln(N) plot')
% plot(xFit,yFit,'-','DisplayName','Exponential line of Best Fit - Resistance');
xticks auto

ylabel("Effective Resistance (ohms)")


title("Time Complexity and Effective Resistance of Network")
legend('Location','bestoutside')

%% To just plot

% line of best fit for time
g = fittype('a-b*exp(-c*x)');
f0 = fit(NPLOT',TPLOT',g,'StartPoint',[0 0 0]);
xx = linspace(1,max(NPLOT),50);

xlabel("Dimension N")
yyaxis left
plot(NPLOT,TPLOT,'o','DisplayName','Time Values');
hold on
plot(xx,f0(xx),'-','DisplayName','Exponential line of Best Fit - Time');
ylabel("Time to Compute (s)")


yyaxis right
plot(NPLOT,RES,'o','DisplayName','Effective Resistance')
plot(NPLOT,RES,'-','DisplayName','Effective Resistance Line')

% coeffiecient of ln(N)
a = mean((RES./(log(NPLOT))));

plot(NPLOT,a.*log(NPLOT),'k--','DisplayName','a*ln(N) plot')
% plot(xFit,yFit,'-','DisplayName','Exponential line of Best Fit - Resistance');
xticks auto

ylabel("Effective Resistance (ohms)")


title("Time Complexity and Effective Resistance of Network")
legend('Location','bestoutside')




function[X,V,t, Vdrop] =  Kirch_Run(N)

grid = delsq(numgrid('S',N+2));
ngraph = graph(grid,'omitselfloops');
h = plot(ngraph,Visible="off");
h.XData = floor((0:N^2-1)/N);
h.YData = rem((0:N^2-1), N);


x = h.XData;
y = h.YData;

st = table2array(ngraph.Edges);
st(:,3) = [];

r = ones(length(st),1);

listAnode = [1];
listCnode = [N^2];

tic;
[X,V]=KirchoffSolve(st,r,listAnode,listCnode);
t = toc;

Vdrop = V(listCnode(1))-V(listAnode(1));

end
