function currentholdings = PlotHoldingsOverTime(dates,holdings,assets)
%PLOTHOLDINGSOVERTIME Summary of this function goes here

% Initialise
clf;

% Plot
plot(dates, holdings);

% Legend
legend(assets);
set(legend,'location','best');

% Return current values
currentholdings = holdings(end,:);

return
end

