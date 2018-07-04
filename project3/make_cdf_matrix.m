function [ cdf_matrix ] = make_cdf_matrix(p_image, block_size,limit)
%MAKE_CDF_MATRIX creates a CDF array for every tile in the input image

M = size(p_image,1);
N = size(p_image,2);
M_block = block_size(1);
N_block = block_size(2);
T1 = M/M_block;
T2 = N/N_block;
cdf_matrix = zeros(T1,T2,256);

% iterate through the tiles
for i = 1:T1
    for j = 1:T2
        % extract a block
        a = (i-1)*M_block+1;
        b = i*M_block;
        c = (j-1)*N_block+1;
        d = j*N_block;
        current_block = p_image(a:b,c:d);
        % find normalized histogram
        hnorm = imhist(current_block)./numel(current_block);
        
        % clip the normalized histogram 
        sum = 0;
        for m = 1:256
           if (hnorm(m)>limit) 
               sum = sum + (hnorm(m)-limit);
               hnorm(m) = limit;
           end
        end
        hnorm = hnorm + sum/256;
        
        cdf = cumsum(hnorm);
        cdf_matrix(i,j,:) = cdf;
    end
end

end

