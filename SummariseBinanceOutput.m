function [...
    dateLimits, ...
    transactionTypes, ...
    accounts, ...
    operations, ...
    assets] = SummariseBinanceOutput(binanceoutput)
%SUMMARISEBINANCEOUTPUT Summary of this function goes here

dateLimits = [min(binanceoutput.UTC_Time) max(binanceoutput.UTC_Time)];
transactionTypes = unique(binanceoutput.Operation);
accounts = unique(binanceoutput.Account);
operations = unique(binanceoutput.Operation);
assets = unique(binanceoutput.Coin);

return
end

