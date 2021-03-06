function transactions = ConvertBinanceFromOnly(binance)
%CONVERTBINANCEFROMONLY Summary of this function goes here

noneAsset = CreateCategoricalNone(height(binance));
nanValue = NaN(size(noneAsset));
zeroValue = zeros(size(noneAsset));

transactions = table( ...
    binance.UTC_Time, ...
    noneAsset, ...
    zeroValue, ...
    zeroValue, ...
    zeroValue, ...
    noneAsset, ...
    zeroValue, ...
    zeroValue, ...
    zeroValue, ...
    binance.Coin, ...
    abs(binance.Change), ...
    nanValue, ...
    nanValue);

transactions = RenameTransactionColumns(transactions);

return
end

