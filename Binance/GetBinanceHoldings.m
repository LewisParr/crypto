function [ ...
    dates, ...
    assets, ...
    holdings, ...
    holdingvalues, ...
    transactions, ...
    moneyin, ...
    moneyout] = GetBinanceHoldings()
%GETBINANCEHOLDINGS Summary of this function goes here

%% Import all binance files
binanceoutput = ImportAllBinanceData();

%% Get summary
[dateLimits,transactionTypes,accounts,operations,assets] ...
    = SummariseBinanceOutput(binanceoutput);

%% Get crypto fund cashflow
[moneyin,moneyout] = GetBinanceCashflow(binanceoutput);

%% Extract transaction data
% Extract deposit transaction data
deptransactions = ProcessBinanceDeposits(binanceoutput);

% Extract buy/fee/transaction related/sell data
exchangetransactions = ProcessBinanceExchanges(binanceoutput);

% Extract reward distribution/POS savings interest/savings interest/launchpool interest
yieldtransactions = ProcessBinanceYields(binanceoutput);

% Extract commission history transactions
misctransactions = ProcessBinanceMisc(binanceoutput);

% Unhandled operations:
% POS savings purchase
% Savings purchase
% POS savings redemption
% Savings Principal redemption

%% Aggregate transactions
transactions = [ ...
    deptransactions; ...
    exchangetransactions; ...
    yieldtransactions; ...
    misctransactions];
transactions = sortrows( ...
    transactions, ...
    'Timestamp', ...
    'ascend');

% Clean up
clear deptransactions exchangetransactions yieldtransactions ...
    misctransactions

%% Remove unused assets
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

