function exodusoutput = ImportAllExodusData()
%IMPORTALLEXODUSDATA Summary of this function goes here

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Timestamp", "ToAsset", "ToQuantity", "ToRate", "ToTotal", "FeeAsset", "FeeQuantity", "FeeRate", "FeeTotal", "FromAsset", "FromQuantity", "FromRate", "FromTotal"];
opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "categorical", "double", "double", "double", "categorical", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["ToAsset", "FeeAsset", "FromAsset"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Timestamp", "InputFormat", "dd/MM/yyyy HH:mm");

% Import the data
exodusoutput = readtable("C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\exodus_output.csv", opts);

% Sort data by timestamp
exodusoutput = sortrows(exodusoutput,'Timestamp','ascend');

return
end

