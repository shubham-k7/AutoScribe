% This code is where the main pipeline is combined
close all;
clear all;
clc;
source_dir = '../Demo_2/*.png'; 
ids = imageDatastore(source_dir);
numImgs = numel(ids.Files);

% Get clean blackboard picture

% I_base = read(ids);
% 
% [I_cropped_base, I_cropped_size_base, ~, ~] = corner_detection(I_base);
% 
% imshow(I_cropped_base);

I_base_2 = read(ids);

[I_cropped_2, I_cropped_size, corners, BW] = corner_detection(I_base_2);
xmin = min(corners(1,:))+5;
ymin = min(corners(2,:))+5;
xmax = max(corners(1,:))-5;
ymax = max(corners(2,:))-5;
cr = [xmin,ymin,xmax-xmin,ymax-ymin];
cr_points = [xmin,ymin;xmax,ymin;xmax,ymax;xmin,ymax];

last_clean_snap = I_cropped_2;
prev_appended = I_cropped_2;

[nrows ncols dim] = size(I_cropped_2);
% Get the slices colums wise split equally
I_c1 = I_cropped_2(:,1:ncols/3,:);
I_c2 = I_cropped_2(:,(ncols/3)+1:2*ncols/3,:);
I_c3 = I_cropped_2(:,(2*ncols/3)+1:ncols,:);

prev_appended_c1 = I_c1;
prev_appended_c2 = I_c2;
prev_appended_c3 = I_c3;

% imshow(I_c1);
imwrite(I_c1,'myGray.png');
I_c1=imread('myGray.png');
I_en1 = edgeenhance(I_c1);
% figure, imshow(I_en1);

i = 1;
name = strcat(int2str(i),'.jpg');
name = strcat('../Output_en2/',name);
imwrite(I_en1,name,'jpg');
i = i+1;

imwrite(I_c2,'myGray.png');
I_c2=imread('myGray.png');
I_en2 = edgeenhance(I_c2);

name = strcat(int2str(i),'.jpg');
name = strcat('../Output_en2/',name);
imwrite(I_en2,name,'jpg');

% imwrite(I_c1, '../TEST/1.jpg');
% imwrite(I_c2, '../TEST/2.jpg');
% imwrite(I_c3, '../TEST/3.jpg');
c = 3;
while hasdata(ids)
    % read next image from datastore
    c = c+1;
    I_next = read(ids);
    
    % Perform persp correction
    H1 = homography(corners, cr_points');
    whiteboard_persp = homwarp(H1, I_next);
    I_perspective_resized = imresize(whiteboard_persp,size(BW));
    [I_cropped_new,rsize] = imcrop(I_perspective_resized,cr);
    
    % Detecting professor
%     if(detectperson(I_cropped_new, I_cropped_2))
%         I_cropped_new = removeperson(I_cropped_new, last_clean_snap);
%     else
%         last_clean_snap_c1 = I_cropped_new;
%     end
    
    % Divide new image into 3 sections
    [nrows ncols dim] = size(I_cropped_new);
    % Get the slices colums wise split equally
    I_c1 = I_cropped_new(:,1:ncols/3,:);
    I_c2 = I_cropped_new(:,(ncols/3)+1:2*ncols/3,:);
    I_c3 = I_cropped_new(:,(2*ncols/3)+1:ncols,:);
    
%     figure, imshow(I_c1);
%     figure, imshow(I_c2);
%     figure, imshow(I_c3);
%     temp = strcat(int2str(c),'.jpg');
%     temp = strcat('../TEST/',temp);
%     imwrite(I_c1,temp,'jpg');
%     c = c+1;
%     temp = strcat(int2str(c),'.jpg');
%     temp = strcat('../TEST/',temp);
%     imwrite(I_c2,temp,'jpg');
%     c = c+1;
%     temp = strcat(int2str(c),'.jpg');
%     temp = strcat('../TEST/',temp);
%     imwrite(I_c3,temp,'jpg');
    
    if(detectchange(I_c1,prev_appended_c1)==true)
        name = strcat(int2str(i+1),'.jpg');
        name = strcat('../Output_en2/',name);
        disp("Appending New section 1..");
        imwrite(I_c1,'myGray.png');
        I_c1=imread('myGray.png');
        I_en = edgeenhance(I_c1);
        disp(i);
        imwrite(I_en,name,'jpg');
        i = i + 1;
        prev_appended_c1 = I_c1;
    else
%         disp("No change");
        prev_appended_c1 = I_c1;
    end
    
    if(detectchange(I_c2,prev_appended_c2)==true)        
        name = strcat(int2str(i+1),'.jpg'); 
        name = strcat('../Output_en2/',name);
        imwrite(I_c2,'myGray.png');
        I_c2=imread('myGray.png');
        I_en = edgeenhance(I_c2);
        disp("Appending New section 2..");
        disp(i);
        imwrite(I_en,name,'jpg');
        i = i + 1;
       
        prev_appended_c2 = I_c2;
    else
%         disp("No change");
        prev_appended_c2 = I_c2;
    end
    
    if(detectchange(I_c3,prev_appended_c3)==true)
        name = strcat(int2str(i+1),'.jpg'); 
        name = strcat('../Output_en2/',name);
        imwrite(I_c3,'myGray.png');
        I_c3=imread('myGray.png');
        I_en = edgeenhance(I_c3);
        disp("Appending New section 3..");
        disp(i);
        imwrite(I_en,name,'jpg');
        i = i + 1;
        prev_appended_c3 = I_c3;
    else
%         disp("No change");
        prev_appended_c3 = I_c3;
    end
%     figure, imshow(I_cropped_new);
end