
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

[circleX, circleY, circleR] = findMaxCircle(polygon);

figure(1)
plot(polygon(:,1), polygon(:,2));
plotCircle(circleX, circleY, circleR);