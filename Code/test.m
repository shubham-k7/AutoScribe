clc;
I = imread('../Demo/vlcsnap-2018-12-02-21h13m19s489.png');

imshow(I);
[nrows ncols dim] = size(I);
% Get the slices colums wise split equally
img1 = I(:,1:ncols/3,:);
img2 = I(:,(ncols/3)+1:2*ncols/3,:);
img3 = I(:,(2*ncols/3)+1:ncols,:);
figure,
subplot(1,3,1), imshow(img1,[]); title('first part');
subplot(1,3,2), imshow(img2,[]); title('second part');
subplot(1,3,3), imshow(img3,[]); title('third part');

I_en = enhance(img1);
figure, imshow(I_en);