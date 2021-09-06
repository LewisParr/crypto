function [to,fee,from] = ExtractAssetTransactions(transactions,asset)
%EXTRACTASSETTRANSACTIONS Summary of this function goes here

% Transactions to the asset
to = transactions(transactions.ToAsset==asset,:);

% Transactions fees paid with asset
fee = transactions(transactions.FeeAsset==asset,:);

% Transactions from the asset
from = transactions(transactions.FromAsset==asset,:);

return
end

