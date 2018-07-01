function [ Igray, Icolor_neg ] = create_illusion( Irgb, color_proc )
% CREATE_ILLUSION creates a simple optical illusion
%
% detailed explanation:
%
%   Function takes as an input a 3-D RGB image, where each channel contains
%   gamma-corrected doubles in the range [0,1] and outputs 2 images a
%   grayscale one and one with inverted colors.
%
%   If you stare about 30 seconds into the color picture and then if you 
%   look at the grayscale it will appear to be correctly colored.
%
% Input:
%
%               rgb_img - RGB image, double format, range = [0,1]
%               color_proc - choose a color system for processing the illusion
%               options: 'lab', 'ycbcr', 'hsv' 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = imread('example.jpg');
% [gray,negative] = create_illusion(rgb_img,'lab');
% figure(1);
% imshow(negative);
% figure(2);
% imshow(gray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 7.11.2016 (Aleksa Gordic)

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

% list of possible options
a = 'ycbcr';
b = 'hsv';
c = 'lab';

% convert input to lowercase
color_proc = lower(color_proc);

if (strcmp(a,color_proc))
    Iycbcr = dos_rgb2ycbcr(Irgb);
    % Igray equals the luma matrix
    Igray = Iycbcr(:,:,1); 
    Cb =  Iycbcr(:,:,2);
    Cr =  Iycbcr(:,:,3);
    % convert back to RGB and we get a negative
    Iycbcr(:,:,1) = mean(Igray(:)); Iycbcr(:,:,2) = -Cb; Iycbcr(:,:,3) = -Cr;
    Icolor_neg = dos_ycbcr2rgb(Iycbcr);
elseif (strcmp(b,color_proc))
    Ihsv = rgb2hsv(Irgb);
    H = Ihsv(:,:,1);
    S = Ihsv(:,:,2);
    Igray = Ihsv(:,:,3);
   
    % invert the hue component
    I1 = H>=0.5;
    I2 = H<0.5;
    a = H(I1);
    a = a-0.5;
    b = H(I2);
    b = b+0.5;
    H(I1) = a;
    H(I2) = b;
    % convert back to RGB and we get a negative
    Ihsv(:,:,1) = H; Ihsv(:,:,2) = S; Ihsv(:,:,3) = mean(Igray(:));
    Icolor_neg = hsv2rgb(Ihsv);
elseif(strcmp(c,color_proc))
    Ilab = dos_rgb2lab(Irgb,primaries,white,tf_params);
    L = Ilab(:,:,1);
    a = Ilab(:,:,2);
    b = Ilab(:,:,3);
    % create Igray
    Igray = L/100;
    % convert back to RGB and we get a negative
    Ilab(:,:,1) = mean(L(:)); Ilab(:,:,2) = -a; Ilab(:,:,3) = -b;
    Icolor_neg = dos_lab2rgb(Ilab,primaries,white,tf_params);       
else
    disp('Error: wrong option, possible options are = {"hsv","lab","ycbcr"}');
    O = zeros(size(Irgb,1),size(Irgb,2));
    % init all of the matrices to zero
    Igray = O;
    Icolor_neg(:,:,1)= O;
    Icolor_neg(:,:,2)=O;
    Icolor_neg(:,:,3)=O;
end     
    
end

