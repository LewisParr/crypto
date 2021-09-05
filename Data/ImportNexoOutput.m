function nexooutput = ImportNexoOutput(year,month)
%IMPORTNEXOOUTPUT Summary of this function goes here

% Construct filename
filepath = join(['C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\nexo_output_' year '_' month '.csv']);

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Transaction", "Type", "Currency", "Amount", "USDEquivalent", "Details", "OutstandingLoan", "DateTime"];
opts.VariableTypes = ["string", "categorical", "categorical", "string", "double", "categorical", "double", "datetime"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Transaction", "Amount"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Transaction", "Type", "Currency", "Amount", "Details"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, ["USDEquivalent", "OutstandingLoan"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["USDEquivalent", "OutstandingLoan"], "ThousandsSeparator", ",");

% Import the data
nexooutput = readtable(filepath, opts);

return
end

