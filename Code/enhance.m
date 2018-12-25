function enhanced = enhance(I)
%I=imsharpen(I);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
%R = adapthisteq(R);
%G = adapthisteq(G);
%B = adapthisteq(B);
R = medfilt2(R);
G = medfilt2(G);
B = medfilt2(B);
%R = imadjust(R,stretchlim(R),[]);
%G = imadjust(G,stretchlim(G),[]);
%B = imadjust(B,stretchlim(B),[]);
I=cat(3,R,G,B);
I=imsharpen(I);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
nR=R;
nG=G;
nB=B;
lumm=B;
num=0;
dim = size(I);
bsize=10;
for x =1:bsize:618
    for y=1:bsize:892
        max=0.2126*R(y,x)+0.7152*G(y,x)+0.0722*B(y,x);
        maxi=x;
        maxj=y;
        for i=x:(x+bsize-1)
            if(i>618)
                break;
            end
            for j=y:(y+bsize-1)
                if(j>892)
                    break;
                end
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
            if(i>618)
                break;
            end
            for j=y:(y+bsize-1)
                if(j>892)
                    break;
                end
                nR(j,i)=255;
                nG(j,i)=255;
                nB(j,i)=255;
                nR(j,i)=nR(j,i)*min(1,R(j,i)/R(maxj,maxi));
                nG(j,i)=nG(j,i)*min(1,G(j,i)/G(maxj,maxi));
                nB(j,i)=nB(j,i)*min(1,B(j,i)/B(maxj,maxi));
                nR(j,i)=255*(0.5-0.5*cos(power(double(nR(j,i)/255),0.75)*pi));
                nG(j,i)=255*(0.5-0.5*cos(power(double(nG(j,i)/255),0.75)*pi));
                nB(j,i)=255*(0.5-0.5*cos(power(double(nB(j,i)/255),0.75)*pi));
                lumm(j,i)=0.2126*R(maxj,maxi)+0.7152*G(maxj,maxi)+0.0722*B(maxj,maxi);
            end
        end
    end
end
RGB1=cat(3,nR,nG,nB);
h = ones(4,4)/16;
RGB2 = imfilter(RGB1,h);
RGB2=imsharpen(RGB2);
RBG2=imadjust(RGB2, [], [], 5);
%figure;
% imshow(RGB2);
enhanced=RGB2;
end
