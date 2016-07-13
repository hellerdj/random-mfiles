function [b,bint,r2fp,hPoints,hFit,hPred] = fitCarpGraph(t, tmin, tinf)% fitCarpGraph(t) fits the cumulative probability reciprocal latencies% in the style of Carpenter & Williams, 1995.  The input is a list of reaction% times in msec.% % [b,bint,r2fp,hPoints,hFit,hPred] = fitCarpGraph(t, tmin, tinf)%    THe additional input args control the horizontal extent of the plot. %    tmin is the shortest latency by default%    tinf is 10^6 msec by default.  These values do not affect the fit but%    they do affect the plot.% %    The output args are from the regression and some handles.% 12/24/99 mns wrote it% Bin the values.  % Decide on the number of binsnt = length(t)if nt < 10	nbins = length(t);elseif nt < 50	nbins = 10;else	nbins = round(nt/5);end% Use histogram to get bins and the frequenciesrecipt = 1./t;[nn tt] = hist(recipt,nbins);ff = nn / sum(nn);% Compute the cumulative probabilities from the binned datacumprobBIN = 1 - cumsum(ff);size(cumprobBIN)% Label each point with its cumulative prob  obtained from binningL = binLikeHist(recipt,tt,1);cump = repmat(cumprobBIN,size(L,1),1);cump = cump(L);T = repmat(t,1,nbins);T = T(L);size(L)% Convert to z-scores (probit paper)z = norminv(cump,0,1);% figure(3),clf% Plot in the current axeshPoints = plot(1./T,z,'ko','MarkerFaceColor','k','MarkerSize',2)axprefs(gca)hold on% fit the dataA = [ones(size(T)) 1./T];% using only finite valsLf = all(finite([A z]'))';[b bint res resint r2fp] = regress(z(Lf),A(Lf,:));% Use only points in the fit to show the fit lineinvtaxData = [1 min(A(Lf,2)); 1 max(A(Lf,2))]  hFit = line(invtaxData(:,2)', invtaxData*b,'LineWidth',1,'Color','k')set(gca,'XDir','reverse')if nargin < 2	tmin = min(t);endif nargin < 3	tmax = 10^6else	tmax = tinf;endt4pred = [50 100 150 200 300 500 1000 tmax]'zExtrap = [ones(size(t4pred)) 1./t4pred] * b;hold onhPred = plot(1./t4pred,zExtrap,'k--','LineWidth',0.5)set(gca,'XLim',[1./[tmax tmin]])ylim = get(gca,'YLim');set(gca,'YLim',[ylim(1) max(zExtrap)])set(gca,'Xtick',1./t4pred(end:-1:1))q = cellstr(num2str(t4pred))% q = cellstr(t4pred)q{end} = 'inf'set(gca,'XTickLabel',q(end:-1:1))ylabel('Value of inverse normal for cdf')xlabel('Reaction time (ms)')