function [n,prepost] = myhist(x,xbins)%  n = myhist(x,xbins)% faster histograming when the bins are known in advance% counts the number of observations in x that fall between the elements of% xbins. Includes the lower bound and less than the upper bound.% also returns a 2 vector that gives the number of obs before and after the% lowest and highest vals in xbinsbwmin = min(diff(xbins));zx = floor(x(:)/bwmin);n = zeros(1,length(xbins)-1);ibins = floor(xbins/bwmin);clear xbins;clear x;mbintvector(ibins);mbintvector(zx);mbintvector(n);% try converting to integers for speedfor i = 2:length(ibins)  n(i) = length(find(zx>=ibins(i-1) & zx<ibins(i)));endif nargout >1  prepost = [sum(zx<ibins(1)) sum(zx>=ibins(length(ibins)))];end