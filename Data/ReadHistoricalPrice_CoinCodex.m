function assetgbp = ReadHistoricalPrice_CoinCodex(market)
%READHISTORICALPRICE_COINCODEX Summary of this function goes here

% Construct filename
filepath = join(['C:\Users\lparr\Documents\MATLAB\crypto\Data\Price\coincodex_' market '.csv']);

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Date", "Open", "High", "Low", "Close", "Volume", "MarketCap"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Date", "InputFormat", "MMM-dd-yyyy");

% Import the data
assetgbp = readtable(filepath, opts);

return
end

