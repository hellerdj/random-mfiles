% test file for plot1ras and also development for alpha stuff% r is  spike times in msecr = round(1000*cumsum(exprnd(.02,20,1)));% and a raster  of 5 trialsras = round(1000*cumsum(exprnd(.02,20,5)))'ras(2,15:end) = nanras(3,1:4) = nanclear plot1rash = plot1ras(r,1,.4,[.8 .6 .1],3)i = 1hold offfor i=1:5  trialnum = i;  st1 = ras(i,:);  plot1ras(ras(i,:),i); hold on;endclear alpha1rassptimes = r;startmsec = 0;endmsec = 400;arg2 = startmsecarg3 = endmsecalpha_tg = 1;alpha_td = 20;[spikerate,A] = alpha1ras(sptimes,startmsec,endmsec,alpha_tg,alpha_td);t = [startmsec:endmsec]/1000;hold off, plot(t,spikerate)trapz(t,spikerate)a = alphafunc(0:100,1,20);sum(a)s = alpha1ras(sptimes,a,[startmsec:endmsec]);plot(t,spikerate,'-',t,s,'+')% try alpha on rasras[ratematrix,t] = applyAlpha2Raster(ras,startmsec,endmsec,alpha_tg,alpha_td);hold offplot(t,ratematrix')plot(t,mean(ratematrix))