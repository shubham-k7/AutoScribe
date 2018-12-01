function removed = removeperson(I1,I2)
%name = 'trial';
%ext='.jpg';
%n=1;
%I1 = imread('img1.jpg');
%I2 = imread('img2.jpg');
J=rgb2gray(I1)-rgb2gray(I2);
J = medfilt2(J,[30 30]);
h = ones(6,6)/36;
J= imfilter(J,h);
Sub=I2;
%figure
%imshow(I1)
for x =1:1920
    for y=1:1080
        Pix=J(y,x);
        %Sub(y,x)=0;
        if(Pix(1)~=0)
            for d=1:3
                Sub(y,x,d)=I1(y,x,d);
            end
        end
    end
end
figure
%imshow(I2)
figure
%imshow(Sub)
%imwrite(Sub,'removed.png')
removed=Sub;
end
