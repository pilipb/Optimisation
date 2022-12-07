function moveCount = CAtrafficFlowSimulator(rho,p,spaceSteps,timeSteps)
% function moveCount = CAtrafficFlowSimulator(rho,p,spaceSteps,timeSteps)
moveCount=0;
occupancy = (rand(spaceSteps,1)<rho);
for i=1:timeSteps
    inds=find(occupancy);
    inds=inds(randperm(length(inds)));
    for j=1:length(inds)
        thisCell = inds(j);
        nextCell = thisCell+1;
        if nextCell>spaceSteps
            nextCell=1;
        end
        if ~occupancy(nextCell)
            if rand<p
                occupancy(thisCell)=false;
                occupancy(nextCell)=true;
                moveCount = moveCount+1;
            end
        end
    end
end
end

