function [ Irgb ] = dos_lab2rgb( Ilab, primaries, white, tf_params )
%DOS_LAB2RGB convert Lab image to a RGB image
%
% Input:
%               Ilab - Lab image, double format
%               primaries - coordinates of R,G and B primary colors in X,Y,Z   
%               white - coordinates of white color in X,Y,Z
%               tf_params - parameters of a gamma correction function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = dos_lab2rgb(lab_img,primaries,white,tf_params);
% R = rgb_img(:,:,1); % extract the red channel
% figure(1);
% imshow(R); % display the red channel as a grayscale image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 6.11.2016 (Aleksa Gordic)

L = double(Ilab(:,:,1));
a = double(Ilab(:,:,2));
b = double(Ilab(:,:,3));

Xw = white(1);
Yw = white(2);
Zw = white(3);

% convert from Lab to XYZ 
% h_inv defined in h_inv.m
Y = Yw*h_inv((L+16)/116);
X = Xw*h_inv(a/500 + (L+16)/116);
Z = Zw*h_inv(-b/200 +(L+16)/116);

Ixyz(:,:,1) = X;
Ixyz(:,:,2) = Y;
Ixyz(:,:,3) = Z;

% convert from XYZ to RGB
Irgb = dos_xyz2rgb(Ixyz, primaries, white, tf_params);

end

