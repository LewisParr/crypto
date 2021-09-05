%% Initialise
clf;
clear;
clc;

%% Collect coinbase
TestCoinbaseImport;
coinbasedates = dates;
coinbaseholdings = holdings;
coinbaseholdingvalues = holdingvalues;
coinbasetotalvalue = sum(holdingvalues,2);
coinbasemoneyin = moneyin;
coinbasemoneyout = moneyout;

%% Collect swissborg
TestSwissborgImport;
swissborgdates = dates;
swissborgholdings = holdings;
swissborgholdingvalues = holdingvalues;
swissborgtotalvalue = sum(holdingvalues,2);
swissborgmoneyin = moneyin;
swissborgmoneyout = moneyout;

%% Collect guarda
TestGuardaImport;
guardadates = dates;
guardaholdings = holdings;
guardaholdingvalues = holdingvalues;
guardatotalvalue = sum(holdingvalues,2);
guardamoneyin = 0;
guardamoneyout = 0;

%% Collect exodus
TestExodusImport;
exodusdates = dates;
exodusholdings = holdings;
exodusholdingvalues = holdingvalues;
exodustotalvalue = sum(holdingvalues,2);
exodusmoneyin = 0;
exodusmoneyout = 0;

%% Aggregate all transactions
transactions = [coinbase_transactions; swissborg_transactions; ...
    guarda_transactions; exodus_transactions];
transactions = sortrows(transactions,'Timestamp','ascend');

%% Compute holdings over time
% Get a list of all assets
assets = categorical(sort(string(unique([...
    unique(transactions.ToAsset);...
    unique(transactions.FeeAsset);...
    unique(transactions.FromAsset)]))));
% Get a list of all transaction dates
[y,m,d] = ymd(transactions.Timestamp);
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
    todayTransactions = transactions(...
        transactions.Timestamp >= date & ...
        transactions.Timestamp < (date+1),:);
    
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

%% Plot
clf;
tiledlayout(1, 5);

nexttile([1 4]);
hold on
plot(coinbasedates, coinbasetotalvalue, 'Color', '#2b6dd1');
plot(swissborgdates, swissborgtotalvalue, 'Color', '#70d12b');
plot(guardadates, guardatotalvalue, 'Color', '#2bbbd1');
plot(exodusdates, exodustotalvalue, 'Color', '#7e2bd1');
plot(dates, sum(holdingvalues,2), 'k');
hold off
title('Total Holding Value');
xlabel('Date');
ylabel('GBP');
legend({'Coinbase','Swissborg','Guarda','Exodus','Total'});
set(legend,'location','best');

nexttile(5);
cb = [coinbasemoneyin coinbasemoneyout];
sb = [swissborgmoneyin swissborgmoneyout];
g = [guardamoneyin guardamoneyout];
e = [exodusmoneyin exodusmoneyout];
money = transpose([cb; sb; g; e]);
b = bar(money, 'stacked');
b(1).FaceColor = '#2b6dd1';
b(2).FaceColor = '#70d12b';
%xlim([1 2]);
%xticklabels({'In','Out'});
%ylabel('GBP');
