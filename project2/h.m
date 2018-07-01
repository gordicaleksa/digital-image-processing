function [ Y ] = h( X )
% H helper function for the forward conversion (from XYZ to Lab)
%
% created: 7.11.2016 (Aleksa Gordic)

boundary = 0.008856;
Y = X;

% if bigger than boundary apply the 3rd root function
a = X(X > boundary);
a = nthroot(a,3);

% if smaller apply the linear relation
b = X(X<=boundary);
b = 7.787*b + 16/116;

% logical matrices
I1 = X>boundary;
I2 = X<=boundary;

% logical indexing
Y(I1) = a;
Y(I2) = b;

end

