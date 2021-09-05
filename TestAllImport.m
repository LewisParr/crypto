%% Collect
TestCoinbaseImport;
coinbasedates = dates;
coinbaseholdings = holdings;
coinbaseholdingvalues = holdingvalues;
coinbasetotalvalue = sum(holdingvalues,2);

TestSwissborgImport;
swissborgdates = dates;
swissborgholdings = holdings;
swissborgholdingvalues = holdingvalues;
swissborgtotalvalue = sum(holdingvalues,2);

%totalvalue = coinbasetotalvalue + swissborgtotalvalue;

%% Plot
clf;
hold on
plot(coinbasedates, coinbasetotalvalue);
plot(swissborgdates, swissborgtotalvalue);
%plot(dates, totalvalue);
hold off
title('Total Holding Value');
xlabel('Date');
ylabel('GBP');
legend({'Coinbase','Swissborg','Total'});
set(legend,'location','best');