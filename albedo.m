close all;
clear;
J=[];
M=12;
%light sources
fileID = fopen('resources_for_shape_and_albedo/lights.txt','r');
l = textscan(fileID, '%f %f %f', 'HeaderLines', 1, 'Delimiter', ' ');
fclose(fileID);
s_u = [l{1} l{2} l{3}];

%read the data
for i=1:M
    [I,Map] = tga_read_image(strcat('resources_for_shape_and_albedo/rock/rock.',int2str(i-1),'.tga'));
    image = rgb2gray(I);
    image=im2double(image);
    I_scale=imresize(image,0.3);    %scale the image |w|=0.3
    [h,w]=size(I_scale);
    I_small=reshape(I_scale,1,h*w);
    J=[J;I_small];                  %compute the J matrix
end
%singular value decomposition
[U,D,V] = svd(J);
D_3=D(1:3,1:3);         %compute the D_3-maximum 3 eigen values
f_u=U(:,1:3);           %compute f(u) first 3 colums of Left singular vectors
e_x=V(:,1:3);           %compute e(x) first 3 colums of Right singular vectors
%solve for b(x)
Q_3=f_u\s_u;            %compute Q_3 from s(u)=Q_3*f(u)
P_3=Q_3\D_3;            %compute P_3 from D_3=P_3'*Q_3
b_x=e_x*P_3;            %compute b(x) from b(x)=P_3*e(x) here b(x)=a(x)n(x)

step=1;
i=reshape(b_x(:,1),h,w);  %extract the ith components of n(x)
j=reshape(b_x(:,2),h,w);  %extract the jth components of n(x)
k=reshape(b_x(:,3),h,w);  %extract the kth components of n(x)
[X, Y] = meshgrid(1:step:w, 1:step:h);

figure(1);
quiver3(X, Y, zeros(size(X)), i,j,k); %draw the n(x){normals}
view([0, 270]);
axis off;
axis equal;
drawnow;

%find the albedo
alb=sqrt(sum(b_x.^2,2));        %calculate the a(x) from a(x)=|b(x)|
albedo_single=reshape(alb,h,w);

figure(2)
imshow(albedo_single)

