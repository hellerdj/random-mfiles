function [h,p,F,df,brich,bred,bintrich,bintred,statrich,statred] = nestedF(y,Arich,Ared,alpha,alpha_inc)% [h,p,F,df,brich,bred,bintrich,bintred,statrich,statred] = nestedF(y,Arich,Ared,alpha,alpha_inc)% Performs multiple regression using 2 models, specified by design matrices,% A1 and A2, and compares the models to see if one offers a better fit to% the data.  The two models must be nested, and there should not be a% significant lack of fit for the richer model.  The order of the models% is important in the argument list.  Many of the return arguments apply to% the individual models.  %% Input% ~~~~~% y   column vector of dependent variable, call its length m.% Arich   m by p  matrix of independent variables. There are p regressors% Ared    m by q  matrix of independent variables. q < p% alpha   serves 3 purposes -- criterion for hypothesis testing for our%         model comparison and also to test for lack of fit of the richer%         model. Also serves as basis for CI on the regressors.% alpha_inc  the nested regression is only performed if the rich model is %           achieves at least this level of significance.  default = 0.2% Output% ~~~~~~% h    1 if richer model offers significantly better fit. NaN if neither%      model achieves significance at p<=alpha% p    p value to reject H0: reduced model is just as good% F    F ratio used to compute probability% df   2-vector: [p-q, m-p]% brich   p-vector: lsq estimates for richer model% bred    q-vector: lsq estimates for reduced model% bintrich  p by 2 matrix containing CI for regressors, rich model% bintred  p by 2 matrix containing CI for regressors, reduced model% statrich  rsquared value, F and p for the rich model (alone)  (3-vector)% statred   rsquared value, F and p for the reduced model (alone)%% Ref. Draper & Smith, 2nd ed. pp. 97-98.  Needs stats toolbox.% 3/9/97 mns wrote itn = length(y);[brich,bintrich,rrich,rintrich,statrich] = regress(y,Arich,alpha); % fit rich[bred,bintred,rred,rintred,statred] = regress(y,Ared,alpha); % fit redif statrich(3) > alpha_inc & statred(3) > alpha_inc  % neither model offers an adequate fit  h = nan;  p = nan;  F = nan;  df = [nan nan];  % return the vals from the regression anyway  % brich = nan * ones(size(Arich,2),1);  % bred = nan * ones(size(Ared,2),1);else  dfs2 = n - size(Arich,2);		% df for our estimate of s2  s2 = sum(rrich.^2)/dfs2;		% estimate s2 from residuals    extraSS2 = sum(rred.^2) - sum(rrich.^2); % extra sum of squares  extradf = size(Arich,2) - size(Ared,2);	% associated df  df = [extradf dfs2];			% to return    F = (extraSS2/extradf) / s2;  p = 1 - fcdf(F,extradf,dfs2);    h = p <= alpha;end