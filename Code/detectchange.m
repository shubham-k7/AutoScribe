function b = detectchange(I1,I2)
Size = size(I1);
BW1 = edge(rgb2gray(I1),'Sobel');
BW2 = edge(rgb2gray(I2),'Sobel');
figure;
imshow(BW1);
figure;
imshow(BW2);
booll=BW2-BW1;
figure;
imshow(booll);
s=sum(abs(booll(:)))/(Size(1)*Size(2));
disp(s);
if(s<0.01)
    b=true;
else
    b=false;
end
end