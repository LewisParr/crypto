function swissborgoutput = ImportSwissborgOutput(year,month)
%IMPORTSWISSBORGOUTPUT Summary of this function goes here

% Construct filename
filepath = join(['C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\swissborg_output_' year '_' month '.csv']);

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [10, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["UserID", "eadab5d997437b8f6f09c7ec5d211", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11"];
opts.VariableTypes = ["datetime", "datetime", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "categorical"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["VarName3", "VarName4", "VarName11"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "UserID", "InputFormat", "yyyy-MM-dd HH:mm:ss");
opts = setvaropts(opts, "eadab5d997437b8f6f09c7ec5d211", "InputFormat", "yyyy-MM-dd HH:mm:ss");

% Import the data
swissborgoutput = readtable(filepath, opts);

return
end

