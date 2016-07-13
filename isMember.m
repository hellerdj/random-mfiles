function b = isMember(x,y)% Returns a 1 if x is a member of the list y.% x can be a scalar, vector, or matrix % y must be a vector of values.  % If x is a vector or matrix, then the function returns a% an array of 1s and 0s, with same size as x%% Usage: b = isMember(x,y)%   %	MNS 5/1/94  updated 10/20/94[m n] = size(x);x = x(:);				% make x into a column vectorb = zeros(size(x));z = zeros(size(x,1),length(y));for i = 1:length(y)  z(:,i) = x==y(i);endif size(z,2) > 1  b = sum(z')';  b = b > 0; else  b = z;endb = reshape(b,m,n);