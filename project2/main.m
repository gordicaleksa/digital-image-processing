% main program for generating the spanish-castle-like illusion

%% cleans the workspace 
clear all;
close all;
clc;

%% main initialization logic 

% sRGB color system parameters

% R (red) component
x=0.64;
y = 0.33;
Xr = x/y; Yr = 1; Zr = (1-x-y)/y;
% G (green) component
x = 0.3;
y = 0.6;
Xg = x/y; Yg = 1; Zg = (1-x-y)/y;
% B (blue) component
x = 0.15;
y = 0.06;
Xb = x/y; Yb = 1; Zb = (1-x-y)/y;
% W (white) point
x=0.3127;
y=0.329;
Xw = x/y; Yw = 1; Zw = (1-x-y)/y;
% group the data into a structure
primaries = struct ('R',[Xr Yr Zr],'G',[Xg Yg Zg],'B',[Xb Yb Zb]);
white = [Xw Yw Zw];
% parameters for the gamma transformation
tf_params = struct('t',0.003138,'f',0.055,'gamma',1/2.4,'s',12.92);

% CODE STARTS HERE:

% CHANGE THIS:
input_img = 'example_input/parrots.jpg';
output_img_gray = 'example_output/gray.jpg';
output_img_neg = 'example_output/neg.jpg';

% load the input image
Irgb = imread(input_img);
% convert to double and scale to [0,1] range
Irgb = im2double(Irgb);

figure(200); imshow(Irgb); title('Original sRGB image');

%% demonstration of using the dos_rgb2ycbcr function

Iycbcr = dos_rgb2ycbcr(Irgb);
Y = Iycbcr(:,:,1);  % [0,1]
Cb = Iycbcr(:,:,2); % [-0.5,0.5]
Cr = Iycbcr(:,:,3); % [-0.5,0.5]
figure(1);
imshow(Y); 
figure(2);
imshow(Cb,[]); colormap(gca, 'jet');  
figure(3);
imshow(Cr,[]); colormap(gca,'jet');

%% demonstration of using the dos_rgb2lab function

Ilab = dos_rgb2lab(Irgb,primaries,white,tf_params);
L = Ilab(:,:,1); % [0,100]
a = Ilab(:,:,2);
b = Ilab(:,:,3);
figure(4)
imshow(L,[]);
figure(5)
imshow(a,[]); colormap(gca, 'jet');  
figure(6)
imshow(b,[]); colormap(gca, 'jet');  

%% demonstration of using the dos_rgb2xyz function

Ixyz = dos_rgb2xyz(Irgb,primaries,white,tf_params);
X = Ixyz(:,:,1);
Y = Ixyz(:,:,2);
Z = Ixyz(:,:,3);
figure(7)
imshow(X,[]); colormap(gca, 'jet');
figure(8)
imshow(Y,[]); colormap(gca, 'jet');
figure(9)
imshow(Z,[]); colormap(gca, 'jet');

%% reverse transform - demonstration of using the dos_lab2rgb function

I_rgb = dos_lab2rgb(Ilab,primaries,white,tf_params);
R = I_rgb(:,:,1);
G = I_rgb(:,:,2);
B = I_rgb(:,:,3);
figure(10)
imshow(R); colormap('jet');
figure(11)
imshow(G); colormap('jet');
figure(12)
imshow(B); colormap('jet');
figure(300)
imshow(I_rgb);

%% using the create_illusion function - YCbCr color system

[gray,negative] = create_illusion(Irgb,'ycbcr');
figure(13)
imshow(gray)
figure(14);
imshow(negative);
imwrite(gray,output_img_gray);
imwrite(negative,output_img_neg);

%% using the create_illusion function - HSV color system

[gray,negative] = create_illusion(Irgb,'hsv');
figure(15)
imshow(gray)
figure(16);
imshow(negative);
imwrite(gray,output_img_gray);
imwrite(negative,output_img_neg);

%% using the create_illusion function - Lab color system

[gray,negative] = create_illusion(Irgb,'lab');
figure(17)
imshow(gray)
figure(18);
imshow(negative);
imwrite(gray,output_img_gray);
imwrite(negative,output_img_neg);



