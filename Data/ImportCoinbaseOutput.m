function coinbaseoutput = ImportCoinbaseOutput(year,month)
%IMPORTCOINBASEOUTPUT Summary of this function goes here

% Construct filename
filepath = join(['C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\coinbase_output_' year '_' month '.csv']);

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 9);

% Specify range and delimiter
opts.DataLines = [9, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Timestamp", "TransactionType", "Asset", "QuantityTransacted", "GBPSpotPriceAtTransaction", "GBPSubtotal", "GBPTotalinclusiveOfFees", "GBPFees", "Notes"];
opts.VariableTypes = ["datetime", "categorical", "categorical", "double", "double", "double", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Notes", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["TransactionType", "Asset", "Notes"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Timestamp", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss'Z'");

% Import the data
coinbaseoutput = readtable(filepath, opts);

return
end

