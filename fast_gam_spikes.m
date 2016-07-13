function gam_spikes = fast_gam_spikes(spike_rate,order,duration)% gam_spikes = fast_gam_spikes(spike_rate,order,duration)%% Generates a spike trian using inter-spike-intervals drown from% a gamma distribution. This is the fast version.  It requires the% statistics toolbox and uses only a single spike rate for the duration.% For trains that change rate, see make_gam_spikes.% % Inputs: spike_rate	 mean firing rate (spikes/second)% duration               duration of spike sequence (sec)% order			 order of gamma. lower numbers are tighter -- 1 makes%                        the distribution exponential% Output: exp_spikes	 vector of times (msec) when spikes occur.% % 9/8/96 mns wrote it if nargin < 3  error('fast_gam_spikes requires 3 args');endif sum([size(spike_rate) size(duration) size(order)]) ~= 6  error('fast_gam_spikes requires 3 scalar args')endif order == 1  gam_spikes = fast_exp_spikes(spike_rate,duration);else  last_spiketime = 0;  mu=1/spike_rate;  while last_spiketime < duration    guessN = ceil(duration*spike_rate + 5*sqrt(duration*spike_rate));    % using 5 standard deviations should ensures that we make a long enough    % list    x = gamrnd(1/order,order*mu,guessN,1);    % hist(x,20),1/mean(x)  % should come out with rate    ttim = cumsum(x);    last_spiketime = ttim(guessN);    if last_spiketime < duration      sprintf('fast_gam_spikes: Warning - guessN too small')    end  end  lastspike = min(find(ttim>duration));  gam_spikes = ttim(1:lastspike);end