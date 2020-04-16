%EvaluatePath
%Author: Geoff Hollinger, 2015
%Determines the information and cost of a path

%Inputs: 
%X ordered list of 2D waypoints (N rows and 2 columns)
%Z NxN matrix of information values (indexed as (X(1),X(2)))

%Outputs:
%info - information gathered along path
%cost - length of path
function [info,cost] = evaluatePath(XY,map)

%starts at zero
cost = 0;  % changed from -1
info = 0;
for i = 1:size(XY,1)
    info = info + findInformation(XY(i,1),XY(i,2),map);
    if(i > 1)  % starts calculating past cost at 2nd step
        step = sqrt((XY(i,1)-XY(i-1,1))^2+(XY(i,2)-XY(i-1,2))^2);
        if step > eps  % if we've moved a non-zero amount
            cost = cost + step;  
        else
            cost = cost + 1;  % standing still costs 1
        end
    end
end

end