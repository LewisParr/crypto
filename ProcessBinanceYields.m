function transactions = ProcessBinanceYields(binanceoutput)
%PROCESSBINANCEYIELDS Summary of this function goes here

%% Rewards Distribution
% Get transactions with the Rewards Distribution operation
binancerwddist = binanceoutput(binanceoutput.Operation=='Rewards Distribution',:);
rwddisttransactions = ConvertBinanceToOnly(binancerwddist);

% Clean up
clear binancerwddist

%% POS savings interest
% Get transactions with the POS savings interest operation
binanceposint = binanceoutput(binanceoutput.Operation=='POS savings interest',:);
posinttransactions = ConvertBinanceToOnly(binanceposint);

% Clean up
clear binanceposint

%% Savings Interest
% Get transactions with the Savings Interest operation
binancesavint = binanceoutput(binanceoutput.Operation=='Savings Interest',:);
savinttransactions = ConvertBinanceToOnly(binancesavint);

% Clean up
clear binancesavint

%% Launchpool Interest
% Get transactions with the Launchpool Interest operation
binancelaunchint = binanceoutput(binanceoutput.Operation=='Launchpool Interest',:);
launchinttransactions = ConvertBinanceToOnly(binancelaunchint);

% Clean up
clear binancelaunchint

%% Aggregate
transactions = [ ...
    rwddisttransactions; ...
    posinttransactions; ...
    savinttransactions; ...
    launchinttransactions];

% Clean up
clear rwddisttransactions posinttransactions savinttransactions ...
    launchinttransactions

return
end

