function binanceoutput = ImportAllBinanceData()
%IMPORTALLBINANCEDATA Summary of this function goes here

% Import each binance file
binanceoutput202104 = ImportBinanceOutput('2021','04');
binanceoutput202105 = ImportBinanceOutput('2021','05');
binanceoutput202106 = ImportBinanceOutput('2021','06');
binanceoutput202107 = ImportBinanceOutput('2021','07');
binanceoutput202108 = ImportBinanceOutput('2021','08');

% Aggregate all binance files
binanceoutput = [...
    binanceoutput202104; ...
    binanceoutput202105; ...
    binanceoutput202106; ...
    binanceoutput202107; ...
    binanceoutput202108];

% Set the time format
binanceoutput.UTC_Time.Format = 'yyyy-MM-dd HH:mm:ss';

return
end