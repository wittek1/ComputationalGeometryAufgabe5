function [circleX, circleY, circleR] = findMaxCircle(polygon)

[rowCount, columnCount] = size(polygon);

indexConstrain = 1;

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
    
    if startX < endX
        disp("Top edge:")
        
    elseif startX > endX
       disp("Bottom edge:")
       mulFactor = mulFactor * (-1);
    else
        disp("Vertical edge")
        fprintf("y = %d * x + %d\n", slope, yIntercept);
        continue
    end
    
    % Show the linear equation of the line for which the constrain is created
    fprintf("y = %d * x + %d\n", slope, yIntercept);
    
    % Constrain for edge:
    A(indexConstrain, 1) = slope * mulFactor;
    A(indexConstrain, 2) = mulFactor * (-1);
    A(indexConstrain, 3) = 1;
    b(indexConstrain) = yIntercept * mulFactor;
    indexConstrain = indexConstrain + 1;
end

minX = min(polygon(:,1));
maxX = max(polygon(:,1));
minY = min(polygon(:,2));
maxY = max(polygon(:,2));
minR = 0;
maxR = max(maxX - minX, maxY - minY) / 2;

% Constrain for possible vertical edge:
% TODO: Find correct constrains
A(indexConstrain, 1) = 1;
A(indexConstrain, 2) = 0;
A(indexConstrain, 3) = 1;
b(indexConstrain) = maxX;
indexConstrain = indexConstrain + 1;
A(indexConstrain, 1) = 1;
A(indexConstrain, 2) = 0;
A(indexConstrain, 3) = 1;
b(indexConstrain) = minX;
indexConstrain = indexConstrain + 1;

f = [0, 0, -1];
Aeq = [];
beq = [];
lb = [];
ub = [];

result = linprog(f,A,b,Aeq,beq,lb,ub);

circleX = result(1) * (-1);
circleY = result(2) * (-1);
circleR = result(3) * (-1);

fprintf("(x - %d)^2 + (y - %d)^2 = %d^2", circleX, circleY, circleR)

end
