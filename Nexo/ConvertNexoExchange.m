function transactions = ConvertNexoExchange(nexo,gbpusd)
%CONVERTNEXOEXCHANGE Summary of this function goes here

noneAsset = CreateCategoricalNone(height(nexo));
zeroValue = zeros(size(noneAsset));

amountSplits = split(nexo.Amount," / ");
amounts = str2double(amountSplits);

currencies = split(cellstr(nexo.Currency),"/");

transactions = table( ...
    nexo.DateTime, ...
    categorical(currencies(:,2)), ...
    amounts(:,2), ...
    (nexo.USDEquivalent./amounts(:,2))*gbpusd, ...
    nexo.USDEquivalent*gbpusd, ...
    noneAsset, ...
    zeroValue, ...
    zeroValue, ...
    zeroValue, ...
    categorical(currencies(:,1)), ...
    amounts(:,1), ...
    (nexo.USDEquivalent./amounts(:,1))*gbpusd, ...
    nexo.USDEquivalent*gbpusd);

transactions = RenameTransactionColumns(transactions);

return
end
