function [circleX, circleY, circleR] = findMaxCircle(polygon)

polygon = load('polygon.txt');

[rowCount, ] = size(polygon);
indexConstrain = 1;

for index = 1:rowCount - 1
    % Coordinates of starting point
    startX = polygon(index, 1);
    startY = polygon(index, 2);
    
    % Coordinates of ending point
    endX = polygon(index + 1, 1);
    endY = polygon(index + 1, 2);
    
    % Calculate the line equation
    % TODO: Handle Vertical lines
    coefficients = polyfit([startX, endX], [startY, endY], 1);
    slope = coefficients(1);
    yIntercept = coefficients(2);
    
    % Function should be:
    % (mulfactor * (y - jM*x) - R) * (-1) <= mulfactor * jN
    mulFactor = 1 / sqrt(slope^2 + 1);
    
    % Add an additional constrain with the same function but negated mulFactor
    % Constrain for bottom edges:
    if startX < endX
        disp("Top edge:")
        mulFactor = mulFactor * (-1);
    elseif startX > endX
       disp("Bottom edge:")
    else
        disp("Vertical edge")
    end
    
    % Show the linear equation of the line for which the constrain is created
    fprintf("y = %d * x + %d\n", slope, yIntercept);
    
    % Constrain for bottom edges:
    constrains(indexConstrain, 1) = slope * mulFactor;
    constrains(indexConstrain, 2) = mulFactor * (-1);
    constrains(indexConstrain, 3) = 1;
    constrainsMax(indexConstrain) = yIntercept * mulFactor;
    indexConstrain = indexConstrain + 1;
end

f = [0, 0, -1];
result = linprog(f,constrains,constrainsMax);

result = abs(result);
circleX = result(1);
circleY = result(2);
circleR = result(3);

end
