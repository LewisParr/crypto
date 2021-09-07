function [ ...
    dateLimits, ...
    transactionTypes, ...
    assets] = SummariseNexoOutput(nexooutput)
%SUMMARISENEXOOUTPUT Summary of this function goes here

dateLimits = [min(nexooutput.DateTime) max(nexooutput.DateTime)];
[y,m,d] = ymd(dateLimits);
dateLimits = datetime(y,m,d);
transactionTypes = unique(nexooutput.Type);
assets = unique(nexooutput.Currency);

end

