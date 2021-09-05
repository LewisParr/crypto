%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');

%% Import guarda file
% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Timestamp", "ToAsset", "ToQuantity", "ToRate", "ToTotal", "FeeAsset", "FeeQuantity", "FeeRate", "FeeTotal", "FromAsset", "FromQuantity", "FromRate", "FromTotal"];
opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "categorical", "double", "double", "double", "categorical", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["ToAsset", "FeeAsset", "FromAsset"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Timestamp", "InputFormat", "dd/MM/yyyy HH:mm");

% Import the data
guarda_transactions = readtable("C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading\guarda_output.csv", opts);

% Clear temporary variables
clear opts

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(guarda_transactions.ToAsset);...
    unique(guarda_transactions.FeeAsset);...
    unique(guarda_transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(guarda_transactions.Timestamp);
dates = datetime(y,m,d);
dates.Format = 'dd/MM/yy';
% Get a vector of all dates
dates = transpose(min(dates):max(dates));
% Construct an array of holdings over time
holdings = zeros(length(dates),length(assets));
% Collect the item names for each asset symbol
itemNames = {};
for a=1:length(assets)
    itemNames{a} = ItemNamesFromAssetSymbol(assets(a));
end
% Keep track of date index
d = 1;

% Iterate over days
for date=min(dates):max(dates)
    disp(date);
    
    % Carry holdings forward
    if (d~=1)
        for a=1:length(assets)
            holdings(d,a) = holdings(d-1,a);
        end
    end
    
    % today's transactions
    todayTransactions = guarda_transactions(...
        guarda_transactions.Timestamp >= date & ...
        guarda_transactions.Timestamp < (date+1),:);
    
    % Iterate over assets
    for a=1:length(assets)
        % asset's transactions
        toTransactions = todayTransactions(todayTransactions.ToAsset==assets(a),:);
        feeTransactions = todayTransactions(todayTransactions.FeeAsset==assets(a),:);
        fromTransactions = todayTransactions(todayTransactions.FromAsset==assets(a),:);
        
        % to
        holdings(d,a) = holdings(d,a) + sum(toTransactions.ToQuantity);
        
        % fee
        holdings(d,a) = holdings(d,a) - sum(feeTransactions.FeeQuantity);
        
        % from
        holdings(d,a) = holdings(d,a) - sum(fromTransactions.FromQuantity);
    end
    
    % Prepare for tomorrow
    d = d + 1;
end

% Clear temporary variables
clear a d date m y todayTransactions toTransactions feeTransactions ...
    fromTransactions

% Plot holdings over time
clf;
plot(dates, holdings);

%% Calculate value of holdings over time
% Construct array of holding value over time
holdingvalues = zeros(length(dates),length(assets));
% Keep track of date index
d = 1;

% Iterate over assets
for a=1:length(assets)
    assetSymbol = assets(a);
    
    if (assetSymbol=='GBP')
        holdingvalues(:,a) = holdings(:,a);
    else
        market = GbpMarketFromAssetSymbol(assetSymbol);

        if (market~="")
            assetgbp = ReadHistoricalPrice_CoinCodex(market);
            d = 1;

            % Iterate over dates
            for date=min(dates):max(dates)
                priceIndex = find(assetgbp.Date==date);

                if (priceIndex>0)
                    assetPrice = assetgbp.Close(priceIndex);
                    if length(assetPrice)>1
                        assetPrice=assetPrice(1);
                    end
                    holdingvalue = assetPrice*holdings(d,a);
                    holdingvalues(d,a) = holdingvalue;
                end

                d = d + 1;
            end
        else
            disp('PRICE UNAVAILABLE FOR: ');
            disp(assetSymbol);
        end
    end
end

%% Plot total holding value over time
clf;
plot(dates, sum(holdingvalues,2));
title('Total Holding Value');
xlabel('Date');
ylabel('GBP');
legend({'Guarda'});
set(legend, 'location', 'best');
