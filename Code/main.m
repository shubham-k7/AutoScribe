% This code is where the main pipeline is combined
clc;
clear all;
close all;
source_dir = 'Photos/*.jpg'; 
ids = imageDatastore(source_dir);
numImgs = numel(ids.Files);

% Get clean blackboard picture
I_base = read(ids);

[I_cropped, I_cropped_size, points] = rectify_image(I_base);
% while hasdata(ids)
%     img = read(ids) ;             % read image from datastore
%     figure, imshow(img);    % creates a new window for each image
% end
% [I_cropped,I_cropped_size] = rectify_image(I);

subplot(2,1,1);
imshow(I_base);

subplot(2,1,2);
imshow(I_cropped);