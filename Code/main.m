% This code is where the main pipeline is combined
clc;
clear all;
close all;
source_dir = 'Photos/*.jpg'; 
ids = imageDatastore(source_dir);
numImgs = numel(ids.Files);

% Get clean blackboard picture
I_base = read(ids);

[I_cropped, I_cropped_size, corners] = corner_detection(I_base);

xmin = min(corners(1,:))+5;
ymin = min(corners(2,:))+5;
xmax = max(corners(1,:))-5;
ymax = max(corners(2,:))-5;
cr = [xmin,ymin,xmax-xmin,ymax-ymin];
cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];

while hasdata(ids)
    img = read(ids) ;             % read image from datastore
    
    figure, imshow(img);    % creates a new window for each image
end

subplot(2,1,1);
imshow(I_base);

subplot(2,1,2);
imshow(I_cropped);