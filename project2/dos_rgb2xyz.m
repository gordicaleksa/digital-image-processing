function [ Ixyz ] = dos_rgb2xyz( Irgb, primaries, white, tf_params )
%DOS_RGB2XYZ converts RGB image to a XYZ image
%
% Input:
%               Irgb - RGB image, double format, range = [0,1]
%               primaries - coordinates of R,G and B primary colors in X,Y,Z   
%               white - coordinates of white color in X,Y,Z
%               tf_params - parameters of a gamma correction function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rgb_img = imread('example.jpg');
% xyz_img = dos_rgb2xyz(rgb_img,primaries,white,tf_params);
% X = xyz_img(:,:,1); % extract the X channel
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

% extract the color channels
R = Irgb(:,:,1);
G = Irgb(:,:,2);
B = Irgb(:,:,3);

% extract the size information
N = size(R,1);
M = size(R,2);

% init the matrices
X = zeros(N,M);
Y = X;
Z = X;

% some helper matrices we'll need later in processing
P = [Xr Xg Xb; Yr Yg Yb; Zr Zg Zb]; % primaries
Pinv = inv(P);
W = [Xw Yw Zw]';
S = Pinv*W;
Sr = S(1);
Sg = S(2);
Sb = S(3);
T = [Sr*Xr Sg*Xg Sb*Xb; Sr*Yr Sg*Yg Sb*Yb; Sr*Zr Sg*Zg Sb*Zb]; % transformation matrix

% slow implementation: 23.285704 s
% for i = 1:1:N
%     for j = 1:1:M
%         
%         if (R(i,j) <= s*t & R(i,j)>=0)
%             Rlin = R(i,j)/s;
%         else
%             Rlin = nthroot((R(i,j)+f)/(1+f),gamma);
%         end 
%         if (G(i,j) <= s*t & G(i,j)>=0)
%             Glin = G(i,j)/s;
%         else
%             Glin = nthroot((G(i,j)+f)/(1+f),gamma);
%         end 
%         if (B(i,j) <= s*t & B(i,j)>=0)
%             Blin = B(i,j)/s;
%         else
%             Blin = nthroot((B(i,j)+f)/(1+f),gamma);
%         end 
%         
%        Lin = [Rlin Glin Blin]';
%        XYZ = T*Lin;
%        X(i,j) = XYZ(1);
%        Y(i,j) = XYZ(2);
%        Z(i,j) = XYZ(3);    
%     end
% end

% convert from sRGB to linear RGB color system
I1 = R <= s*t;
I2 = R > s*t;
R(I1) = R(I1)./s;
R(I2) = nthroot((R(I2)+f)/(1+f),gamma);

I1 = G <= s*t;
I2 = G > s*t;
G(I1) = G(I1)./s;
G(I2) = nthroot((G(I2)+f)/(1+f),gamma);

I1 = B <= s*t;
I2 = B > s*t;
B(I1) = B(I1)./s;
B(I2) = nthroot((B(I2)+f)/(1+f),gamma);

% convert from linear RGB to XYZ
for i = 1:1:N
    for j = 1:1:M
       Lin = [R(i,j) G(i,j) B(i,j)]';
       XYZ = T*Lin;
       X(i,j) = XYZ(1);
       Y(i,j) = XYZ(2);
       Z(i,j) = XYZ(3);    
    end
end

% pack into a 3-D matrix
Ixyz(:,:,1) = X;
Ixyz(:,:,2) = Y;
Ixyz(:,:,3) = Z;

end

