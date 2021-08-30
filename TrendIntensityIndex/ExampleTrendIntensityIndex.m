%% Import data
btcusd = ReadHistoricalBTCUSD_CoinCodex();
btcusd_date = flipud(btcusd.Date);
btcusd_close = flipud(btcusd.Close);

%% Parameters
lookback = 30;

%% Calculate
trendIntensity = CalculateTrendIntensityIndex(btcusd_close,lookback);

%% Plot
clf;
tiledlayout(4, 1);
nexttile([3 1]);
hold on
plot(btcusd_date,log(btcusd_close),'k');
plot(btcusd_date,log(movmean(btcusd_close, [lookback-1 0])),'r');
hold off
title('BTCUSD Close');
xlabel('Date');
ylabel('USD (log)');
legend({'Price','Moving Average'});
set(legend, 'location', 'best');
nexttile(4);
plot(btcusd_date,trendIntensity,'b');
xlabel('Date');
ylabel('Trend Intensity Index');