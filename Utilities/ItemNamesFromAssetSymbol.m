function itemNames = ItemNamesFromAssetSymbol(assetSymbol)
%ITEMNAMESFROMASSETSYMBOL Summary of this function goes here

itemNames = {};

% 
if (assetSymbol=='ZRX')
    % ...
elseif (assetSymbol=='1INCH')
    % ...
elseif (assetSymbol=='AAVE')
    itemNames = {'Aave (ACT-CC-ST-ACC)','Aave (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='ALGO')
    itemNames = {'Algorand (ACT-CC-ST-ACC)','Algorand (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='TLM')
    itemNames = {'Alien Worlds (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='AMP')
    itemNames = {'Amp (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='FORTH')
    itemNames = {'Ampleforth Governance Token (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='ARPA')
    % ...
elseif (assetSymbol=='REP')
    itemNames = {'Augur (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='ATA')
    % ...
elseif (assetSymbol=='BAL')
    itemNames = {'Balancer (ACT-CC-ST-ACC)','Balancer (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='BNT')
    % ...
elseif (assetSymbol=='BAND')
    itemNames = {'Band Protocol (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='BAT')
    % ...
elseif (assetSymbol=='BNB')
    % ...
elseif (assetSymbol=='BUSD')
    % ...
elseif (assetSymbol=='BTC')
    itemNames = {'Bitcoin (ACT-CC-HY-ACC)','Bitcoin (ACT-CC-ST-ACC)','Bitcoin (PAS-CC-LC-ACC)'};
elseif (assetSymbol=='ADA')
    itemNames = {'Cardano (ACT-CC-ST-ACC)','Cardano (PAS-CC-LC-ACC)'};
elseif (assetSymbol=='CGLD')
    itemNames = {'Celo (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='LINK')
    itemNames = {'Chainlink (ACT-CC-ST-ACC)','Chainlink (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='CHZ')
    % ...
elseif (assetSymbol=='COMP')
    % ...
elseif (assetSymbol=='ATOM')
    itemNames = {'Cosmos (PAS-CC-MC-ACC)'};
elseif (assetSymbol=='DAI')
    itemNames = {'Dai (ACT-CC-SY-ACC)'};
elseif (assetSymbol=='MANA')
    itemNames = {'Decentraland (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='DNT')
    % ...
elseif (assetSymbol=='DODO')
    % ...
elseif (assetSymbol=='ENJ')
    % ...
elseif (assetSymbol=='EOS')
    % ...
elseif (assetSymbol=='ETH')
    itemNames = {'Ethereum (ACT-CC-ST-ACC)','Ethereum (PAS-CC-LC-ACC)'};
elseif (assetSymbol=='FIL')
    % ...
elseif (assetSymbol=='GETH')
    % ...
elseif (assetSymbol=='INJ')
    % ...
elseif (assetSymbol=='ICP')
    % ...
elseif (assetSymbol=='KLAY')
    % ...
elseif (assetSymbol=='KSM')
    % ...
elseif (assetSymbol=='KNC')
    % ...
elseif (assetSymbol=='LTC')
    % ...
elseif (assetSymbol=='LRC')
    % ...
elseif (assetSymbol=='MKR')
    % ...
elseif (assetSymbol=='MDX')
    % ...
elseif (assetSymbol=='XMR')
    % ...
elseif (assetSymbol=='NEXO')
    % ...
elseif (assetSymbol=='NU')
    % ...
elseif (assetSymbol=='OMG')
    % ...
elseif (assetSymbol=='OXT')
    % ...
elseif (assetSymbol=='CAKE')
    % ...
elseif (assetSymbol=='DOT')
    % ...
elseif (assetSymbol=='MATIC')
    % ...
elseif (assetSymbol=='PROM')
    % ...
elseif (assetSymbol=='REN')
    % ...
elseif (assetSymbol=='SOL')
    % ...
elseif (assetSymbol=='XLM')
    % ...
elseif (assetSymbol=='SUSHI')
    % ...
elseif (assetSymbol=='CHSB')
    % ...
elseif (assetSymbol=='SNX')
    itemNames = {'Synthetix (PAS-CC-SC-ACC)'};
elseif (assetSymbol=='USDT')
    % ...
elseif (assetSymbol=='XTZ')
    % ...
elseif (assetSymbol=='GRT')
    % ...
elseif (assetSymbol=='THETA')
    % ...
elseif (assetSymbol=='UMA')
    % ...
elseif (assetSymbol=='UNI')
    % ...
elseif (assetSymbol=='USDC')
    % ...
elseif (assetSymbol=='UTK')
    % ...
elseif (assetSymbol=='VET')
    % ...
elseif (assetSymbol=='VTHO')
    % ...
elseif (assetSymbol=='VITE')
    % ...
elseif (assetSymbol=='XRP')
    % ...
elseif (assetSymbol=='YFI')
    % ...
elseif (assetSymbol=='GBP')
    disp('Partially handled asset symbol:');
    disp(assetSymbol);
    itemNames = {'GBP'};
elseif (assetSymbol=='None')
    disp('Partially handled asset symbol:');
    disp(assetSymbol);
    itemNames = {'NONE'};
else
    disp('UNHANDLED ASSET SYMBOL:');
    disp(assetSymbol);
    
end

return
end

