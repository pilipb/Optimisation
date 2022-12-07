function [x, fval] = homemade_swarm(fun, num_iter,swarm_size,lb,ub)


% give each particle a random position in the within the bounds
X_i =(rand(2,swarm_size)*ub*2)-ub;

% give each particle a random velocity
V_i = randn(2,swarm_size)*0.1;

% plot points with velocities
hold on;
scatter(X_i(1,:),X_i(2,:),'k*');
quiver(X_i(1,:),X_i(2,:),V_i(1,:),V_i(2,:),LineWidth=0.5,Color='black');
title("Initial");
hold off;

% Set coefficients
c1 = 1;
c2 = 1;
r = rand(1,2);
V_1 = zeros(2,swarm_size); 


for iter = 1:num_iter
    for i = 1:swarm_size
        % update the best values
        [pbest, pbest_val, gbest , gbest_val] = calc_bests(X_i,fun); %function found at bottom of doc
        % w as GLbestIW as described in section 4a
        w = 1.1 - (gbest_val./pbest_val(i));
        % velocities update 
        V_1(:,i) = w.*V_i(:,i) + c1.*r(1).*(pbest(:,i) - X_i(:,i)) + c2.*r(2).*(gbest - X_i(:,i));

        % location update
        X_i(:,i) = X_i(:,i) + V_1(:,i);

        % I have added this line to stop the particles escaping during the
        % optimisation, if the new coordinate is out of bounds the velocity
        % is reversed.
        if X_i(1,i) > ub || X_i(1,i) < lb ||  X_i(2,i) > ub || X_i(2,i) < lb
            X_i(:,i) = X_i(:,i) -  V_1(:,i);
        end 
    end
end

% final error
fval = gbest_val;
x = gbest;

function [pbest, pbest_val, gbest , gbest_val] = calc_bests(X_i,fun)
% calculate global and local bests
    pbest = X_i;
    for i = 1:length(X_i)
        pbest_val(i) = fun(X_i(1,i),X_i(2,i));
    end
    [gbest_val, idx] = min(pbest_val);
    [gbest] = pbest(:,idx);
end
end


