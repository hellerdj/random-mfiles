function ybool = file_exist(fname)% ybool = file_exist('fname')%    returns 1 if a file exists and 0 otherwise.s = sprintf('ls %s >& /dev/null', fname);status = unix(s);if status == 0  ybool = 1;else  ybool = 0;end