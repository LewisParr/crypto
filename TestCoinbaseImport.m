%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Utilities');

%% Import all coinbase files
coinbaseoutput202101 = ImportCoinbaseOutput('2021','01');
coinbaseoutput202102 = ImportCoinbaseOutput('2021','02');
coinbaseoutput202103 = ImportCoinbaseOutput('2021','03');
coinbaseoutput202104 = ImportCoinbaseOutput('2021','04');
coinbaseoutput202105 = ImportCoinbaseOutput('2021','05');
coinbaseoutput202106 = ImportCoinbaseOutput('2021','06');
coinbaseoutput202107 = ImportCoinbaseOutput('2021','07');
coinbaseoutput202108 = ImportCoinbaseOutput('2021','08');

%% Aggregate all coinbase files
coinbaseoutput = [coinbaseoutput202101; coinbaseoutput202102; ...
    coinbaseoutput202103; coinbaseoutput202104; coinbaseoutput202105; ...
    coinbaseoutput202106; coinbaseoutput202107; coinbaseoutput202108];
coinbaseoutput.Timestamp.Format = 'yyyy-MM-dd HH:mm:ss';

clear coinbaseoutput202101 coinbaseoutput202102 coinbaseoutput202103 ...
    coinbaseoutput202104 coinbaseoutput202105 coinbaseoutput202106 ...
    coinbaseoutput202107 coinbaseoutput202108

%% Get summaries
transactionTypes = unique(coinbaseoutput.TransactionType);

%% Prepare for extraction
fromColumnNames = {'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13'};
toColumnNames = {'Timestamp','ToAsset','ToQuantity','ToRate','ToTotal','FeeAsset','FeeQuantity','FeeRate','FeeTotal','FromAsset','FromQuantity','FromRate','FromTotal'};

%% Calculate total GBP in/out into coinbase
moneyintransactions = coinbaseoutput(coinbaseoutput.TransactionType=='Buy',:);
moneyinamounts = moneyintransactions.GBPTotalinclusiveOfFees;
moneyin = sum(moneyinamounts);
moneyout = 0;

%% Extract buy transaction data
coinbasebuy = coinbaseoutput(coinbaseoutput.TransactionType=='Buy',:);
gbpAsset = strings(height(coinbasebuy),1);
for i=1:height(coinbasebuy)
    gbpAsset(i) = "GBP";
end
gbpAsset = categorical(gbpAsset);
buytransactions = table(...
    coinbasebuy.Timestamp,...
    coinbasebuy.Asset,...
    coinbasebuy.QuantityTransacted,...
    coinbasebuy.GBPSpotPriceAtTransaction,...
    coinbasebuy.GBPSubtotal,...
    gbpAsset,...
    coinbasebuy.GBPFees,...
    ones(size(gbpAsset)),...
    coinbasebuy.GBPFees,...
    gbpAsset,...
    coinbasebuy.GBPTotalinclusiveOfFees,...
    ones(size(gbpAsset)),...
    coinbasebuy.GBPTotalinclusiveOfFees);
buytransactions = renamevars(buytransactions,fromColumnNames,toColumnNames);

%% Extract coinbase earn transaction data
coinbaseearn = coinbaseoutput(coinbaseoutput.TransactionType=='Coinbase Earn',:);
noneAsset = strings(height(coinbaseearn),1);
for i=1:height(coinbaseearn)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
earntransactions = table(...
    coinbaseearn.Timestamp,...
    coinbaseearn.Asset,...
    coinbaseearn.QuantityTransacted,...
    coinbaseearn.GBPSpotPriceAtTransaction,...
    coinbaseearn.GBPSubtotal,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
earntransactions = renamevars(earntransactions,fromColumnNames,toColumnNames);

%% Extract rewards income transaction data
coinbaserewards = coinbaseoutput(coinbaseoutput.TransactionType=='Rewards Income',:);
noneAsset = strings(height(coinbaserewards),1);
for i=1:height(coinbaserewards)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
yieldtransactions = table(...
    coinbaserewards.Timestamp,...
    coinbaserewards.Asset,...
    coinbaserewards.QuantityTransacted,...
    coinbaserewards.GBPSpotPriceAtTransaction,...
    coinbaserewards.GBPSubtotal,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
yieldtransactions = renamevars(yieldtransactions,fromColumnNames,toColumnNames);

%% Extract send transaction data
coinbasesend = coinbaseoutput(coinbaseoutput.TransactionType=='Send',:);
noneAsset = strings(height(coinbasesend),1);
for i=1:height(coinbasesend)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
sendtransactions = table(...
    coinbasesend.Timestamp,...
    noneAsset,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    coinbasesend.Asset,...
    coinbasesend.QuantityTransacted,...
    coinbasesend.GBPSpotPriceAtTransaction,...
    NaN(size(noneAsset)));
sendtransactions = renamevars(sendtransactions,fromColumnNames,toColumnNames);

%% Extract receive transaction data
coinbasereceive = coinbaseoutput(coinbaseoutput.TransactionType=='Receive',:);
noneAsset = strings(height(coinbasereceive),1);
for i=1:height(coinbasereceive)
    noneAsset(i) = 'None';
end
noneAsset = categorical(noneAsset);
receivetransactions = table(...
    coinbasereceive.Timestamp,...
    coinbasereceive.Asset,...
    coinbasereceive.QuantityTransacted,...
    coinbasereceive.GBPSpotPriceAtTransaction,...
    NaN(size(noneAsset)),...
    noneAsset,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)));
receivetransactions = renamevars(receivetransactions,fromColumnNames,toColumnNames);

%% Extract convert transaction data
coinbaseconvert = coinbaseoutput(coinbaseoutput.TransactionType=='Convert',:);
notes = coinbaseconvert.Notes;
noteParts = split(notes);
fromAssetStrings = noteParts(:,3);
fromAsset = categorical(fromAssetStrings);
fromQuantityStrings = noteParts(:,2);
fromQuantity = str2double(fromQuantityStrings);
toAssetStrings = noteParts(:,6);
toAsset = categorical(toAssetStrings);
toQuantityStrings = noteParts(:,5);
toQuantity = str2double(toQuantityStrings);
noneAsset = strings(height(coinbaseconvert),1);
for i=1:height(coinbaseconvert)
    noneAsset(i) = 'None';
end
noneAsset = categorical(noneAsset);
converttransactions = table(...
    coinbaseconvert.Timestamp,...
    toAsset,...
    toQuantity,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    fromAsset,...
    fromQuantity,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)));
converttransactions = renamevars(converttransactions,fromColumnNames,toColumnNames);

%% Clean up after extraction
clear i coinbasebuy coinbaseearn coinbaserewards fromColumnNames toColumnNames ...
    gbpAsset noneAsset coinbasesend coinbase receive coinbaseconvert ...
    coinbasereceive fromAsset notes noteParts toAsset toAssetStrings ...
    toQuantity toQuantityStrings fromQuantity fromQuantityStrings ...
    fromAssetStrings transactionTypes coinbaseoutput

%% Aggregate transactions
coinbase_transactions = [buytransactions; converttransactions; earntransactions; receivetransactions; sendtransactions; yieldtransactions];
coinbase_transactions = sortrows(coinbase_transactions,'Timestamp','ascend');
transactions_tt = table2timetable(coinbase_transactions,'RowTimes','Timestamp');

clear buytransactions converttransactions earntransactions receivetransactions ...
    sendtransactions yieldtransactions

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(coinbase_transactions.ToAsset); ...
    unique(coinbase_transactions.FeeAsset); ...
    unique(coinbase_transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(coinbase_transactions.Timestamp);
dates = datetime(y,m,d);
dates.Format = 'dd/MM/yy';
% Get a vector of all dates
dates = transpose(min(dates):max(dates));
% Construct array of holdings over time
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
    todayTransactions = coinbase_transactions(...
        coinbase_transactions.Timestamp >= date & ...
        coinbase_transactions.Timestamp < (date+1),:);
    
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
clear a d date m y todayTransactions toTransactions feeTransactions fromTransactions 

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
legend({'Coinbase'});
set(legend, 'location', 'best');
