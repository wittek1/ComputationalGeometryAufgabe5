
clear all;
close all;
clc

polygon = load('polygon.txt');

% Check if the polygon is closed
[rowCount, columnCount] = size(polygon);

firstPoint = polygon(1, :);
lastPoint = polygon(rowCount, :);

if ~isequal(firstPoint, lastPoint)
    polygon(rowCount + 1, :) = firstPoint;
end

% Check if the polygon is in cw orientation
sum = 0;
for index = 1:rowCount - 1
    % Coordinates of start point
    startX = polygon(index, 1);
    startY = polygon(index, 2);
    
    % Coordinates of end point
    endX = polygon(index + 1, 1);
    endY = polygon(index + 1, 2);
    
    sum = sum + (startX * endY - endX * startY);
end

if sign(sum) == 1
    disp('polygon in ccw')
    polygon = flipud(polygon);
elseif sign(sum) == -1
    disp('polygon in cw')
else
    error('Not a polygon!')
end
    
% find biggest inner circle
[circleX, circleY, circleR] = findMaxCircle(polygon);

figure(1)
plot(polygon(:,1), polygon(:,2));
plotCircle(circleX, circleY, circleR);