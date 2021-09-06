function [currentholdingvalues,currenttotalholdings] = ...
    PlotHoldingsValueOverTime(holdingvalues,assets,dates,individual,total)
%PLOTHOLDINGSVALUEOVERTIME Summary of this function goes here

% Initialise
clf;

% Plot individual asset values
if (individual)
    hold on
    for a=1:length(assets)

        % Plot this asset's value
        plot(dates,holdingvalues(:,a),'--');
    end
end

% Plot total asset value
if (total)
    plot(dates,sum(holdingvalues,2),'k-');
    hold off
end

% Legend
legend(assets);
set(legend,'location','best');

% Return current values
currentholdingvalues = holdingvalues(end,:);
currenttotalholdings = sum(currentholdingvalues);

end

