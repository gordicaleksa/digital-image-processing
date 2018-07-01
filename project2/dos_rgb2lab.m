function [ lab ] = dos_rgb2lab( Irgb, primaries, white, tf_params )
%DOS_RGB2LAB convert RGB image to a Lab image
%
% Input:
%               Irgb - RGB image, double format, range = [0,1]
%               primaries - coordinates of R,G and B primary colors in X,Y,Z   
%               white - coordinates of white color in X,Y,Z
%               tf_params - parameters of a gamma correction function       
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = imread('example.jpg');
% lab_img = dos_rgb2lab(rgb_img,primaries,white,tf_params);
% L = lab_img(:,:,1); % extract the luma component
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 6.11.2016 (Aleksa Gordic)

% convert to XYZ color space
Ixyz = dos_rgb2xyz(Irgb, primaries, white, tf_params);

X = Ixyz(:,:,1);
Y = Ixyz(:,:,2);
Z = Ixyz(:,:,3);
Xw = white(1);
Yw = white(2);
Zw = white(3);

% convert from XYZ to Lab
% function h(x) is defined in h.m
L = 116*(h(Y/Yw))-16;
a = 500*(h(X/Xw) - h(Y/Yw));
b = 200*(h(Y/Yw) - h(Z/Zw));

% saturation arithmetic
L(L>100) = 100;
L(L<0) = 0;

% pack into a 3-D matrix
lab(:,:,1) = L;
lab(:,:,2) = a;
lab(:,:,3) = b;

end

