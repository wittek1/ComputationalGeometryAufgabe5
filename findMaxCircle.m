function [circleX, circleY, circleR] = findMaxCircle(polygon)

minX = min(polygon(:,1));
maxX = max(polygon(:,1));
minY = min(polygon(:,2));
maxY = max(polygon(:,2));
maxR = max(maxX - minX, maxY - minY) / 2;
minR = 0;

x = optimvar('x', 'LowerBound', minX, 'UpperBound', maxX);
y = optimvar('y', 'LowerBound', minY, 'UpperBound', maxY);
r = optimvar('r', 'LowerBound', minR, 'UpperBound', maxR);

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
    
    p = [startX startY];
    %q = [endX endY];
    n = [- (endY - startY); endX - startX];
    n = n/norm(n);
    
    a = dot(n, p);

    prob.Constraints.(strcat('c', num2str(constraintIndex))) = n(1) * x + n(2) * y - r >= a;
    constraintIndex = constraintIndex + 1;
end

problem = prob2struct(prob);

[sol, fval, exitflag, output] = linprog(problem);

circleX = sol(2);
circleY = sol(3);
circleR = sol(1);

end
