function transactions = ProcessNexoExchanges(nexooutput)
%PROCESSNEXOTRANSACTIONS Summary of this function goes here

%% Exchange
% Get transactions with the Exchange type
nexoexchange = nexooutput(nexooutput.Type=='Exchange',:);
exchtransactions = ConvertNexoExchange(nexoexchange,0.726);

% Clean up
clear nexoexchange

%% Aggregate
transactions = exchtransactions;

% Clean up
clear exchtransactions

return
end

