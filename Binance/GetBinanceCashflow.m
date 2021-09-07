function [moneyin,moneyout] = GetBinanceCashflow(binanceoutput)
%GETBINANCECASHFLOW Summary of this function goes here

% Cashflow IN to cryptocurrency
moneyintransactions = binanceoutput(binanceoutput.Operation=='Deposit',:);
moneyintransactions = moneyintransactions(moneyintransactions.Coin=='GBP',:);
moneyinamounts = moneyintransactions.Change;
moneyin = sum(moneyinamounts);

% Cashflow OUT of cryptocurrency
% ...
moneyout = 0;

return
end

