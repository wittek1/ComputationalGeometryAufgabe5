function [circleX, circleY, circleR] = findMaxCircle(polygon)

minX = min(polygon(:,1));
maxX = max(polygon(:,1));
minY = min(polygon(:,2));
maxY = max(polygon(:,2));
maxR = max(maxX - minX, maxY - minY) / 2;
minR = maxR * (-1);


% x = optimvar('x', 'LowerBound', minX, 'UpperBound', maxX);
% y = optimvar('y', 'LowerBound', minY, 'UpperBound', maxY);
% r = optimvar('r', 'LowerBound', minR, 'UpperBound', maxR);

% x = optimvar('x', 'LowerBound', -Inf, 'UpperBound', Inf);
% y = optimvar('y', 'LowerBound', -Inf, 'UpperBound', Inf);
% r = optimvar('r', 'LowerBound', -Inf, 'UpperBound', Inf);

x = optimvar('x', 'LowerBound', -500);
y = optimvar('y', 'LowerBound', -420);
r = optimvar('r', 'LowerBound', 0);

prob = optimproblem('Objective', r, 'ObjectiveSense', 'max');

[rowCount, columnCount] = size(polygon);

constraintIndex = 1;

for index = 1:rowCount - 1
    % Coordinates of start point
    startX = polygon(index, 1);
    startY = polygon(index, 2);
    
    % Coordinates of end point
    endX = polygon(index + 1, 1);
    endY = polygon(index + 1, 2);
    
    % Calculate the line equation
    slope = (endY - startY) / (endX - startX);
    yIntercept = startY - slope * startX;
    
    mulFactor = 1 / sqrt(slope^2 + 1);
    
    if startX ~= endX
        if startX > endX
            disp("Top edge:")
            mulFactor = mulFactor * (-1);
        else
            disp("Bottom edge:")
        end

        prob.Constraints.(strcat('c', num2str(constraintIndex))) = mulFactor * (-y + slope * x + yIntercept) >= r;

    else
        disp("Vertical edge:")
        if startY < endY
            prob.Constraints.(strcat('c', num2str(constraintIndex))) = startX + r <= x;
        elseif startY > endY
            prob.Constraints.(strcat('c', num2str(constraintIndex))) = startX - r >= x;
        else
            error('Not a line!')
        end
    end
    
    fprintf("y = %d * x + %d\n", slope, yIntercept);
    constraintIndex = constraintIndex + 1;
end

problem = prob2struct(prob);

[sol, fval, exitflag, output] = linprog(problem);

circleX = sol(2);
circleY = sol(3);
circleR = sol(1);

fprintf("(x - %d)^2 + (y - %d)^2 = %d^2", circleX, circleY, circleR)

end
