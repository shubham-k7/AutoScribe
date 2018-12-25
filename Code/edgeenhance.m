function enhanced = edgeenhance(I)
I = rgb2gray(I);
BW1 = edge(I,'Sobel');
%imshow(imcomplement(BW1));
enhanced=imcomplement(BW1);
end