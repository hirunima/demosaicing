clear;
close all;
monoI = imread('images_for_demosaicing/kodim19.tiff');
[h,w]=size(monoI);
J1=zeros(h,w,3,'uint8');
J2=zeros(h,w,3,'uint8');
J3=zeros(h,w,3,'uint8');
J4=zeros(h,w,3,'uint8');
%gbrg
J1(1:2:end,1:2:end,2)=monoI(1:2:end,1:2:end); %green
J1(2:2:end,2:2:end,2)=monoI(2:2:end,2:2:end); %green
J1(1:2:end,2:2:end,3)=monoI(1:2:end,2:2:end); %blue
J1(2:2:end,1:2:end,1)=monoI(2:2:end,1:2:end); %red
%grbg
J2(1:2:end,1:2:end,2)=monoI(1:2:end,1:2:end);
J2(2:2:end,2:2:end,2)=monoI(2:2:end,2:2:end);
J2(1:2:end,2:2:end,1)=monoI(1:2:end,2:2:end);
J2(2:2:end,1:2:end,3)=monoI(2:2:end,1:2:end);
%bggr
J3(1:2:end,2:2:end,2)=monoI(1:2:end,2:2:end);
J3(2:2:end,1:2:end,2)=monoI(2:2:end,1:2:end);
J3(1:2:end,1:2:end,3)=monoI(1:2:end,1:2:end);
J3(2:2:end,2:2:end,1)=monoI(2:2:end,2:2:end);
%rggb
J4(1:2:end,2:2:end,2)=monoI(1:2:end,2:2:end);
J4(2:2:end,1:2:end,2)=monoI(2:2:end,1:2:end);
J4(1:2:end,1:2:end,1)=monoI(1:2:end,1:2:end);
J4(2:2:end,2:2:end,3)=monoI(2:2:end,2:2:end);

J1r = demosaic(monoI,'gbrg');

J2r = demosaic(monoI,'grbg');
J3r = demosaic(monoI,'bggr');
J4r = demosaic(monoI,'rggb');
figure(1)
imshow(J1);
figure(2)
imshow(J2);
figure(3)
imshow(J3);
figure(4)
imshow(J4);

X=double(J2);
r=3;
b=1;
%g=[0,1,0;1,0,1;0,1,0];
for i=2:h-1
    for j=2:w-1
        if mod(i,2)==0
            if mod(j,2)==0
            X(i,j,b)=0.5*(X(i-1,j,b)+X(i+1,j,b)); %green for blue plane even  
            X(i,j,r)=0.5*(X(i,j-1,r)+X(i,j+1,r)); %green for red plane even               
            else
            X(i,j,2)=0.25*(X(i,j-1,2)+X(i,j+1,2)+X(i+1,j,2)+X(i-1,j,2)); %red for green plane 
            X(i,j,b)=0.25*(X(i-1,j-1,b)+X(i-1,j+1,b)+X(i+1,j-1,b)+X(i+1,j+1,b)); %red for blue plane 
            end
        else
            if mod(j,2)==0
            X(i,j,2)=0.25*(X(i,j-1,2)+X(i,j+1,2)+X(i+1,j,2)+X(i-1,j,2)); %blue for green plane     
            X(i,j,r)=0.25*(X(i-1,j-1,r)+X(i-1,j+1,r)+X(i+1,j-1,r)+X(i+1,j+1,r)); %blue for red plane    
            else
            X(i,j,r)=0.5*(X(i-1,j,r)+X(i+1,j,r)); %green for red plane odd  
            X(i,j,b)=0.5*(X(i,j-1,b)+X(i,j+1,b)); %green for blue plane odd      
            end
        
        end
        
    end
end
X=uint8(X);
x=X(1:10,1:10,:);
figure(5)
imshow(X);
figure(6)
imshow(J2r);
peaksnr=psnr(X,J2r)