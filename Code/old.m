close all;
clc;

I = imread('Photos/whiteboard.jpg');
% I = imresize('removed.png',0.8);
I = imsharpen(I);
I_grey = rgb2gray(I);
imshow(I);
title('Original Image');

% % gx = [-1,-2,-1;0,0,0;1,2,1];
% % ans = gx(1,3)
% % gy = [-1,0,1;-2,0,2;-1,0,1];≤¬
% [Gx,Gy] = imgradientxy(I_grey);
% G = abs(Gx) + abs(Gy);
% % imshow(G)
%%
clc;
% Compute line equations
% The Hough transform returns line equations of the form
%   cos(theta)*x + sin(theta)*y = rho
% We first sort the lines according to angle. Since the document is 
% approximately rectangular, this groups the lines into parallel
% lines
% [Gx,Gy] = imgradientxy(I_grey);
% G = abs(Gx) + abs(Gy);
BW = edge(I_grey,'canny');
[H,T,R] = hough(BW);
[Width,Height] = size(BW);
P  = houghpeaks(H,4,'threshold',0);
theta = T(P(:,2));
rho = R(P(:,1));
lines = houghlines(G,T,R,P,'FillGap',min(Width,Height)/5,'MinLength',min(Width,Height)/5);
figure, imshow(I); hold on
l = length(lines)
yo = zeros(2,2);
colors = ['b','r','g','y'];
for k = 1:l
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',colors(k));
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
points = zeros(4,2);
angles = zeros(2,2);

    angles(1,:) = [cosd(lines(1).theta), sind(lines(1).theta)];
    angles(2,:) = [cosd(lines(3).theta), sind(lines(3).theta)];
    b = [lines(1).rho, lines(3).rho]';
    c = angles\b;
    points(1,:) = c;
    
    angles(1,:) = [cosd(lines(2).theta), sind(lines(2).theta)];
    angles(2,:) = [cosd(lines(3).theta), sind(lines(3).theta)];
    b = [lines(2).rho, lines(3).rho]';
    c = angles\b;
    points(4,:) = c;
    
    angles(1,:) = [cosd(lines(1).theta), sind(lines(1).theta)];
    angles(2,:) = [cosd(lines(4).theta), sind(lines(4).theta)];
    b = [lines(1).rho, lines(4).rho]';
    c = angles\b;
    points(2,:) = c;
    
    angles(1,:) = [cosd(lines(2).theta), sind(lines(2).theta)];
    angles(2,:) = [cosd(lines(4).theta), sind(lines(4).theta)];
    b = [lines(2).rho, lines(4).rho]';
    c = angles\b;
    points(3,:) = c;
    
Pdash = ginput(4)'
% Pdash = points'

xmin = min(Pdash(1,:))+15;
ymin = min(Pdash(2,:))+15;
xmax = max(Pdash(1,:))-15;
ymax = max(Pdash(2,:))-15;
cr = [xmin,ymin,xmax-xmin,ymax-ymin];
cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];

% X = [min(Pdash(1,:)), min(Pdash(2,:));
%      max(Pdash(1,:)), min(Pdash(2,:));
%      max(Pdash(1,:)), max(Pdash(2,:)); 
%      min(Pdash(1,:)), max(Pdash(2,:))]';

H1 = homography(Pdash, cr_points');
whiteboard_persp = homwarp(H1, I);
I_perspective_resized = imresize(whiteboard_persp,size(BW));
[I_cropped,rect] = imcrop(I_perspective_resized,cr);
% imwrite(I_cropped,'img1-cropped.jpg','jpg');

subplot(2,2,1);
imshow(I);
title('Original Image');
subplot(2,2,2);
imshow(I); hold on
title('Edge detection');
l = length(lines)
yo = zeros(2,2);
colors = ['b','r','g','y'];
for k = 1:l
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','yellow');
    poi = cr_points(k,:);
    plot(poi(1,1),poi(1,2),'*','LineWidth',2,'Color',colors(k));
end

subplot(2,2,3);
imshow(I_perspective_resized);
hold on;

for k = 1:4
    % Plot beginnings and ends of lines
    poi = cr_points(k,:);
    plot(poi(1,1),poi(1,2),'x','LineWidth',2,'Color','red');
end
title('Perspective transformed');
subplot(2,2,4);
imshow(I_cropped);
title('Cropped whiteboard')