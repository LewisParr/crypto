function [ ...
    dates, ...
    assets, ...
    holdings, ...
    holdingvalues, ...
    transactions, ...
    moneyin, ...
    moneyout] = GetExodusHoldings()
%GETEXODUSHOLDINGS Summary of this function goes here

%% Import all exodus files
transactions = ImportAllExodusData();

%% Get date limits
dateLimits = [min(transactions.Timestamp) max(transactions.Timestamp)];
[y,m,d] = ymd(dateLimits);
dateLimits = datetime(y,m,d);

% Clean up
clear y m d

%% Get crypto fund cashflow
moneyin = 0;
moneyout = 0;

%% Get assets
toassets = unique(transactions.ToAsset);
feeassets = unique(transactions.FeeAsset);
fromassets = unique(transactions.FromAsset);
assets = unique([toassets; feeassets; fromassets]);

% Clean up
clear toassets feeassets fromassets

%% Calculate holdings over time
[dates,holdings] = CalcHoldingsOverTime(transactions,assets,dateLimits);

%% Calculate value of holdings over time
[dates,holdingvalues] = CalcHoldingsValueOverTime(holdings,assets,dateLimits);

return
end

