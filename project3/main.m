%% clear the workspace

close all;
clear all;
clc;

%% Problem 1.1 - image quality enhancement - giraff.jpg

close all;
clear all;
clc;

G = imread('example_input/giraff.jpg');
G = im2double(G);
% we can see that the image contrast is very bad as the pixels are
% accumulated in the range [0.349, 0.6392]
figure(1); imshow(G);
figure(2); imhist(G); ylim('auto'); 

% let's stretch the contrast and find "optimal" gamma value
% for i = 1:-0.05:0.5
% P = imadjust(G,stretchlim(G,0.01),[0 1],i);
% figure(1); imshow(P);
% %figure(2); imhist(P); ylim('auto');
% pause
% end
% looks best for gamma = 0.9

G = imadjust(G,stretchlim(G,0.01),[0 1],0.9);
figure(3); imshow(G);
figure(4); imhist(G); ylim('auto');

% can we sharpen the edges even more?

% 1. unsharp mask
% w_lp = fspecial('average',3);
% G_lp = imfilter(G,w_lp,'replicate');
% G_hp = G - G_lp;
% G_sharp = G+G_hp;
% G_sharp = im2uint8(G_sharp);
% figure(5); imshow(G_sharp);
% figure(6); imhist(G_sharp); ylim('auto');
% doesn't give good results for arbitrary mask size

% 2. Laplacian filter
% w_laplacian = [0 1 0; 1 -4 1; 0 1 0];
% G_laplacian = imfilter(G_lp, w_laplacian,'replicate');
% G_sharp = uint8(255*(G-G_laplacian));
% figure(8); imshow(G_sharp);

% image resolution is the problem and not the sharpness of edges

% specification - image should be saved as 8-bit .jpg image with quality = 90
G = im2uint8(G);
imwrite(G, 'example_output/giraff_out.jpg', 'quality', 90);

%%  Problem 1.2 - image quality enhancement - enigma.png

close all;
clear all;
clc;

E = imread('example_input/enigma.png');
E = im2double(E);
% we can see on both the image itself as well on the histogram
% that the image has a strong salt-and-pepper (impulse) noise.
figure(1); imshow(E);
figure(2); bar(imhist(E)); ylim('auto');

% median filter is very good against this kind of noise

% let's find the best size for the median filter
% for i = 11:2:15
% P = medfilt2(E, [i i], 'symmetric');
% figure(3); imshow(P);
% figure(4); imhist(P); ylim('auto');
% pause;
% end
% optimal value is 11 as with the bigger mask the image gets too blurry

E = medfilt2(E, [11 11], 'symmetric');
figure(3); imshow(E);
figure(4); imhist(E); ylim('auto');

% by looking at the histogram we can see that we need to enhance the contrast
% A = adapthisteq(E, 'ClipLimit',0.03,'NumTiles',[30 15]); <- bad results
% figure(100); imshow(A);
E = imadjust(E,stretchlim(E,0.01),[0 1]);
figure(5); imshow(E);
figure(6); imhist(E); ylim('auto');

% let's sharpen the edges
% for i = 3:3:30
% w_lp = fspecial('average', i);
% E_lp = imfilter(E, w_lp, 'replicate');
% E_hp = E - E_lp;
% E_sharp = E + E_hp;
% E_sharp = uint8(E_sharp*255);
% figure(100); imshow(E_sharp);
% pause;
% end
% we get best result for the size = 9

w_lp = fspecial('average', 9);
E_lp = imfilter(E, w_lp, 'replicate');
E_hp = E - E_lp;
E_sharp = E + E_hp;
figure(7); imshow(E_sharp);
figure(8); imhist(E_sharp); ylim('auto');

% specification - image should be saved as 8-bit .jpg image with quality = 90
E_sharp = im2uint8(E_sharp);
imwrite(E_sharp, 'example_output/enigma_out.jpg', 'quality', 90);

%%  Problem 1.3 - image quality enhancement - disney.jpg, gray

close all;
clear all;
clc;

D = imread('example_input/disney.jpg');
D_gray = rgb2gray(D);
D_gray = im2double(D_gray);
% we can see that the image contrast is very bad
figure(1); imshow(D_gray);
figure(2); bar(imhist(D_gray)); ylim('auto'); xlim([0 255]);

% for i=0.5:0.05:1
% P_gray = imadjust(D_gray,stretchlim(D_gray,0.01),[0 1],i);
% figure(3); imshow(P_gray);
% figure(4); bar(imhist(P_gray)); ylim('auto'); xlim([0 255]);
% pause;
% end
% best value = 0.7 but the edges are poor

D_gray = imadjust(D_gray,stretchlim(D_gray,0.01),[0 1],0.7);
figure(3); imshow(D_gray);
figure(4); bar(imhist(D_gray)./numel(D_gray(:)));

% let's try AHE algorithm
% for i = 0.01:0.01:0.08
% D_gray_ae = adapthisteq(D_gray, 'ClipLimit',i,'NumTiles',[30 15]);
% figure(5); imshow(D_gray_ae);
% figure(6); bar(imhist(D_gray_ae)); ylim('auto'); xlim([0 255]);
% pause
% end
% we get best results for the ClipLimit = 0.03

D_gray_ae = adapthisteq(D_gray, 'ClipLimit',0.03,'NumTiles',[30 15]);
figure(5); imshow(D_gray_ae);
figure(6); bar(imhist(D_gray_ae)); ylim('auto'); xlim([0 255]);

% let's make the edges smoother
w_lp = fspecial('gaussian', [19 19], 3);
D_gray_lp = imfilter(D_gray_ae,w_lp,'replicate');
figure(7); imshow(D_gray_lp);
figure(8); bar(imhist(D_gray_lp)); ylim('auto'); xlim([0 255]);

% specification - image should be saved as 8-bit .jpg image with quality = 90
D = im2uint8(D_gray_lp);
imwrite(D, 'example_output/disney_gray_out.jpg', 'quality', 90);

%% %%  Problem 1.4 - image quality enhancement - disney.jpg, color

close all;
clear all;
clc;

D = imread('example_input/disney.jpg');

figure(1); imshow(D);
% again pixels are accumulated in the dark region
figure(2); imhist(D(:,:,1));  ylim('auto'); xlim([0 255]);
figure(3); imhist(D(:,:,2));  ylim('auto'); xlim([0 255]);
figure(4); imhist(D(:,:,3));  ylim('auto'); xlim([0 255]);

% let's try to switch to Y'CbCr and do the contrast enhancment on the luma matrix
% for i = 1:10
% Dycbcr = rgb2ycbcr(D);
% Dycbcr(:,:,1) = imadjust(Dycbcr(:,:,1),stretchlim(Dycbcr(:,:,1),0.01),[0 1],0.5+i/100);
% D_pom = ycbcr2rgb(Dycbcr);
% figure(100); imshow(D_pom);
% pause;
% end

% let's try to switch to HSV and do the contrast enhancment on the V matrix
% for i = 1:10
% Dhsv = rgb2hsv(D);
% Dhsv(:,:,3) = imadjust(Dhsv(:,:,3),stretchlim(Dhsv(:,:,3),0.01),[0 1],i/10);
% D_pom = hsv2rgb(Dhsv);
% figure(100); imshow(D_pom);
% pause;
% end

w_lp = fspecial('gaussian', [19 19], 3);

% best result for Y'CbCr is for gamma = 0.5
% Dycbcr = rgb2ycbcr(D);
% Dycbcr(:,:,1) = imadjust(Dycbcr(:,:,1),stretchlim(Dycbcr(:,:,1),0.01),[0 1],0.5);
% Dycbcr(:,:,1) = imfilter(Dycbcr(:,:,1),w_lp,'replicate');
% D_pom = ycbcr2rgb(Dycbcr);
% figure(5); imshow(D_pom);
% set(gcf, 'Name', 'Best of YCbCr');

% best result for HSV is for gamma = 0.5, HSV looks better
Dhsv = rgb2hsv(D);
Dhsv(:,:,3) = imadjust(Dhsv(:,:,3),stretchlim(Dhsv(:,:,3),0.01),[0 1],0.5);
Dhsv(:,:,3) = imfilter(Dhsv(:,:,3),w_lp,'replicate');
D_pom = hsv2rgb(Dhsv);
figure(6); imshow(D_pom);
set(gcf, 'Name', 'Best of HSV');

% specification - image should be saved as 8-bit .jpg image with quality = 90
D = im2uint8(D_pom);
imwrite(D,'example_output/disney_color_out.jpg', 'quality', 90);

%% Problem 2 - sharpen the image

close all;
clear all;
clc;

L = imread('example_input/lange.jpg');
L = im2double(L);

% we can see a lot of noise in the image (neck, face ...)
% contrast is very good
figure(1); imshow(L);
figure(2); bar(imhist(L)); ylim('auto'); xlim([0 255]);

% we need to sharpen the image without amplifying the noise
% solution -> band-pass filter
w_lp_wide = fspecial('gaussian', [19 19], 3);
w_lp_narrow = fspecial('gaussian', [300 300], 3);

L_wide = imfilter(L,w_lp_wide,'replicate');
L_narrow =  imfilter(L,w_lp_narrow,'replicate');
L = 2*L_wide - L_narrow;

figure(3); imshow(L);

L = im2uint8(L);
imwrite(L,'example_output/lange_sharp.jpg');

%% Problem 3 - text binarization

close all;
clear all;
clc;

I = imread('example_input/text_stripes.tif');
I = im2double(I);

% we need to remove the stripes in order to correctly binarize the image
figure(1); imshow(I);
figure(2); imhist(I); ylim('auto');

% let's go through many combinations:
% for s = 30:10:70
%     for i = 35:10:75
%         w_lp = fspecial('gaussian', [i i], s);
%         I_lp = imfilter(I, w_lp, 'replicate');
% 
%         figure(3); imshow(I_lp);
%         J=mat2gray(I-I_lp);
%         figure(4); imshow(J);
%         figure(5); imhist(J); ylim('auto');
%         pause;
% 
%         % find the correct threshold
%         for j = 0.45:0.01:0.55
%             Jb = im2bw(J, j);
%             figure(6); imshow(Jb);
%         
%             display(s);
%             display(i);
%             display(j);
%             pause;
%         end
%     end
% end
% similar results, this seems nice:
% sigma = 60, MxN = 45x45 and threshold = 0.57 better then graythresh() <- Otsu's method

w_lp = fspecial('gaussian', [45 45], 60);
I_lp = imfilter(I, w_lp, 'replicate');
figure(3); imshow(I_lp);
        
J = mat2gray(I-I_lp);
figure(4); imshow(J);
% by looking at the histogram we can choose threshold 
figure(5); imhist(J); ylim('auto');

% binarization
Jb = im2bw(J, 0.57);
figure(6); imshow(Jb);

Jb = im2uint8(Jb);
imwrite(Jb,'example_output/binarization.png');

%% Problem 4 - testing the dos_clahe function

clear all;
close all;
clc; 

% read in the image
mars = imread('example_input/mars_moon.tif');

figure(99); imshow(mars);

%%%%%%%%%%%%%%%%%%%%% CHANGING THE NUMBER OF TILES %%%%%%%%%%%%%%%%%%%%%%%%

tic
M1 = dos_clahe(mars,[1 1],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(1);
imshow(M1);
set(gcf, 'Name', 'num_tiles = [1 1]');

tic
M4 = dos_clahe(mars,[4 4],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(2);
imshow(M4); 
set(gcf, 'Name', 'num_tiles = [4 4]');

tic
M8 = dos_clahe(mars,[8 8],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(3);
imshow(M8);
set(gcf, 'Name', 'num_tiles = [8 8]');

tic
M16 = dos_clahe(mars,[16 16],0.08);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(4);
imshow(M16);
set(gcf, 'Name', 'num_tiles = [16 16]')

%%%%%%%%%%%%%%%%%%%%% CHANGING THE CLIP LIMIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
M0 = dos_clahe(mars,[16 16],0.01);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(5);
imshow(M0);
set(gcf, 'Name', 'limit = 0.01')

tic
M0 = dos_clahe(mars,[16 16],0.1);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(6);
imshow(M0);
set(gcf, 'Name', 'limit = 0.1')

tic
M0 = dos_clahe(mars,[16 16],1);
t = toc;
t_norm = t/numel(mars);
display(t_norm);
figure(7);
imshow(M0);
set(gcf, 'Name', 'limit = 1')



% save the best image
imwrite(M16,'example_output/mars_clahe_best.jpg');
        