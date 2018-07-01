function [ ycbcr_img ] = dos_rgb2ycbcr( rgb_img )
% DOS_RGB2YCBCR converts RGB image to a Y'CbCr image
%
% detailed explanation: 
%
%   Function takes as an input a 3-D RGB image, where each channel contains
%   gamma-corrected doubles in the range [0,1] and outputs a 3-D matrix whose
%   components are: Y' - illumination [0,1], Cb and Cr [-0.5,0.5] - chroma components
%
% Input:
%               rgb_img - RGB image, double format, range = [0,1]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = imread('example.jpg');
% rgb_img = im2double(rgb_img); % convert it to double, range [0,1]
% ycbcr_img = dos_rgb2ycbcr(rgb_img);
% Y = ycbcr_img(:,:,1) % Ilumination matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 6.11.2016 (Aleksa Gordic)

% extract the red, green and blue color channels
R =  rgb_img( :, :, 1);
G =  rgb_img( :, :, 2);
B =  rgb_img( :, :, 3);

% constants for the standard: REC. 709 – HDTV
Kb =0.0722;
Kr =0.2126;

% conversion from RGB to Y'CbCr
Y = Kr*R + (1-Kr-Kb)*G + Kb*B;
Cb = (0.5*(B-Y))/(1-Kb);
Cr  = (0.5*(R-Y))/(1-Kr);

% pack into a 3-D matrix
ycbcr_img(:,:,1) = Y;
ycbcr_img(:,:,2) = Cb;
ycbcr_img(:,:,3) = Cr;

end

