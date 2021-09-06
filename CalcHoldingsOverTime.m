function [dates,holdings] = CalcHoldingsOverTime(transactions,assets,dateLimits)
%PLOTHOLDINGSOVERTIME Summary of this function goes here

% Construct dates vector
dates = transpose(dateLimits(1):dateLimits(2));

% Construct holdings array
holdings = zeros(length(dates),length(assets));

% Track date index
d = 1;

% Iterate over days
for date = dateLimits(1):dateLimits(2)
    disp(date)
    
    % Today's transactions
    todaytransactions = transactions( ...
        transactions.Timestamp >= date & ...
        transactions.Timestamp < (date+1),:);
    
    % Iterate over assets
    for a = 1:length(assets)
        
        % Carry holdings forward
        if (d~=1)
            holdings(d,a) = holdings(d-1,a);
        end
        
        % Asset's transactions
        [to,fee,from] = ExtractAssetTransactions(todaytransactions,assets(a));
        
        % Apply transactions
        holdings(d,a) = holdings(d,a) ...
            + sum(to.ToQuantity) ...
            - sum(fee.FeeQuantity) ...
            - sum(from.FromQuantity);
    end
    
    % Prepare for tomorrow
    d = d + 1;
end

return
end