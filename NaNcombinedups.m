function [y, N] = NaNcombinedups(x,matchi,ni)%	[y, N] = NaNcombinedups(x,matchi,ni)%	This is a spinoff from combinedups.m which allows NaN's to be%	present and ignored in the averages.  It is important that the%	matchi columns do not contain NaN vals.  The routine maintains a%	weighted mean of the values in matching columns and keeps track of%	the number of rows that contained nonNaN vals for each element.  If%	the 1st unique row contains a NaN, the weighted mean is 0 and the%	count is 1. The routine is awfully slow -- not sure why.  %	Updated 3/1/95.  Discovered bug in replace_xs_with_y.m and changed%	logic from for-loop to while-loop (MNS)%	--%	The following applies to combinedups.  %	N is a matrix the size of y with the number of true entries in each%	mean. i.e., terms that are nonNaN%		Takes array x and returns array y with all duplicated%		rows in x averaged.  The duplicate condition is defined%		by equality in the columns in vector matchi.%		The averages are performed as weighted averages given a %		number in column ni.  For example, columns 1 and 3 might% 		contain parameters describing a trial type or simulation%		variables.  An array of data might contain multiple%		lines of output with the same parameters.  %		If the number of observations is in column 9, say,%		then this routine returns an array with unique%		entries in columns 1 and 3 and with weighted averages%		in the rest of the columns (except 9).%	summary: %		x 	input array; rows are observations%		matchi	vector of column indices in x that are to be matched %			to establish that observation is a duplicate and% 			should be averaged%		ni	column index containing counts or weight.  This value%			determines the weights assigned at averaging.%			It is incremented in the output array to reflect the%			new combined count or weight. (If unspecified, it%			is assumed to be 1)%j = 1;		% row number for output matrix[nr nc] = size(x);if (nargin == 2)	% fprintf(1,'No weights specified.  Assuming 1.\n');	x = [x ones(nr,1)];	% append column of 1's to x 	[nr nc] = size(x);	% re-establish row, column count 	ni = nc;		% ni is last column end% of the nc columns, we will be incrementing some of the column and leaving% some alone.  The columns we increment by averaging are all but the % the match and count columns.  Their indices will be in tci.tci = 1:nc;tci([matchi ni]) = [];% take the 1st row of x and copy it to y.  This gets us started. We cannot% tolerate any NaN in the output, so we use a 0.  This is sensible since our% intent is to keep track of the sum of the values on nonNaN terms.y = replace_xs_with_y(x(1,:),nan,0); 	% get rid of NaNs% y = x(1,:);% also get the counts started.  Use the counts in the ni column provided% that the value of interest is a real value.  If it's a NaN, then use 1.% Notice that we use 1 instead of 0 so that the denominator will not be 0% later.  Notice that N has the same number of columns as x and y.N(1,:) = x(1,ni) * (~isnan(x(1,:))) + isnan(x(1,:));for i = 2:nr  % fprintf(1,'Working on input row %d\n', i);  % in this loop we step through the rows of the input matrix  % question 1: have we seen these parameters before  [mr mc] = size(y);	% we need to know y's current dimensions  nomatchflag = 1;  j = 1;				% start at top of output array  % fprintf(1,'trying to match %d %d\n', x(i,matchi))  while (j <= mr) & nomatchflag    % fprintf(1,'Searching for match for row %d to output array row %d\n',i,j);    % in this loop we step through the output array and see if we     % find a match    if x(i,matchi) == y(j,matchi)	% increment appropriate columns of jth row in y with ith row of x	% as a weighted average.  Then increment the counts (weights) directly	% w is a vector of weights for entries in x.  It is the value in the	% weight column or a 0.  Notice that w is a row vector with the same	% lenght as a row of x.  You must refer explicitly to entries	% indexed by tci to match the vales of x(i,tci).	% fprintf(1,'row %d matches row %d of output array\n', i,j);	w = x(i,ni) * (~isnan(x(i,:)));	x0 = replace_xs_with_y(x(i,:),nan,0); % get rid of NaNs	y(j,tci) = (N(j,tci) .* y(j,tci) + w(tci) .* x0(tci)) ./ (N(j,tci) + w(tci));	N(j,:) = N(j,:) + w;	% set nomatchflag to 0	nomatchflag = 0;    else      j = j+1; 				% try the next row of y    end  end  % this while loop ended because we ran out of rows of y or we found a  % match. If the former, then  if nomatchflag == 1    % tack the ith row of x on to y    y = [y; replace_xs_with_y(x(i,:),nan,0)]; % get rid of NaNs    % y = [y; x(i,:)];    % tack the counts on to N.  Use a 1 if a NaN is present.    N = [N; x(i,ni) * (~isnan(x(i,:))) + isnan(x(i,:))];    % N(:,1:7)				% debugging  endend