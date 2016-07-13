function [a,Asamp] = getAfile(Afile)% [a,Asamp]=getAfile(Afile) - reads a Rex Afile and returns:% a = a vector of the entire Afile, as signed 16bit integers equivalent to%    the "snt" used in the original rex C code% Asamp = a structure containing crucial information extracted from the%    Afile sample header and record.% If the Afile is nonexistent or empty of anything by the first 512 bytes,% getAfile returns empty arrays for both a and Asamp.% jpg - 4/7/98% 5/12/98 - rewritten to handle the possibility of empty Afiles% first open the Afile and read it into the vectorfid= fopen(Afile,'r');if fid<=0 % file is nonexistent   a=[];   Asamp=[];elsea = fread(fid,inf,'int16');% rewind the file to read in the sampheaderfseek(fid,0,-1);% find the location of the first magic numbermagics = find(a==18475);if isempty(magics) % file exists but is empty  Asamp = [];  a = [];  else % file is gosampoff = (magics(1)-1)*2;% format the sample header struct:Asamp = struct('signum',0,'maxrate',0,'minrate',0,'subfr_num',0,'mfr_num',0,...    'mfr_dur',0,'fr_sa_cnt',0,'mfr_sa_cnt',0,'gvname',[],'title',[],...    'store_rate',[],'store_order',[]);% the purpose of the next part of getAfile is to generate Asamp.store_order,% which will tell the various subsidiary parts of ComposeAnalog4trial how to% distribute the record data among signals. % for instance, if there are % signal 1, 125hz,% signal 2, 1000hz,% signal 3, 500hz, then the store_order would look like:% [1 2 3 2 2 3 2 2 3 2 2 3 2]% Thus, the store order array is used as the collation filter through% which ComposeAnalog4trial will distribute analog data.% the size of the store_order array will be checked against fr_sa_cntfseek(fid,sampoff,-1);% reading in the record headermagic = fread(fid,1,'int32');recnum = fread(fid,1,'int16');ecodeA = fread(fid,1,'int16');ectim = fread(fid,1,'int32');ucode = fread(fid,1,'int32');cont = fread(fid,1,'int16');nbytz = fread(fid,1,'int16');% reading in the sample header% note: the vast majority of the data in the sample header is currently% useless, but is stored for potential future compatibilitymaxsig = fread(fid,1,'int16');        % max. number of signalsfr_arr_size = fread(fid,1,'int16');   % frame array sizemaxcal = fread(fid,1,'int16');        % max # of calibrationslname = fread(fid,1,'int16');         % length of string namesAsamp.signum = fread(fid,1,'int16');    % actual number of signalsAsamp.maxrate = fread(fid,1,'int16');   % maximum sample rateAsamp.minrate = fread(fid,1,'int16');   % minimum sample rateAsamp.subfr_num = fread(fid,1,'int16'); % number of subframes per frameAsamp.mfr_num = fread(fid,1,'int16');   % number of frames per master frameAsamp.mfr_dur = fread(fid,1,'int16');   % msec duration of master frameAsamp.fr_sa_cnt = fread(fid,1,'int16'); % number of stored samples in a frameAsamp.mfr_sa_cnt = fread(fid,1,'int16'); % same but for master framead_channels = fread(fid,1,'int16');  % # of channels on a/d converterad_res = fread(fid,1,'int16');       % a/d resolution in bits: 12/16ad_rcomp = fread(fid,1,'int16');     % radix compensationad_ov_gain = fread(fid,1,'int16');   % datumsz = fread(fid,1,'int16');      % size of sample datum in bytes% offsets of sample dataad_rate_bo = fread(fid,1,'int16');  store_rate_bo = fread(fid,1,'int16');ad_calib_bo = fread(fid,1,'int16');shift_bo = fread(fid,1,'int16');gain_bo = fread(fid,1,'int16');ad_delay_bo = fread(fid,1,'int16');ad_chan_bo = fread(fid,1,'int16');frame_bo = fread(fid,1,'int16');gvname_bo = fread(fid,1,'int16');title_bo = fread(fid,1,'int16');calibst_bo = fread(fid,1,'int16');var_data_begin = fread(fid,1,'int16');% sample dataad_rate = fread(fid,[maxsig 1],'int16');  % acquisition ratesAsamp.store_rate = fread(fid,[maxsig 1],'int16'); % storage ratesad_calib = fread(fid,[maxsig 1],'int16'); % calibration numbersshift = fread(fid,[maxsig 1],'int16'); % shift factorsgain = fread(fid,[maxsig 1],'int16'); ad_delay = fread(fid,[maxsig 1],'int16'); % filter delaysad_chan = fread(fid,[maxsig 1],'int16'); % a/d channel for each a/d signalframe = fread(fid,[fr_arr_size],'int16'); % the frame arrayAsamp.gvname = fscanf(fid,'%c',[lname maxsig]); % signal glob var namesAsamp.title = fscanf(fid,'%c',[lname maxsig]); % signal titlescalibst = fscanf(fid,'%c',[lname maxsig]); % calibration factor ascii strings% pad the string arraysif size(Asamp.title,2)<maxsig  for i= size(Asamp.title,2)+1:maxsig    concat([Asamp.title]','.',' ');  endendif size(Asamp.gvname,2)<maxsig  for j = size(Asamp.gvname,2)+1:maxsig    concan([Asamp.gvname]','.',' ');  endend% close the Afilefclose(fid);% now the construction of store_order []% Within the frame array, each subframe goes like this:% #_of stored samples, samp_spec, samp_spec,... -1% Within a given subframe, not all samp_specs correspond to stored samples;% this is why there is a test to see if bit 15 is flagged - if so, the% sample was acquired for the frame but not stored. % Also, within the frame array, -1 indicates the end of a subframe, and -2% indicates the end of the frame array.% Since the low byte of a stored sample indicates the channel, store_order% is constructed simply by adding the channels of stored samples to the% array until the frame pointer equals -2, at which point the loop ends. % Gratis to Art Hays for inspiration and advice.i=1;      % frame array countersf = 1;   % subframe counterwhile i<=length(frame) & frame(i)~=-2  % hopefully this loop only happens twice...    while sf<=Asamp.subfr_num      % subframe counter    frameptr=frame(i);    i = i+1;        while frameptr ~= -1      frameptr=frame(i);      if frameptr ~= -1	if bitget(frameptr,15)~=1	  temp = uint8(frameptr);	  Asamp.store_order = [Asamp.store_order (double(temp)+1)];	  	  % why store the channel value + 1? because matlab and C address	  % arrays differently...	  	end      end      i = i+1;    end      sf = sf+1;  end  i = i+1;endend    endsize(a);size(Asamp);