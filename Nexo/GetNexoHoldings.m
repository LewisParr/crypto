function [ ...
    dates, ...
    assets, ...
    holdings, ...
    holdingvalues, ...
    transactions, ...
    moneyin, ...
    moneyout] = GetNexoHoldings()
%GETNEXOHOLDINGS Summary of this function goes here

%% Import all nexo files
nexooutput = ImportAllNexoData();

%% Get summary
[dateLimits,transactionTypes,assets] = SummariseNexoOutput(nexooutput);

%% Get crypto fund cashflow
[moneyin,moneyout] = GetNexoCashflow(nexooutput);

%% Extract transaction data
% Extract deposit transaction data
deptransactions = ProcessNexoDeposits(nexooutput);

% Extract yield transaction data
yieldtransactions = ProcessNexoYields(nexooutput);

% Extract exchange transaction data
exchangetransactions = ProcessNexoExchanges(nexooutput);

% Unhandled types:
% WithdrawalCredit
% TransferOut
% ExchangeDepositedOn
% DepositToExchange
% LockingTermDeposit

%% Aggregate transactions 
transactions = [ ...
    deptransactions; ...
    yieldtransactions; ...
    exchangetransactions];
transactions = sortrows( ...
    transactions, ...
    'Timestamp', ...
    'ascend');

% Clean up
clear deptransactions yieldtransactions exchangetransactions

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

