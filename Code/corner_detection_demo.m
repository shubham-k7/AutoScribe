clear all;
close all;
clc;
I = imread('Photos/demo0.jpg');
I = imsharpen(I);
I_grey = rgb2gray(I);
imshow(I);
title('Original Image');
%%
clc;
% We Compute line equations
% The Hough transform returns line equations of the form
%   cos(theta)*x + sin(theta)*y = rho
% We first sort the lines according to angle. Since the whiteboard is 
% approximately rectangular, this groups the lines into parallel
% lines

% [Gx,Gy] = imgradientxy(I_grey);
% G = abs(Gx) + abs(Gy);
BW = edge(I_grey);
[H,T,R] = hough(BW);
[Width,Height] = size(BW);
P  = houghpeaks(H,4,'threshold',0);
theta = T(P(:,2));
rho = R(P(:,1));

if (length(theta) < 4)
    fprintf('Could not find all lines\n');
    return;
end

% % Display detected lines
% figure;
% % subplot(1,2,1);
% % imagesc(I(:,:,2));
% imshow(I);
% shading flat; hold on; colormap gray; axis equal;
% for i = 1:length(theta)
%     t = theta(i) / 180 * pi;
%     r = rho(i);
%     if (abs(t) > pi/4)
%         u = 0:size(I_grey,2);
%         v = 1 + (r - u*cos(t) )/ sin(t);    
%     else
%         v = 0:size(I_grey,1);
%         u = 1 + (r - sin(t)*v) / cos(t);
%     end
%     plot(u,v,'g-','LineWidth',2);
% end
figure;
[~,order] = sort(abs(theta));
coefficients = [cos(theta' / 180 * pi), sin(theta' / 180 * pi), -rho'];
L1 = coefficients(order(1),:); % start with smallest angle
L2 = coefficients(order(2),:); % parallel to L1
L3 = coefficients(order(3),:); % perpendicular to L1 and L2
L4 = coefficients(order(4),:); % parallel to L3

% Compute p1, p2, p3, p4 as intersections of L1,...,L4;
% see above figure.
p = zeros(4,3); 
p(1,:) = cross(L1,L3); % p1
p(2,:) = cross(L2,L3); % p2
p(3,:) = cross(L2,L4); % p3
p(4,:) = cross(L1,L4); % p4
p = p(:,1:2) ./ [p(:,3), p(:,3)];

pq = p;
% We now need to reorder the points such that they correspond to 
% the physical document vertices

% Sort points into clockwise order (see above figure)
v = p(2,:) - p(1,:); 
w = p(3,:) - p(1,:);
a = (v(1)*w(2) - w(1)*v(2)) / 2; % signed area of triangle (p1,p2,p3)
if (a < 0)
    p = p(end:-1:1,:); % reverse vertex order
end

% Make sure that first vertex p1 lies either topmost or leftmost,
% and lies at the start of a short side
edgeLen = [
    norm(p(1,:) - p(2,:));
    norm(p(2,:) - p(3,:));
    norm(p(3,:) - p(4,:));
    norm(p(4,:) - p(1,:))
    ];
sortedEdgeLen = sort(edgeLen);
startsShortEdge = (edgeLen' <= sortedEdgeLen(2)); % flag which ones are at a short edge
% find the one that is closest to top left corner of image
idx = find(startsShortEdge,2);
if (norm(p(idx(1),:)) < norm(p(idx(2),:)))
    p1Idx = idx(1);
else
    p1Idx = idx(2);
end
order = mod(p1Idx - 1 : p1Idx + 2, 4) + 1; % reorder to start at right vertex
p = p(order,:);
p = p';
p = circshift(p,-1,2);
pd = p';
% Diplay vertex order
for i = 1:4
    text(pd(i,1),pd(i,2),sprintf('%d',i),'BackgroundColor','white');
end

% xmin = min(p(1,:))+5;
% ymin = min(p(2,:))+5;
% xmax = max(p(1,:))-5;
% ymax = max(p(2,:))-5;
% cr = [xmin,ymin,xmax-xmin,ymax-ymin];
% cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];
% 
% H1 = homography(p, cr_points');
% whiteboard_persp = homwarp(H1, I);
% I_perspective_resized = imresize(whiteboard_persp,size(BW));
% [I_cropped,rect] = imcrop(I_perspective_resized,cr);
[I_cropped,rect,cr_points] = perps_correction(I,BW,p);
% imwrite(I_cropped,'img1-cropped.jpg','jpg');

subplot(2,2,1);
imshow(I);
title('Original Image');
subplot(2,2,2);
imshow(I); hold on
title('Edge detection');
for i = 1:length(theta)
    t = theta(i) / 180 * pi;
    r = rho(i);
    if (abs(t) > pi/4)
        u = 0:size(I_grey,2);
        v = 1 + (r - u*cos(t) )/ sin(t);    
    else
        v = 0:size(I_grey,1);
        u = 1 + (r - sin(t)*v) / cos(t);
    end
    plot(u,v,'g-','LineWidth',2);
end

subplot(2,2,3);
% imshow(I_perspective_resized);
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