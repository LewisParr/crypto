function transactions = ProcessBinanceDeposits(binanceoutput)
%PROCESSBINANCEDEPOSITS Summary of this function goes here

%% Deposit
% Get transactions with the Deposit operation
binancedep = binanceoutput(binanceoutput.Operation=='Deposit',:);
deptransactions = ConvertBinanceToOnly(binancedep);

% Clean up
clear binancedep

%% Aggregate
transactions = deptransactions;

% Clean up
clear deptransactions

return
end

