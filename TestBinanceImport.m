%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');

%% Import all binance files
binanceoutput = ImportAllBinanceData();

%% Get summary
[dateLimits,transactionTypes,accounts,operations,assets] ...
    = SummariseBinanceOutput(binanceoutput);

%% Get crypto fund cashflow
[moneyin,moneyout] = GetBinanceCashflow(binanceoutput);

%% Extract deposit transaction data
deptransactions = ProcessBinanceDeposits(binanceoutput);

%% Extract buy/fee/transaction related/sell data
exchangetransactions = ProcessBinanceExchanges(binanceoutput);

%% Extract reward distribution/POS savings interest/savings interest/launchpool interest
yieldtransactions = ProcessBinanceYields(binanceoutput);

%% Extract commission history transactions
misctransactions = ProcessBinanceMisc(binanceoutput);

%% Unhandled operations:
% POS savings purchase
% Savings purchase
% POS savings redemption
% Savings Principal redemption

%% Aggregate transactions
binanceTransactions = [ ...
    deptransactions; ...
    exchangetransactions; ...
    yieldtransactions; ...
    misctransactions];
binanceTransactions = sortrows( ...
    binanceTransactions, ...
    'Timestamp', ...
    'ascend');

% Clean up
clear deptransactions exchangetransactions yieldtransactions ...
    misctransactions

%% Remove unused assets
toassets = unique(binanceTransactions.ToAsset);
feeassets = unique(binanceTransactions.FeeAsset);
fromassets = unique(binanceTransactions.FromAsset);
assets = unique([toassets; feeassets; fromassets]);

% Clean up
clear toassets feeassets fromassets

%% Calculate holdings over time
[dates,holdings] = CalcHoldingsOverTime(binanceTransactions,assets,dateLimits);

%% Plot holdings over time
currentholdings = PlotHoldingsOverTime(dates,holdings,assets);

%% Calculate value of holdings over time
holdingvalues = CalcHoldingsValueOverTime(holdings,assets,dateLimits);

%% Plot total value of holdings over time
individual = 1;
total = 1;
[currentholdingvalues,currenttotalholdings] = ...
    PlotHoldingsValueOverTime(holdingvalues,assets,dates,individual,total);

% Clean up
clear individual total
