function enhanced = segenhance(I)
I = rgb2gray(I);
I=adapthisteq(I);
I2 = graythresh(I);
BW = imbinarize(I,I2);
enhanced=BW;
end