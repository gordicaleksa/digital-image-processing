function [ mosaic, simple_mosaic ] = create_mosaic( element_img, big_img )
% CREATE_MOSAIC generates a mosaic image which looks like the big_img 
% but is actually made out of small element_img images
%
% detailed description: 
%
%	Function takes as input 2 images element_img and big_img. Then it
%	creates a new image that when looked from a distance looks exactly
% 	like the big_img but when zoomed in you can tell it's made up from
% 	smaller element_img images.
%
%	element_img changes it's mean value such that the element_img on position (i,j)
% 	has the same mean value as the pixel (i,j) of the big_img, thus the mean
% 	value of the output image remains the same as the mean of the big_img image.
%
% Input:
%				Input relatively small images so that the output image 
%				can fit on the screen without any scaling applied
%
%%%%%%%%%%%%%%%% EXAMPLE %%%%%%%%%%%%%%%%%%
% element_img = imread('element.png');
% big_img = imread('big.png');
% mosaic = create_image_matrix(element_img, big_img); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% created: 23.10.2016 (Aleksa Gordic)


N = size(element_img,1);
M = size(element_img,2);
H = size(big_img,1);
W = size(big_img,2);

% generates a simple mosaic whose dynamics is yet to be changed
simple_mosaic = create_image_matrix (element_img, [H W]);
mosaic = simple_mosaic;

% 1. IMPLEMENTATION: 
% 
% Values of the output image are in the range [0,255] (it will work for uint16 also)
% and the mean value of the output image is the same as of big_img image. Greater t-complexity though.
% Saturation can occur as uint8 is used
% 
% time it took (using tic-toc) for example image: Elapsed time is 0.854293 seconds.
% uncommment the part under if you wish to use the 1. implementation:

for i = 1:1:H
    for j = 1:1:W
        
        % adjusts the mean of the element_img so that it's the same
		  % as big_img(i,j) and also the range is [0,255]	
        element = adjust_element_mean(element_img,big_img(i,j));
        mosaic (((i-1)*N)+1:i*N, ((j-1)*M)+1:j*M) = element;
        
    end
end

% 2. IMPLEMENTATION:
%
% Values of the output image are not in the range [0,255], the mean value
% of the output image is the same as of big_img image. 
% Saturation cannot occur as we use double and will later scale it to [0,1]
%
% time it took for example image: Elapsed time is 0.008391 seconds. (~100x faster)
% uncommment the part under if you wish to use the 2. implementation:
% 
% big_img = double(big_img);
% element_img = double(element_img);
% el_img_mean = mean(element_img(:));
% 
%  for i = 1:1:H
%     for j = 1:1:W
%         
%         diff = big_img(i,j) - el_img_mean;
%         mosaic (((i-1)*N)+1:i*N, ((j-1)*M)+1:j*M) = mosaic (((i-1)*N)+1:i*N, ((j-1)*M)+1:j*M) + diff;
%         
%     end
%  end


end % end of create_mosaic.m
