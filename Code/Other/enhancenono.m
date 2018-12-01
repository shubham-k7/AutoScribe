I = imread('trial.jpeg');
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
nR=R;
nG=G;
nB=B;
lumm=B;
num=0;
pointlist={};
for x =1:15:1920
    for y=1:15:1080
        max=0.2126*R(y,x)+0.7152*G(y,x)+0.0722*B(y,x);
        maxi=x;
        maxj=y;
        for i=x:(x+14)
            for j=y:(y+14)
                lum=0.2126*R(j,i)+0.7152*G(j,i)+0.0722*B(j,i);
                if(lum>max)
                    max=lum;
                    maxi=i;
                    maxj=j;
                end
            end
        end
        for i=x:(x+14)
            for j=y:(y+14)
                nR(j,i)=R(maxj,maxi);
                nG(j,i)=G(maxj,maxi);
                nB(j,i)=B(maxj,maxi);
                lumm(j,i)=0.2126*R(maxj,maxi)+0.7152*G(maxj,maxi)+0.0722*B(maxj,maxi);
            end
        end
        %=[R(maxj,maxi) G(maxj,maxi) B(maxj,maxi)];
    end
end
figure;
RGB1=cat(3,nR,nG,nB);
imshow(RGB1);
