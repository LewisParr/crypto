function [moneyin,moneyout] = GetNexoCashflow(nexooutput)
%GETNEXOCASHFLOW Summary of this function goes here

% Cashflow IN to cryptocurrency
moneyintransactions = nexooutput(nexooutput.Type=='ExchangeDepositedOn',:);
moneyinamounts = str2double(moneyintransactions.Amount);
moneyin = sum(moneyinamounts);

% Cashflow OUT of cryptocurrency
% ...
moneyout = 0;

return
end

