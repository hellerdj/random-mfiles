function y = gaussian(x,u,ss)%	GAUSSIAN computes a normalized gaussian as function of x%		y = gaussian(x,u,ss) computes the function%		y = 1/(sqrt(2*pi*ss) * exp(-(x-u).^2/(2*ss))%		(so u is mean and ss is variance)%		user must set the range of x appropriately.%		a good choice is linspace(u-4*ss,u+4*ss,100);%[m,n] = size(u);if length(u) == 1	y = 1/sqrt(2*pi*ss) * exp(-(x-u).^2/(2*ss));elseif min(size(u)) == 1	% compute gaussian in each row corresponding to the vals of u	[X,U] = meshgrid(x,u);	y = 1/sqrt(2*pi*ss) * exp(-(X-U).^2/(2*ss));end