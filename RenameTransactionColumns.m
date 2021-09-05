function transactions = RenameTransactionColumns(transactions)
%RENAMETRANSACTIONCOLUMNS Summary of this function goes here

transactions = renamevars( ...
    transactions, ...
    GetTransactionBlankColumnNames(), ...
    GetTransactionColumnNames());

return
end

