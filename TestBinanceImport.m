%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Binance');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Utilities');

%% Get binance holdings
[dates,assets,holdings,holdingvalues,transactions,moneyin,moneyout] = ...
    GetBinanceHoldings();

%% Plot holdings over time
currentholdings = PlotHoldingsOverTime(dates,holdings,assets);

%% Plot total value of holdings over time
plotIndividual = 1;
plotTotal = 1;
[currentholdingvalues,currenttotalholdings] = ...
    PlotHoldingsValueOverTime(holdingvalues,assets,dates,plotIndividual,plotTotal);

% Clean up
clear plotIndividual plotTotal
