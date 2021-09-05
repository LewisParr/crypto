%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');

%% Import all binance files
binanceoutput202104 = ImportBinanceOutput('2021','04');
binanceoutput202105 = ImportBinanceOutput('2021','05');
binanceoutput202106 = ImportBinanceOutput('2021','06');
binanceoutput202107 = ImportBinanceOutput('2021','07');
binanceoutput202108 = ImportBinanceOutput('2021','08');

%% Aggregate all binance files
binanceoutput = [binanceoutput202104; binanceoutput202105; ...
    binanceoutput202106; binanceoutput202107; binanceoutput202108];
binanceoutput.UTC_Time.Format = 'yyyy-MM-dd HH:mm:ss';

clear binanceoutput202104 binanceoutput202105 binanceoutput202106 opts ...
    binanceoutput202107 binanceoutput202108

%% Get summaries 
transactionTypes = unique(binanceoutput.Operation);

%% Prepare for extraction
fromColumnNames = {'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13'};
toColumnNames = {'Timestamp','ToAsset','ToQuantity','ToRate','ToTotal','FeeAsset','FeeQuantity','FeeRate','FeeTotal','FromAsset','FromQuantity','FromRate','FromTotal'};

%% Calculate total GBP in/out of binance
moneyintransactions = binanceoutput(binanceoutput.Operation=='Deposit',:);
moneyintransactions = moneyintransactions(moneyintransactions.Coin=='GBP',:);
moneyinamounts = moneyintransactions.Change;
moneyin = sum(moneyinamounts);
moneyout = 0;

%% Extract buy/sell/fee transaction data
binancebuy = binanceoutput(binanceoutput.Operation=='Buy',:);
noneAsset = strings(height(binancebuy),1);
for i=1:height(binancebuy)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
buytransactions = table(...
    binancebuy.UTC_Time,...
    binancebuy.Coin,...
    abs(binancebuy.Change),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
buytransactions = renamevars(buytransactions,fromColumnNames,toColumnNames);
binancefee = binanceoutput(binanceoutput.Operation=='Fee',:);
noneAsset = strings(height(binancefee),1);
for i=1:height(binancefee)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
feetransactions = table(...
    binancefee.UTC_Time,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    binancefee.Coin,...
    abs(binancefee.Change),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
feetransactions = renamevars(feetransactions,fromColumnNames,toColumnNames);
%binancesell = binanceoutput(binanceoutput.Operation=='Transaction Related',:);
x = binanceoutput(binanceoutput.Operation=='Transaction Related',:);
y = binanceoutput(binanceoutput.Operation=='Sell',:);
binancesell = [x; y];
noneAsset = strings(height(binancesell),1);
for i=1:height(binancesell)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
selltransactions = table(...
    binancesell.UTC_Time,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    binancesell.Coin,...
    abs(binancesell.Change),...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)));
selltransactions = renamevars(selltransactions,fromColumnNames,toColumnNames);

%% Extract commission history transactions
binancecomhist = binanceoutput(binanceoutput.Operation=='Commission History',:);
noneAsset = strings(height(binancecomhist),1);
for i=1:height(binancecomhist)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
comhisttransactions = table(...
    binancecomhist.UTC_Time,...
    binancecomhist.Coin,...
    binancecomhist.Change,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
comhisttransactions = renamevars(comhisttransactions,fromColumnNames,toColumnNames);

%% Extract reward transaction data
a = binanceoutput(binanceoutput.Operation=='Rewards Distribution',:);
b = binanceoutput(binanceoutput.Operation=='POS savings interest',:);
c = binanceoutput(binanceoutput.Operation=='Savings Interest',:);
d = binanceoutput(binanceoutput.Operation=='Launchpool Interest',:);
binanceyield = [a; b; c; d];
noneAsset = strings(height(binanceyield),1);
for i=1:height(binanceyield)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
yieldtransactions = table(...
    binanceyield.UTC_Time,...
    binanceyield.Coin,...
    binanceyield.Change,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
yieldtransactions = renamevars(yieldtransactions,fromColumnNames,toColumnNames);

%% Extract deposit transaction data
binancedeposit = binanceoutput(binanceoutput.Operation=='Deposit',:);
% Remove deposits of GBP so that we have P&L
binancedeposit = binancedeposit(binancedeposit.Coin~='GBBP',:);
noneAsset = strings(height(binancedeposit),1);
for i=1:height(binancedeposit)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
deposittransactions = table(...
    binancedeposit.UTC_Time,...
    binancedeposit.Coin,...
    binancedeposit.Change,...
    NaN(size(noneAsset)),...
    NaN(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
deposittransactions = renamevars(deposittransactions,fromColumnNames,toColumnNames);

%% Skipping transaction types:
% POS savings purchase
% Savings purchase
% POS savings redemption
% Savings Principal redemption

%% Clean up after extraction
clear a b binancebuy binancecomhist binancedeposit binancefee ...
    binanceoutput binancesell binanceyield c d fromColumnNames ...
    toColumnNames i noneAsset x y

%% Aggregate transactions
binance_transactions = [buytransactions; comhisttransactions; ...
    deposittransactions; feetransactions; selltransactions; ...
    yieldtransactions];
binance_transactions = sortrows(binance_transactions,'Timestamp','ascend');
transactions_tt = table2timetable(binance_transactions,'RowTimes','Timestamp');

clear buytransactions comhisttransactions deposittransactions ...
    feetransactions selltransactions yieldtransactions

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(binance_transactions.ToAsset);...
    unique(binance_transactions.FeeAsset);...
    unique(binance_transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(binance_transactions.Timestamp);
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
    todayTransactions = binance_transactions(...
        binance_transactions.Timestamp >= date & ...
        binance_transactions.Timestamp < (date+1),:);
    
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
legend({'Binance'});
set(legend, 'location', 'best');