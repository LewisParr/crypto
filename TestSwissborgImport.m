%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');

%% Import all swissborg files
swissborgoutput202101 = ImportSwissborgOutput('2021','01');
swissborgoutput202102 = ImportSwissborgOutput('2021','02');
swissborgoutput202103 = ImportSwissborgOutput('2021','03');
swissborgoutput202104 = ImportSwissborgOutput('2021','04');
swissborgoutput202105 = ImportSwissborgOutput('2021','05');
swissborgoutput202106 = ImportSwissborgOutput('2021','06');
swissborgoutput202107 = ImportSwissborgOutput('2021','07');
swissborgoutput202108 = ImportSwissborgOutput('2021','08');

%% Aggregate all swissborg files
swissborgoutput = [swissborgoutput202101; swissborgoutput202102; ...
    swissborgoutput202103; swissborgoutput202104; swissborgoutput202105;...
    swissborgoutput202106; swissborgoutput202107; swissborgoutput202108];

fromColumnNames = {'UserID','eadab5d997437b8f6f09c7ec5d211','VarName3','VarName4','VarName5','VarName6','VarName7','VarName8','VarName9','VarName10','VarName11'};
toColumnNames = {'Timestamp','UtcTimestamp','Type','Currency','GrossAmount','GrossAmountGbp','Fee','FeeGbp','NetAmount','NetAmountGbp','Note'};
swissborgoutput = renamevars(swissborgoutput,fromColumnNames,toColumnNames);

clear fromColumnNames toColumnNames swissborgoutput202101 ...
    swissborgoutput202102 swissborgoutput202103 swissborgoutput202104...
    swissborgoutput202105 swissborgoutput202106 swissborgoutput202107...
    swissborgoutput202108

%% Get summaries
transactiontypes = unique(swissborgoutput.Type);

%% Prepare for extraction
fromColumnNames = {'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13'};
toColumnNames = {'Timestamp','ToAsset','ToQuantity','ToRate','ToTotal','FeeAsset','FeeQuantity','FeeRate','FeeTotal','FromAsset','FromQuantity','FromRate','FromTotal'};

%% Calculate total GBP in/out into coinbase
moneyintransactions = swissborgoutput(swissborgoutput.Type=='Deposit',:);
moneyintransactions = moneyintransactions(moneyintransactions.Currency=='GBP',:);
moneyinamounts = moneyintransactions.GrossAmount;
moneyin = sum(moneyinamounts);
moneyouttransactions = swissborgoutput(swissborgoutput.Type=='Withdrawal',:);
moneyouttransactions = moneyouttransactions(moneyouttransactions.Currency=='GBP',:);
moneyoutamounts = moneyouttransactions.NetAmount;
moneyout = sum(moneyoutamounts);

%% Extract buy/sell transaction data
swissborgbuy = swissborgoutput(swissborgoutput.Type=='Buy',:);
% ... buy and sell are separate lines ...
noneAsset = strings(height(swissborgbuy),1);
for i=1:height(swissborgbuy)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
buytransactions = table(...
    swissborgbuy.Timestamp,...
    swissborgbuy.Currency,...
    swissborgbuy.NetAmount,...
    swissborgbuy.NetAmountGbp./swissborgbuy.NetAmount,...
    swissborgbuy.NetAmountGbp,...
    swissborgbuy.Currency,...
    swissborgbuy.Fee,...
    swissborgbuy.FeeGbp./swissborgbuy.Fee,...
    swissborgbuy.FeeGbp,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
buytransactions = renamevars(buytransactions,fromColumnNames,toColumnNames);
swissborgsell = swissborgoutput(swissborgoutput.Type=='Sell',:);
noneAsset = strings(height(swissborgsell),1);
for i=1:height(swissborgsell)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
selltransactions = table(...
    swissborgsell.Timestamp,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    swissborgsell.Currency,...
    swissborgsell.GrossAmount,...
    swissborgsell.GrossAmountGbp./swissborgsell.GrossAmount,...
    swissborgsell.GrossAmountGbp);
selltransactions = renamevars(selltransactions,fromColumnNames,toColumnNames);

%% Extract deposit transaction data
swissborgdeposit = swissborgoutput(swissborgoutput.Type=='Deposit',:);
% Remove deposits of GBP so that we have P&L
swissborgdeposit = swissborgdeposit(swissborgdeposit.Currency~='GBP',:);
noneAsset = strings(height(swissborgdeposit),1);
for i=1:height(swissborgdeposit)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
deposittransactions = table(...
    swissborgdeposit.Timestamp,...
    swissborgdeposit.Currency,...
    swissborgdeposit.NetAmount,...
    swissborgdeposit.NetAmountGbp./swissborgdeposit.NetAmount,...
    swissborgdeposit.NetAmountGbp,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
deposittransactions = renamevars(deposittransactions,fromColumnNames,toColumnNames);

%% Extract withdrawal transaction data
swissborgwithdrawal = swissborgoutput(swissborgoutput.Type=='Withdrawal',:);
% Remove GBP withdrawals because we removed GBP deposits
swissborgwithdrawal = swissborgwithdrawal(swissborgwithdrawal.Currency~='GBP',:);
noneAsset = strings(height(swissborgwithdrawal),1);
for i=1:height(swissborgwithdrawal)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
withdrawaltransactions = table(...
    swissborgwithdrawal.Timestamp,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    swissborgwithdrawal.Currency,...
    swissborgwithdrawal.Fee,...
    swissborgwithdrawal.FeeGbp./swissborgwithdrawal.Fee,...
    swissborgwithdrawal.FeeGbp,...
    swissborgwithdrawal.Currency,...
    swissborgwithdrawal.NetAmount,...
    swissborgwithdrawal.NetAmountGbp./swissborgwithdrawal.NetAmount,...
    swissborgwithdrawal.NetAmountGbp);
withdrawaltransactions = renamevars(withdrawaltransactions,fromColumnNames,toColumnNames);

%% Extract earnings transaction data
swissborgearnings = swissborgoutput(swissborgoutput.Type=='Earnings',:);
noneAsset = strings(height(swissborgearnings),1);
for i=1:height(swissborgearnings)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
earningstransactions = table(...
    swissborgearnings.Timestamp,...
    swissborgearnings.Currency,...
    swissborgearnings.NetAmount,...
    swissborgearnings.NetAmountGbp./swissborgearnings.NetAmount,...
    swissborgearnings.NetAmountGbp,...
    swissborgearnings.Currency,...
    swissborgearnings.Fee,...
    swissborgearnings.FeeGbp./swissborgearnings.Fee,...
    swissborgearnings.FeeGbp,...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
earningstransactions = renamevars(earningstransactions,fromColumnNames,toColumnNames);

%% Clean up after extraction
clear fromColumnNames toColumnNames i swissborgbuy swissborgsell ...
    swissborgearnings swissborgdeposit swissborgwithdrawal ...
    swissborgoutput noneAsset 

%% Aggregate transactions 
swissborg_transactions = [buytransactions; selltransactions; deposittransactions; withdrawaltransactions; earningstransactions];
swissborg_transactions = sortrows(swissborg_transactions,'Timestamp','ascend');
transactions_tt = table2timetable(swissborg_transactions,'RowTimes','Timestamp');

swissborg_transactions.ToRate(isnan(swissborg_transactions.ToRate))=0;
swissborg_transactions.FeeRate(swissborg_transactions.FeeRate==Inf)=0;
swissborg_transactions.FeeRate(isnan(swissborg_transactions.FeeRate))=0;

clear buytransactions deposittransactions earningstransactions ...
    selltransactions withdrawaltransactions transactiontypes

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(swissborg_transactions.ToAsset);...
    unique(swissborg_transactions.FeeAsset);...
    unique(swissborg_transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(swissborg_transactions.Timestamp);
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
    todayTransactions = swissborg_transactions(...
        swissborg_transactions.Timestamp >= date & ...
        swissborg_transactions.Timestamp < (date+1),:);
    
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
legend({'Swissborg'});
set(legend, 'location', 'best');
