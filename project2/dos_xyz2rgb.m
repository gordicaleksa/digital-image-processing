function [ Irgb ] = dos_xyz2rgb( Ixyz, primaries, white, tf_params )
%DOS_XYZ2RGB converts XYZ image to a RGB image
%
% Input:
%               Ixyz - XYZ image, double format
%               primaries - coordinates of R,G and B primary colors in X,Y,Z   
%               white - coordinates of white color in X,Y,Z
%               tf_params - parameters of a gamma correction function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = dos_xyz2rgb(xyz_img,primaries,white,tf_params);
% R = rgb_img(:,:,1); % extract the red channel
% figure(1);
% imshow(R); % display the red channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 6.11.2016 (Aleksa Gordic)

% extract the information from the input
Xr = primaries.R(1);
Yr = primaries.R(2);
Zr = primaries.R(3);
Xg = primaries.G(1);
Yg = primaries.G(2);
Zg = primaries.G(3);
Xb = primaries.B(1);
Yb = primaries.B(2);
Zb = primaries.B(3);
Xw = white(1);
Yw = white(2);
Zw = white(3);

t = tf_params.t;
f = tf_params.f;
gamma = tf_params.gamma;
s = tf_params.s;

% extract the X,Y and Z channels
X = double(Ixyz(:,:,1));
Y = double(Ixyz(:,:,2));
Z = double(Ixyz(:,:,3));

% extract the size information
N = size(X,1);
M = size(X,2);

% some helper matrices we'll need later in processing
P = [Xr Xg Xb; Yr Yg Yb; Zr Zg Zb];
Pinv = inv(P);
W = [Xw Yw Zw]';
S = Pinv*W;
Sr = S(1);
Sg = S(2);
Sb = S(3);
T = [Sr*Xr Sg*Xg Sb*Xb; Sr*Yr Sg*Yg Sb*Yb; Sr*Zr Sg*Zg Sb*Zb];
Tinv = inv(T);

% init the matrices
R = zeros(N,M);
G = R;
B = R;

% convert from XYZ to linear RGB
for i = 1:1:N
    for j = 1:1:M
        XYZ = [X(i,j) Y(i,j) Z(i,j)]';
        RGB = Tinv*XYZ;
        R(i,j) = RGB(1);
        G(i,j) = RGB(2);
        B(i,j) = RGB(3);
    end
end

% saturation arithmetic because of the create_illusion function
R(R>1) = 1;
R(R<0) = 0;
G(G>1) = 1;
G(G<0) = 0;
B(B>1) = 1;
B(B<0) = 0;

% convert from linear RGB to sRGB
I1 = R>t;
I2 = R<=t;
R(I1) = (1+f)*(R(I1).^gamma)-f;
R(I2) = R(I2)*s;

I1 = G>t;
I2 = G<=t;
G(I1) = (1+f)*(G(I1).^gamma)-f;
G(I2) = G(I2)*s;

I1 = B>t;
I2 = B<=t;
B(I1) = (1+f)*(B(I1).^gamma)-f;
B(I2) = B(I2)*s;

% pack into a 3-D matrix
Irgb(:,:,1) = R;
Irgb(:,:,2) = G;
Irgb(:,:,3) = B;

end

