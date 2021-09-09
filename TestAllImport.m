%% Initialise
clf;
clear;
clc;
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Exodus');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Nexo');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Binance');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Utilities');

%% Collect coinbase
TestCoinbaseImport;
coinbasedates = dates;
coinbaseholdings = holdings;
coinbaseholdingvalues = holdingvalues;
coinbasetotalvalue = sum(holdingvalues,2);
coinbasemoneyin = moneyin;
coinbasemoneyout = moneyout;

% Clean up
clear a assetgbp assetPrice assets assetSymbol d date dates holdings ...
    holdingvalue holdingvalues itemNames market moneyin moneyout ...
    moneyinamounts moneyintransactions priceIndex transactions_tt

%% Collect swissborg
TestSwissborgImport;
swissborgdates = dates;
swissborgholdings = holdings;
swissborgholdingvalues = holdingvalues;
swissborgtotalvalue = sum(holdingvalues,2);
swissborgmoneyin = moneyin;
swissborgmoneyout = moneyout;

% Clean up
clear a assetgbp assetPrice assets assetSymbol d date dates holdings ...
    holdingvalue holdingvalues itemNames market moneyin moneyout ...
    moneyinamounts moneyintransactions moneyoutamounts priceIndex ...
    moneyouttransactions transactions_tt

%% Collect guarda
TestGuardaImport;
guardadates = dates;
guardaholdings = holdings;
guardaholdingvalues = holdingvalues;
guardatotalvalue = sum(holdingvalues,2);
guardamoneyin = 0;
guardamoneyout = 0;

% Clean up
clear a assetgbp assetPrice assets assetSymbol d date dates holdings ...
    holdingvalue holdingvalues itemNames market priceIndex

%% Collect exodus
%TestExodusImport;
%exodusdates = dates;
%exodusholdings = holdings;
%exodusholdingvalues = holdingvalues;
%exodustotalvalue = sum(holdingvalues,2);
%exodusmoneyin = 0;
%exodusmoneyout = 0;
[exodusdates,exodusassets,exodusholdings,exodusholdingvalues, ...
    exodusTransactions,exodusmoneyin,exodusmoneyout] = ...
    GetExodusHoldings();

%% Collect nexo
[nexodates,nexoassets,nexoholdings,nexoholdingvalues,nexoTransactions, ...
    nexomoneyin,nexomoneyout] = ...
    GetNexoHoldings();

%% Collect binance;
[binancedates,binanceassets,binanceholdings,binanceholdingvalues, ...
    binanceTransactions,binancemoneyin,binancemoneyout] = ...
    GetBinanceHoldings();

%% Aggregate all transactions
transactions = [coinbase_transactions; swissborg_transactions; ...
    guarda_transactions; exodusTransactions; nexoTransactions; ...
    binanceTransactions];
transactions = sortrows(transactions,'Timestamp','ascend');
toassets = unique(transactions.ToAsset);
feeassets = unique(transactions.FeeAsset);
fromassets = unique(transactions.FromAsset);
assets = unique([toassets; feeassets; fromassets]);
dateLimits = [min(transactions.Timestamp) max(transactions.Timestamp)];
[y,m,d] = ymd(dateLimits);
dateLimits = datetime(y,m,d);

% Clean up
clear toassets feeassets fromassets d m y 

%% Calculate holdings over time
[dates,holdings] = CalcHoldingsOverTime(transactions,assets,dateLimits);

%% Plot holdings over time
currentholdings = PlotHoldingsOverTime(dates,holdings,assets);

%% Calculate value of holdings over time
[dates,holdingvalues] = CalcHoldingsValueOverTime(holdings,assets,dateLimits);

%% Plot total value of holdings over time
plotIndividual = 1;
plotTotal = 1;
[currentholdingvalues,currenttotalholdings] = ...
    PlotHoldingsValueOverTime(holdingvalues,assets,dates,plotIndividual,plotTotal);

% Clean up
clear plotIndividual plotTotal

%% Plot holdings across wallets and exchanges
clf;
tiledlayout(1, 5);

nexttile([1 4]);
hold on
plot(coinbasedates, coinbasetotalvalue, 'Color', '#2b6dd1');
plot(swissborgdates, swissborgtotalvalue, 'Color', '#70d12b');
plot(guardadates, guardatotalvalue, 'Color', '#2bbbd1');
plot(exodusdates, sum(exodusholdingvalues,2), 'Color', '#7e2bd1');
plot(nexodates, sum(nexoholdingvalues,2), 'Color', '#110e60');
plot(binancedates, sum(binanceholdingvalues,2), 'Color', '#d3c02c');
plot(dates, sum(holdingvalues,2), 'k');
hold off
title('Total Holding Value');
xlabel('Date');
ylabel('GBP');
legend({'Coinbase','Swissborg','Guarda','Exodus','Nexo','Binance','Total'});
set(legend,'location','best');

nexttile(5);
cb = [coinbasemoneyin coinbasemoneyout];
sb = [swissborgmoneyin swissborgmoneyout];
g = [guardamoneyin guardamoneyout];
e = [exodusmoneyin exodusmoneyout];
n = [nexomoneyin nexomoneyout];
b = [binancemoneyin binancemoneyout];
sumholdingvalues = sum(holdingvalues,2);
% Manually add Coinbase Wallet
cbw_manual = [0 0];
% Manually add Gemini
gem_manual = [100 0];
% Manually add Ledger
ledg_manual = [0 0];
% Manually add Binance Liquid Swaps
bls_manual = [0 0];
h = [0 sumholdingvalues(end)+(20*0.726)+154.53+(47*0.726)+(1814.1989*0.726)];
money = transpose([cb; sb; g; e; n; b; cbw_manual; gem_manual; ledg_manual; bls_manual; h]);
b = bar(money, 'stacked');
b(1).FaceColor = '#2b6dd1';
b(2).FaceColor = '#70d12b';
b(3).FaceColor = '#2bbbd1';
b(4).FaceColor = '#7e2bd1';
b(5).FaceColor = '#110e60';
b(6).FaceColor = '#d3c02c';
b(7).FaceColor = '#3c2bd1';
b(8).FaceColor = '#a4e9f2';
b(9).FaceColor = '#808d8e';
b(10).FaceColor = '#b25cb1';
b(11).FaceColor = '#d3562c';
legend({'Coinbase','Swissborg','Guarda','Exodus','Nexo','Binance','CB Wallet','Gemini','Ledger','B Liq Swaps','Holdings'});
set(legend,'location','best');
xticklabels({'In','Out'});
ylabel('GBP');
title('GBP In/Out');

% Clean up
clear b bls_manual cb cbw_manual e g gem_manual h ledg_manual money n sb 
