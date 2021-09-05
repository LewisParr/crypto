%% Add paths
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data');
addpath('C:\Users\lparr\Documents\MATLAB\crypto\Data\Trading');

%% Import all nexo files
nexooutput202107 = ImportNexoOutput('2021','07');
nexooutput202108 = ImportNexoOutput('2021','08');

%% Aggregate all nexo files
nexooutput = [nexooutput202107; nexooutput202108];

clear nexooutput202107 nexooutput202108

%% Get summaries
transactiontypes = unique(nexooutput.Type);

%% Prepare for extraction
fromColumnNames = {'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13'};
toColumnNames = {'Timestamp','ToAsset','ToQuantity','ToRate','ToTotal','FeeAsset','FeeQuantity','FeeRate','FeeTotal','FromAsset','FromQuantity','FromRate','FromTotal'};

%% Calculate total GBP in/out of nexo
moneyintransactions = nexooutput(nexooutput.Type=='ExchangeDepositedOn',:);
moneyinamounts = str2double(moneyintransactions.Amount);
moneyin = sum(moneyinamounts);
moneyout = 0;

%% Extract deposit transaction data
nexodeposit = nexooutput(nexooutput.Type=='Deposit',:);
noneAsset = strings(height(nexodeposit),1);
for i=1:height(nexodeposit)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
deposittransactions = table(...
    nexodeposit.DateTime,...
    nexodeposit.Currency,...
    str2double(nexodeposit.Amount),... % !!! USD USD USD !!!
    nexodeposit.USDEquivalent./str2double(nexodeposit.Amount),...
    nexodeposit.USDEquivalent,... % !!! USD USD USD !!!
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
deposittransactions = renamevars(deposittransactions,fromColumnNames,toColumnNames);

%% Extract interest transaction data
nexointerest = nexooutput(nexooutput.Type=='Interest',:);
noneAsset = strings(height(nexointerest),1);
for i=1:height(nexointerest)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
interesttransactions = table(...
    nexointerest.DateTime,...
    nexointerest.Currency,...
    str2double(nexointerest.Amount),... % !!! USD USD USD !!! 
    nexointerest.USDEquivalent./str2double(nexointerest.Amount),...
    nexointerest.USDEquivalent,... % !!! USD USD USD !!!
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)));
interesttransactions = renamevars(interesttransactions,fromColumnNames,toColumnNames);

%% Extract exchange transaction data
nexoexchange = nexooutput(nexooutput.Type=='Exchange',:);
noneAsset = strings(height(nexoexchange),1);
for i=1:height(nexoexchange)
    noneAsset(i) = "None";
end
noneAsset = categorical(noneAsset);
amountSplits = split(nexoexchange.Amount," / ");
amounts = str2double(amountSplits);
currencies = split(cellstr(nexoexchange.Currency),"/");
exchangetransactions = table(...
    nexoexchange.DateTime,...
    categorical(currencies(:,2)),...
    amounts(:,2),... % !!! USD USD USD !!! 
    nexoexchange.USDEquivalent./amounts(:,2),...
    nexoexchange.USDEquivalent,... % !!! USD USD USD !!! 
    noneAsset,...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    zeros(size(noneAsset)),...
    categorical(currencies(:,1)),...
    amounts(:,1),... % !!! USD USD USD !!! 
    nexoexchange.USDEquivalent./amounts(:,1),...
    nexoexchange.USDEquivalent); % !!! USD USD USD !!! 
exchangetransactions = renamevars(exchangetransactions,fromColumnNames,toColumnNames);

%% Ignoring transaction types:
% WithdrawalCredit
% TransferOut
% ExchangeDepositedOn
% DepositToExchange
% LockingTermDeposit

%% Clean up after extraction
clear fromColumnNames toColumnNames i nexodeposit nexointerest ...
    noneAsset nexooutput currencies amounts amountSplits nexoexchange

%% Aggregate transactions
nexo_transactions = [deposittransactions; interesttransactions; exchangetransactions];
nexo_transactions = sortrows(nexo_transactions,'Timestamp','ascend');
transactions_tt = table2timetable(nexo_transactions,'RowTimes','Timestamp');

convertdates = nexo_transactions.Timestamp;
toRate = nexo_transactions.ToRate;
toTotal = nexo_transactions.ToTotal;
feeRate = nexo_transactions.FeeRate;
feeTotal = nexo_transactions.FeeTotal;
fromRate = nexo_transactions.FromRate;
fromTotal = nexo_transactions.FromTotal;
usdcgbp = ReadHistoricalPrice_CoinCodex('usdcgbp');
gbpusd = 0.72;
for i=1:length(convertdates)
    date = convertdates(i);
    [y,m,d] = ymd(date);
    date = datetime(y,m,d);
    ii = find(usdcgbp.Date==date);
    if (ii>=1)
        gbpusd = usdcgbp.Close(ii);
    end
    
    toRate(i) = toRate(i) * gbpusd;
    toTotal(i) = toTotal(i) * gbpusd;
    feeRate(i) = feeRate(i) * gbpusd;
    feeTotal(i) = feeTotal(i) * gbpusd;
    fromRate(i) = fromRate(i) * gbpusd;
    fromTotal(i) = fromTotal(i) * gbpusd;
end
nexo_transactions.ToRate = toRate;
nexo_transactions.ToTotal = toTotal;
nexo_transactions.FeeRate = feeRate;
nexo_transactions.FeeTotal = feeTotal;
nexo_transactions.FromRate = fromRate;
nexo_transactions.FromTotal = fromTotal;

clear d date feeRate feeTotal fromRate fromTotal gbpusd i ii m ...
    toRate toTotal y usdcgbp convertdates deposittransactions ...
    exchangetransactions interesttransactions

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(nexo_transactions.ToAsset);...
    unique(nexo_transactions.FeeAsset);...
    unique(nexo_transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(nexo_transactions.Timestamp);
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
    todayTransactions = nexo_transactions(...
        nexo_transactions.Timestamp >= date & ...
        nexo_transactions.Timestamp < (date+1),:);
    
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
    
    if (or(assetSymbol=='GBP',assetSymbol=='GBPX'))
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

clear a assetgbp assetPrice assetSymbol d date holdingvalue market ...
    priceIndex

%% Plot total holding value over time
clf;
plot(dates, sum(holdingvalues,2));
title('Total Holding Value');
xlabel('Date');
ylabel('GBP');
legend({'Nexo'});
set(legend, 'location', 'best');
