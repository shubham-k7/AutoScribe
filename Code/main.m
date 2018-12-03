% This code is where the main pipeline is combined
clc;
close all;
clear all;
source_dir = '../Demo/*.png'; 
ids = imageDatastore(source_dir);
numImgs = numel(ids.Files);

% Get clean blackboard picture
I_base = read(ids);

[I_cropped_base, I_cropped_size_base, ~, ~] = corner_detection(I_base);

imshow(I_cropped_base);
I_base_2 = read(ids);

[I_cropped_2, I_cropped_size, corners, BW] = corner_detection(I_base_2);
xmin = min(corners(1,:))+5;
ymin = min(corners(2,:))+5;
xmax = max(corners(1,:))-5;
ymax = max(corners(2,:))-5;
cr = [xmin,ymin,xmax-xmin,ymax-ymin];
cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];

figure, imshow(I_cropped_2);

last_clean_snap = I_cropped_2;
prev_appended = I_cropped_2;

[nrows ncols dim] = size(I_cropped_2);
% Get the slices colums wise split equally
I_c1 = I_cropped_2(:,1:ncols/3,:);
I_c2 = I_cropped_2(:,(ncols/3)+1:2*ncols/3,:);
I_c3 = I_cropped_2(:,(2*ncols/3)+1:ncols,:);


imshow(I_c1);
imwrite(I_c1,'myGray.png');
I_c1=imread('myGray.png');
I_en1 = enhance(I_c1);
figure, imshow(I_en1);

i = 1;
name = strcat(int2str(i),'.jpg');
imwrite(I_cropped_2,name,'jpg');

while hasdata(ids)
    % read next image from datastore
    I_next = read(ids);
    
    % Perform persp correction
    H1 = homography(corners, cr_points');
    whiteboard_persp = homwarp(H1, I_next);
    I_perspective_resized = imresize(whiteboard_persp,size(BW));
    [I_cropped_new,rsize] = imcrop(I_perspective_resized,cr);
    
    % Detecting professor
    if(detectperson(I_cropped_new, I_cropped_2))
        I_cropped_new = removeperson(I_cropped_new, last_clean_snap);
    else
        last_clean_snap = I_cropped_new;
    end
    
    if(detectchange(I_cropped_new,prev_appended))
        name = strcat(int2str(i+1),'.jpg');    
        I_en = enchance(I_cropped_new)
        imwrite(I_cropped_new,name,'jpg');
        i = i + 1;
        prev_appended = I_cropped_new;
    else
        disp("No change");
    end
%     figure, imshow(I_cropped_new);
end