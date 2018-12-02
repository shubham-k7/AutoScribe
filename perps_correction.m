function [I_cropped,rect,cr_points] = perps_correction(I,BW,points)
xmin = min(points(1,:))+5;
ymin = min(points(2,:))+5;
xmax = max(points(1,:))-5;
ymax = max(points(2,:))-5;
cr = [xmin,ymin,xmax-xmin,ymax-ymin];
cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];

H1 = homography(points, cr_points');
whiteboard_persp = homwarp(H1, I);
I_perspective_resized = imresize(whiteboard_persp,size(BW));
[I_cropped,rect] = imcrop(I_perspective_resized,cr);
end