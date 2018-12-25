function b = detectchange(I1,I2)
Size = size(I1);
BW1 = edge(rgb2gray(I1),'Sobel');
BW2 = edge(rgb2gray(I2),'Sobel');
% figure;
% imshow(BW1);
% figure;
% imshow(BW2);
booll = imabsdiff(BW1,BW2);
booll=uint8(255 * booll);
%booll=medfilt2(booll,[3 3])
booll=imgaussfilt(booll, 4);
%booll=BW2-BW1;
% figure;
% imshow(booll);
s=sum(abs(booll(:)))/(255*Size(1)*Size(2));
disp(s);
if(s<0.01)
    b=false;
else
    b=true;
end
end