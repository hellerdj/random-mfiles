function err = llikdata_poisson(q)% err = llikdata_poisson(q)%	The value of err is the -log likelihood of obtaining Data%	given the parameters in vector Q, which is just rate.   Data%	is a global vector of values.%	Uses calls to stats package.%% M Shadlen 9/94global Data llik = sum(log(poisspdf(Data,q)));err = -llik;