I = imread('trial.jpg');
J = I;
%imadjust(I,[.2 .3 0; .6 .7 1],[]);
J = imadjust(I,[0.3 0.6],[]);
J=imadjust(I, [], [], 2);
figure
imshow(J)
figure;
imshow(I);
%{
I = imread('sample.jpeg');
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
nR=R;
nG=G;
nB=B;
lumm=B;
num=0;
bsize=15;
for x =1:bsize:1920
    for y=1:bsize:1080
        max=0.2126*R(y,x)+0.7152*G(y,x)+0.0722*B(y,x);
        maxi=x;
        maxj=y;
        for i=x:(x+bsize-1)
            for j=y:(y+bsize-1)
                lum=0.2126*R(j,i)+0.7152*G(j,i)+0.0722*B(j,i);
                lumm(j,i)=lum;
                if(lum>max)
                    max=lum;
                    maxi=i;
                    maxj=j;
                end
            end
        end
        for i=x:(x+bsize-1)
            for j=y:(y+bsize-1)
                nR(j,i)=255;
                nG(j,i)=255;
                nB(j,i)=255;
                nR(j,i)=nR(j,i)*min(1,R(j,i)/R(maxj,maxi));
                nG(j,i)=nG(j,i)*min(1,G(j,i)/G(maxj,maxi));
                nB(j,i)=nB(j,i)*min(1,B(j,i)/B(maxj,maxi));
                %lumm(j,i)=0.2126*R(maxj,maxi)+0.7152*G(maxj,maxi)+0.0722*B(maxj,maxi);
            end
        end
    end
end
BW = imbinarize(lumm,0.5);
for i =1:1920
    for j=1:1080
        if BW(j,i)==0
            nR(j,i)=R(j,i);
            nG(j,i)=G(j,i);
            nB(j,i)=B(j,i);
        end
    end
end
figure;
RGB1=cat(3,nR,nG,nB);
imshow(BW);
figure;
imshow(RGB1);
%}
