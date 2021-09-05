function transactions = ProcessBinanceExchanges(binanceoutput)
%PROCESSBINANCEEXCHANGES Summary of this function goes here

%% Buy
% Get transactions with the Buy operation
binancebuy = binanceoutput(binanceoutput.Operation=='Buy',:);
buytransactions = ConvertBinanceToOnly(binancebuy);

% Clean up
clear binancebuy

%% Fee
% Get transactions with the Fee operation
binancefee = binanceoutput(binanceoutput.Operation=='Fee',:);
feetransactions = ConvertBinanceFeeOnly(binancefee);

% Clean up
clear binancefee

%% Transaction Related
% Get transactions with the Transaction Relation operation
binancetransrel = binanceoutput(binanceoutput.Operation=='Transaction Related',:);
transreltransactions = ConvertBinanceFromOnly(binancetransrel);

% Clean up
clear binancetransrel

%% Sell
% Get transactions with the Sell operation
binancesell = binanceoutput(binanceoutput.Operation=='Sell',:);
selltransactions = ConvertBinanceFromOnly(binancesell);

% Clean up
clear binancesell

%% Aggregate
transactions = [ ...
    buytransactions; ...
    feetransactions; ...
    transreltransactions; ...
    selltransactions];

% Clean up
clear buytransactions feetransactions transreltransactions ...
    selltransactions

return
end

