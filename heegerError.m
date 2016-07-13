function err = heegerError(x)% returns the difference between output of the Heeger normalization model% with input, xin, and the output.  The input signal, xin, normalization% signal, nsig, and constant Rmax are defined globally.  %  The only independent variable is sigma.  global Rmax xin nsigerr = sqrt((xin - Rmax*xin/(sigma+nsig)).^2);