function transactions = ProcessBinanceMisc(binanceoutput)
%PROCESSBINANCEMISC Summary of this function goes here

%% Commission History
% Get transactions with the Commission History operation
binancecomhist = binanceoutput(binanceoutput.Operation=='Commission History',:);
comhisttransactions = ConvertBinanceToOnly(binancecomhist);

% Clean up
clear binancecomhist

%% Aggregate
transactions = comhisttransactions;

% Clean up
clear comhisttransactions

return
end

