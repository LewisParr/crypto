function btcusd = ReadHistoricalBTCUSD_CoinCodex()
%READHISTORICALBTCUSD_COINCODEX Reads a historical price data file for
%BTCUSD, provided by CoinCodex.

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
btcusd = readtable("C:\Users\lparr\Documents\MATLAB\Crypto\Data\coincodex_btcusd_2010-8-16_2021-7-31.csv", opts);

return

end

