function [ rgb_image ] = dos_ycbcr2rgb( ycbcr_image )
%  DOS_YCBCR2RGB converts Y'CbCr image to a RGB image
%
%  detailed explanation:
%
%  Function takes as an input a 3-D Y'CbCr matrix and converts it
%  into a 3-D RGB matrix where each channel is of a double type and [0,1]
%  
% Input:
%              YCbCr image, 
%              Y: range: [0,1] 
%              Cb,Cr: range: [-0.5,0.5]
%              double format
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = dos_ycbcr2rgb(ycbcr_img);
% R = rgb_img(:,:,1) % red channel
% figure(1);
% imshow(R); % display the red channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 6.11.2016 (Aleksa Gordic)

Y = ycbcr_image(:,:,1);
Cb = ycbcr_image(:,:,2);
Cr = ycbcr_image(:,:,3);

% constants for the standard: REC. 709 – HDTV
Kb =0.0722;
Kr =0.2126;

% conversion from Y'CbCr to RGB
R = 2*Cr*(1-Kr) + Y;
B = 2*Cb*(1-Kb) + Y;
G = (Y - Kr*R - Kb*B)./(1-Kr-Kb);

% create_illsion function requires this saturation arithmetic part:
R(R<0) = 0; G(G<0) = 0; B(B<0) = 0;
R(R>1) = 1; G(G>1) = 1; B(B>1) = 1;

% pack into a 3-D matrix
rgb_image(:,:,1) = R;
rgb_image(:,:,2) = G;
rgb_image(:,:,3) = B;

end

