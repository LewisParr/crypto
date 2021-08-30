function trendIntensity = CalculateTrendIntensityIndex(series, lookback)
%CALCULATETRENDINTENSITYINDEX Measures trend intensity as a pcent
% of prices that are above the moving average in a period.

% Calculate moving average
movingAverage = movmean(series, [lookback-1 0]);

% Calculate deviations of market price from moving average
deviation = series - movingAverage;

% Calculate trend intensity index
trendIntensity = NaN(length(deviation), 1);
for i = lookback:length(deviation)
    deviationWindow = deviation(i-lookback+1:i);
    numPosInWindow = sum( deviationWindow > 0 );
    trendIntensity(i) = (numPosInWindow/length(deviationWindow))*100;
end

return

end

