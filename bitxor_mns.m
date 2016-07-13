 function z = bitxor(x,y)%  z = bitxor(x,y)%  performs element by element bitwise xor on x and y.  X and Y can %    be scalars, vectors, or matrices -- but they must be identically sized.%    Exception: if one value is a scalar then it is xor'd with all the elements% 	of the other matrix.%    Floating point vals are converted to integer component.% Author: Mike Shadlen based on Hans Olsson's dec2bin routine in the matlab% 	digest for binary conversion.% 9/30/95 % handle the condition in which one input is a scalar if size(x) == [1 1]	x = x * ones(size(y));	[mm nn] = size(y); elseif size(y) == [1 1]	y = y * ones(size(y));	[mm nn] = size(x); else	[mm nn] = size(x); end n = 1;		% minimum number of digits to represent x = x(:); y = y(:); [f,e]=log2(max([x;y]));     % How many digits do we need to represent the numbers? % s=setstr(rem(floor(d(:)*pow2(1-max(n,e):0)),2)+'0');  % Olson's line % each row of b1 is a binary representation nbits = max(n,e); b1 = rem(floor(x(:)*pow2(1-nbits:0)),2); b2 = rem(floor(y(:)*pow2(1-nbits:0)),2); c = xor(b1,b2); p = max(n,e)-1:-1:0; P = p(ones(size(c,1),1),:); % you need the conditional because you only wan to take the sum if there's % more than one bit. if nbits > 1   z = sum((c.*(2.^P))')'; else   z = c; end z = reshape(z,mm,nn);