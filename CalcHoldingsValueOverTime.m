function holdingvalues = CalcHoldingsValueOverTime(holdings,assets,dateLimits)
%CALCHOLDINGSVALUEOVERTIME Summary of this function goes here

% Construct holdings array
holdingvalues = zeros(size(holdings));

% Iterate over assets
for a = 1:width(holdings)
    
    % Get the asset's symbol
    assetSymbol = assets(a);
    
    if (or(assetSymbol=='GBP',assetSymbol=='GBPX'))
        
        % GBP, so value equal to holdings
        holdingvalues(:,a) = holdings(:,a);
    else
        
        % Get the GBP market for the asset
        market = GbpMarketFromAssetSymbol(assetSymbol);
        
        % Skip is we don't have data available
        if (market~="")
            
            % Get the asset's price history
            assetgbp = ReadHistoricalPrice_CoinCodex(market);
            
            % Track date index
            d = 1;
        
            % Iterate over dates
            for date = dateLimits(1):dateLimits(2)

                % Find today's price index 
                priceIndex = find(assetgbp.Date==date);
                
                % Skip if we didn't find the price
                if (priceIndex>0) 
                    
                    % Get the asset's price on this date
                    assetPrice = assetgbp.Close(priceIndex);
                    
                    % Sometimes we get more than one price
                    if (length(assetPrice)>1)
                        assetPrice = assetPrice(1);
                    end
                    
                    % Calculate holding value
                    holdingvalues(d,a) = assetPrice*holdings(d,a);
                end
                
                % Prepare for tomorrow
                d = d + 1;
            end
        else
            disp('PRICE UNAVAILABLE FOR: ');
            disp(assetSymbol);
        end
    end 
end

return
end

