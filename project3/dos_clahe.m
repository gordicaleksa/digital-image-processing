function [out_image] = dos_clahe(image, varargin)
%DOS_CLAHE Contrast-limited Adaptive Histogram Equalization 
%
% Input:
%              image - uint8, grayscale image
%              num_tiles - [r c] number of row and column tiles 
%              limit - contrast limiting parameter
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mars = imread('mars_moon.tif');
% mars_clahe = dos_clahe(mars,[4 8],0.03);
% imshow(mars_clahe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 25.11.2016 (Aleksa Gordic)



%%%%%%%%%%%%%%%%%%%%%%%% INPUT PARSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% num_tiles and limit are optional parameters
switch nargin
    case 1
        num_tiles = [8 8];
        limit = 0.01;
    case 2       
        num_tiles = varargin{1};
        limit = 0.01;
    case 3   
        num_tiles = varargin{1};
        limit = varargin{2};
    otherwise
        disp('Wrong input, check input parameters with "help dos_clahe"');
        out_image = -1; % error code
        return;
end

% check if the image input is correct:
if (size(image,3)~= 1)
    disp('Image should be grayscale');
    out_image = -2; % error_code
    return;
end
if (~isa(image, 'uint8'))
    disp('Image should be uint8');
    out_image = -3; % error_code
    return;
end

% check if the number of tiles is correct:
T1 = num_tiles(1);
T2 = num_tiles(2);
% we should also set upper limit ...
if (T1 <= 0 || T2 <= 0)
    disp('Number of vertical and horizontal tiles must be positive');
    out_image = -4; % error_code
    return;
end

% check if the limit parameter is correct:
if (limit < 0 || limit > 1)
    disp('Limit should be in the range: [0,1]');
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%% IMAGE PADDING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = size(image,1);
N = size(image,2);

% assume we don't need any padding on both dimensions
pad_M = 0;
pad_N = 0;
% adjust so that we can cover the image with the tiles
if (mod(M,T1) ~= 0)
    pad_M = T1 - mod(M,T1);
end
if (mod(N,T2) ~= 0)
    pad_N = T2 - mod(N,T2);
end

p_image = padarray(image,[pad_M,pad_N],'replicate','post');

%%%%%%%%%%%%%%%%%%%%%%%% CLAHE PREPROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = size(p_image,1);
N = size(p_image,2);
M_block = M/T1;
N_block = N/T2;

block_size = [M_block N_block];
% matrix of cdf functions for every block in the image
cdf_matrix = make_cdf_matrix(p_image,block_size,limit);

% preallocate the output image
out_image = zeros(M,N);

% coordinates of the center pixel of the upper-left block
[xc11,yc11] = center_of_block(1,1,block_size);
% coordinates of the center pixel of the down-right block
[xcT1T2,ycT1T2] = center_of_block(T1,T2,block_size);

%%%%%%%%%%%%%%%%%%%%%%%% CLAHE STARTS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Padded image consists of tiles. There are T1xT2 tiles.
% Every tile is divided into 4 subblocks.
% There are 3 kinds of subblocks (look at the ASCII art below):
%
% 1. c - corner subblock , only 4 of these (no interpolation)
% 2. f - frame subblocks located near the image edge (linear interpolation)
% 3. . - inner subblocks (bilinear interpolation)
%
%   5x5 tiles image:
%
% -------------------------------
% |cc|ff|ff|ff|ff|ff|ff|ff|ff|cc|
% |ff|..|..|..|..|..|..|..|..|ff|
% |-----------------------------|
% |ff|..|..|..|..|..|..|..|..|ff|
% |ff|..|..|..|..|..|..|..|..|ff|
% |-----------------------------|
% |ff|..|..|..|..|..|..|..|..|ff|
% |ff|..|..|..|..|..|..|..|..|ff|
% |-----------------------------|
% |ff|..|..|..|..|..|..|..|..|ff|
% |ff|..|..|..|..|..|..|..|..|ff|
% |-----------------------------|
% |ff|..|..|..|..|..|..|..|..|ff|
% |cc|ff|ff|ff|ff|ff|ff|ff|ff|cc|
% |-----------------------------|

% iterate through every single pixel of the padded image and do certain
% kind of interpolation (none, linear, bilinear), using the cdf matrix,
% based in which subblock type (c,f,.) you are in
for i = 1:M
    for j = 1:N
    
        % block index of the current pixel
        [k,m] = block_index(i,j,block_size);
        % coordinates of the center pixel of the current block
        [xc,yc] = center_of_block(k,m,block_size);

        % if we are located in the frame
        if (i < xc11 || i >= xcT1T2 || j < yc11 || j >= ycT1T2)
            % if corner subblock => no interpolation occurs
            if ((i < xc11 && j < yc11) || (i >= xcT1T2 && j < yc11) || (i < xc11 && j >= ycT1T2) || ( i >= xcT1T2 && j >= ycT1T2))
                out_image(i,j) = cdf_matrix(k,m,p_image(i,j)+1);
            % otherwise we are in the frame subblock => linear interpolation
            else
                % if horizontal frame part
                if ((k == 1 || k == T1) && (j >= yc11 && j < ycT1T2))
                    if (j < yc)
                        a = j-(yc-N_block);
                        b = yc-j;
                        s = (a*cdf_matrix(k,m,p_image(i,j)+1) + b*cdf_matrix(k,m-1,p_image(i,j)+1))/(a+b);
                        out_image(i,j) = s;
                    else
                        a = j - yc;
                        b = (yc+N_block)-j;
                        s = (b*cdf_matrix(k,m,p_image(i,j)+1) + a*cdf_matrix(k,m+1,p_image(i,j)+1))/(a+b);
                        out_image(i,j) = s;                
                    end
                % else vertical frame part
                else
                    if (i < xc)
                        a = xc - i;
                        b = i - (xc-M_block);
                        s = (a*cdf_matrix(k-1,m,p_image(i,j)+1) + b*cdf_matrix(k,m,p_image(i,j)+1))/(a+b);
                        out_image(i,j) = s;
                    else
                        a = (xc+M_block) - i;
                        b = i - xc;
                        s = (a*cdf_matrix(k,m,p_image(i,j)+1) + b*cdf_matrix(k+1,m,p_image(i,j)+1))/(a+b);
                        out_image(i,j) = s;
                    end
                end
            end
        % otherwise we are in the inner part of the image => bilinear 
        % a,b,c,d - distances from the centers of the neighboring blocks
        elseif (i<xc && j<yc) % upper-left subblock
            a = j - (yc-N_block);
            b = yc - j;
            c = i - (xc-M_block);
            d = xc - i;
            sh1 = (b*cdf_matrix(k-1,m-1,p_image(i,j)+1) + a*cdf_matrix(k-1,m,p_image(i,j)+1))/(a+b);
            sh2 = (b*cdf_matrix(k,m-1,p_image(i,j)+1) + a*cdf_matrix(k,m,p_image(i,j)+1))/(a+b);
            out_image(i,j) = (d*sh1 + c*sh2)/(c+d);
        elseif (i >= xc && j < yc) % lower-left subblock
            a = j - (yc-N_block);
            b = yc - j;
            c = i - xc;
            d = xc+M_block-i;
            sh1 = (b*cdf_matrix(k,m-1,p_image(i,j)+1) + a*cdf_matrix(k,m,p_image(i,j)+1))/(a+b);
            sh2 = (b*cdf_matrix(k+1,m-1,p_image(i,j)+1) + a*cdf_matrix(k+1,m,p_image(i,j)+1))/(a+b);
            out_image(i,j) = (d*sh1 + c*sh2)/(c+d);
        elseif (i < xc && j >= yc)  % upper-right subblock
            a = j-yc;
            b = yc+N_block-j;
            c = i - (xc-M_block);
            d = xc - i;
            sh1 = (b*cdf_matrix(k-1,m,p_image(i,j)+1) + a*cdf_matrix(k-1,m+1,p_image(i,j)+1))/(a+b);
            sh2 = (b*cdf_matrix(k,m,p_image(i,j)+1) + a*cdf_matrix(k,m+1,p_image(i,j)+1))/(a+b);
            out_image(i,j) = (d*sh1 + c*sh2)/(c+d);
        else % lower-right subblock (i >= xc & j >= yc)
            a = j-yc;
            b = yc+N_block-j;
            c = i - xc;
            d = xc+M_block - i;
            sh1 = (b*cdf_matrix(k,m,p_image(i,j)+1) + a*cdf_matrix(k,m+1,p_image(i,j)+1))/(a+b);
            sh2 = (b*cdf_matrix(k+1,m,p_image(i,j)+1) + a*cdf_matrix(k+1,m+1,p_image(i,j)+1))/(a+b);
            out_image(i,j) = (d*sh1 + c*sh2)/(c+d); 
        end
           
    end
end

%%%%%%%%%%%%%%%%%%%%%%%% CROPPING AND CONVERTING %%%%%%%%%%%%%%%%%%%%%%%%%%

M = size(image,1);
N = size(image,2);
% convert to uint8
out_image = im2uint8(out_image);
% crop the padding we added
out_image = out_image(1:M,1:N);
        
end

%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ xc,yc ] = center_of_block( k,m,block_size )
%CENTER_OF_BLOCK returns the coordinates of the center pixel
% of the block with index (k,m)

M_block = block_size(1);
N_block = block_size(2);
xc = (k-1)*M_block + (M_block+1)/2;
yc = (m-1)*N_block + (N_block+1)/2;

end

function [ k,m ] = block_index( i,j,block_size )
%BLOCK_INDEX returns the block index of the pixel (i,j)

M_block = block_size(1);
N_block = block_size(2);
k = ceil(i/M_block);
m = ceil(j/N_block);

end



