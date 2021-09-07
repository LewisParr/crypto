function transactions = ProcessNexoYields(nexooutput)
%PROCESSNEXOYIELDS Summary of this function goes here

%% Interest
% Get transactions with the Interest type
nexointerest = nexooutput(nexooutput.Type=='Interest',:);
inttransactions = ConvertNexoToOnly(nexointerest,0.726);

% Clean up
clear nexointerest

%% Aggregate
transactions = inttransactions;

% Clean up
clear inttransactions

return
end

