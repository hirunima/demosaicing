clear;
close all;
sigma=1;
I=imread('pout.tif');
I=double(I);

h_width=3*sigma-1;
[h,w]=size(I);
[x,y]=meshgrid(-h_width:h_width,-h_width:h_width);
kernel=(1/(2*pi*sigma^2))*exp(-((x.*x)+(y.*y))/(2*sigma^2));
I_smooth=zeros(h,w);
for i=1:h-2*h_width
    for j=1:w-2*h_width
        I_smooth(i+h_width,j+h_width)=sum(sum(I(i:i+2*h_width,j:j+2*h_width).*kernel));
    end
end

detail=I-I_smooth;
sharp=I+5*detail;

figure(1)
imshow(uint8(I));
figure(2)
imshow(uint8(I_smooth));
figure(3)
imshow(uint8(2.5*detail));
figure(4)
imshow(uint8(sharp));

x_1=[-h_width:h_width];
y_1=[-h_width:h_width];
kernel_x=(1/(sqrt(2*pi)*sigma))*exp(-((x_1.*x_1))/(2*sigma^2));
kernel_y=(1/(sqrt(2*pi)*sigma))*exp(-((y_1.*y_1))/(2*sigma^2));
I_smooth_1=zeros(h,w);
for i=1:h  % x kernel
    for j=1:w-2*h_width
        I_smooth_1(i,j+h_width)=sum(I(i,j:j+2*h_width).*kernel_x);
    end
end
I_smooth_2=zeros(h,w);
for i=1:h-2*h_width   % y kernel
    for j=1:w-h_width
        I_smooth_2(i+h_width,j)=sum(I_smooth_1(i:i+2*h_width,j).*kernel_y');
    end
end
figure(5)
imshow(uint8(I_smooth_2));

error=sum(sum((I_smooth_2-I_smooth).^2));
diff=I_smooth_2-I_smooth;