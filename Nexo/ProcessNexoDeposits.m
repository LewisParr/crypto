function transactions = ProcessNexoDeposits(nexooutput)
%PROCESSNEXODEPOSITS Summary of this function goes here

%% Deposit
% Get transactions with the Deposit type
nexodeposit = nexooutput(nexooutput.Type=='Deposit',:);
deptransactions = ConvertNexoToOnly(nexodeposit,0.726);

% Clean up
clear nexodeposit

%% Aggregate
transactions = deptransactions;

% Clean up
clear deptransactions;

return
end

