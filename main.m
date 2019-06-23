
clear all;
close all;
clc

polygon = load('polygon.txt');

polygonX = polygon(:,1);
polygonY = polygon(:,2);

[circleX, circleY, circleR] = findMaxCircle(polygon)


figure(1)
plot(polygonX, polygonY, 'o');
plotCircle(circleX, circleY, circleR);