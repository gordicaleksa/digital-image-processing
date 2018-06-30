% main program for generating the mosaic image

%% cleans the workspace
clear;
close all;
clc;

%% main logic

% input your images here:
img1 = 'example_input/cartman.png'; % building block
img2 = 'example_input/mona_lisa.png'; % big image

% creates uint8/uint16 (depending on the bits per color plane)
% matrix that represents the image
small_img = imread(img1);
% if the image has 3 channels convert it to grayscale
if (size(small_img,3)==3)
    small_img = rgb2gray(small_img);
end
big_img = imread(img2);
if (size(big_img,3)==3)
    big_img = rgb2gray(big_img);
end

% this is the main function of the program returns matrix M of doubles 
% that represents the output mosaic image and simple_mosaic which
% doesn't have the dynamics of the bigger image incorporated 
[M, simple_mosaic] = create_mosaic(small_img, big_img);

% scale
M = M - min(M(:)); % lowest value becomes 0
M = M./(max(M(:))); % highest value becomes 1
simple_mosaic = simple_mosaic - min(simple_mosaic(:));
simple_mosaic = simple_mosaic./(max(simple_mosaic(:)));

% show the images in different figures
figure(1); 
imshow(simple_mosaic);

figure(2);
imshow(M);

% if you wish to see the first implementation uncomment it in the 
% file create_mosaic.m and comment out the second implementation
imwrite(simple_mosaic, 'example_output/simple_mosaic.png');
imwrite(M, 'example_output/mosaic.png');


