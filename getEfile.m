function [e,pnum] = getEfile(fn)% [e pnum] = getEfile(filename)  opens REX Efile FN and returns the N by 3%    matrix , E and paradigm number, PNUM.  %    column 1 gives the event number.  IT goes from 1 to N.%    column 2 contains the ECODE%    column 3 contains the time%%% testing% fn = '/home/mike/data/lip/eve/raw/e510eE'% error('comment out testing')fid = fopen(fn,'r');if fid<0  error('getEfile: cannot open file');end[q,count] = fread(fid,[512 1],'uchar'); % skip 1st 512 bytes[e1,count] = fread(fid,[4,inf],'uint16');e1(2:4,:) = [];fclose(fid);fid = fopen(fn,'r');[q,count] = fread(fid,[512 1],'uchar'); % skip 1st 512 bytes[e2,count] = fread(fid,[4,inf],'int16');e2([1 3 4],:) = [];fclose(fid);fid = fopen(fn,'r');[q,count] = fread(fid,[512 1],'uchar'); % skip 1st 512 bytes[e3,count] = fread(fid,[2,inf],'uint32');e3(1,:) = [];fclose(fid);e = [e1' e2' e3'];pnum = e(find(e(:,2) > 8192),2) - 8192;