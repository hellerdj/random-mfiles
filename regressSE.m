function [b,p,llik1] = regressSE(y,A,V)% [b,p,llik1] = regressSE(y,yerror,A,V)% performs  lsq linear regression of y on model A, obeying the covariancenormpdf(y,A*b,SE)