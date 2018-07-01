function [ Y ] = h_inv( X )
% H_INV helper function for the inverse conversion (from Lab to XYZ)
%
% created: 7.11.2016 (Aleksa Gordic)

boundary = 7.787*0.008856 + 16/116;
Y = X;

% raise to power of 3 all of the elements bigger than the boundary
a = X(X>boundary);
a = a.^3;

% apply linear relation for all of the elements smaller or equal 
b = X(X<=boundary);
b = (b - 16/116)./7.787;

% logical indexing matrices
I1 = X>boundary;
I2 = X<=boundary;

% logical indexing
Y(I1) = a;
Y(I2) = b;

end

