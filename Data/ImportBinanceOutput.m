function binanceoutput = ImportBinanceOutput(year,month)
%UNTITLED Summary of this function goes here

% Construct the filepath
filepath = join(['C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\binance_output_' year '_' month '.csv']);

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["UTC_Time", "Account", "Operation", "Coin", "Change", "Remark"];
opts.VariableTypes = ["datetime", "categorical", "categorical", "categorical", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Remark", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Account", "Operation", "Coin", "Remark"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "UTC_Time", "InputFormat", "dd/MM/yyyy HH:mm");

% Import the data
binanceoutput = readtable(filepath, opts);

return
end

