function market = GbpMarketFromAssetSymbol(assetSymbol)
%GBPMARKETFROMASSETSYMBOL Summary of this function goes here

market = '';

if (assetSymbol=='BTC')
    market = 'btcgbp';
elseif (assetSymbol=='ADA')
    market = 'adagbp';
elseif (assetSymbol=='ALGO')
    market = 'algogbp';
elseif (assetSymbol=='ATOM')
    market = 'atomgbp';
elseif (assetSymbol=='BNB')
    market = 'bnbgbp';
elseif (assetSymbol=='BNBN')
    % Nexo BNB
    market = 'bnbgbp';
elseif (assetSymbol=='ETH')
    market = 'ethgbp';
elseif (assetSymbol=='ZRX')
    market = 'zrxgbp';
elseif (assetSymbol=='YFI')
    market = 'yfigbp';
elseif (assetSymbol=='XTZ')
    market = 'xtzgbp';
elseif (assetSymbol=='OXT')
    market = 'oxtgbp';
elseif (assetSymbol=='REP')
    market = 'repgbp';
elseif (assetSymbol=='SNX')
    market = 'snxgbp';
elseif (assetSymbol=='SUSHI')
    market = 'sushigbp';
elseif (assetSymbol=='OMG')
    market = 'omggbp';
elseif (assetSymbol=='NU')
    market = 'nugbp';
elseif (assetSymbol=='MKR')
    market = 'mkrgbp';
elseif (assetSymbol=='MANA')
    market = 'managbp';
elseif (assetSymbol=='UMA')
    market = 'umagbp';
elseif (assetSymbol=='LTC')
    market = 'ltcgbp';
elseif (assetSymbol=='XLM')
    market = 'xlmgbp';
elseif (assetSymbol=='LRC')
    market = 'lrcgbp';
elseif (assetSymbol=='UNI')
    market = 'unigbp';
elseif (assetSymbol=='LINK')
    market = 'linkgbp';
elseif (assetSymbol=='KNC')
    market = 'kncgbp';
elseif (assetSymbol=='GRT')
    market = 'grtgbp';
elseif (assetSymbol=='USDC')
    market = 'usdcgbp';
elseif (assetSymbol=='FIL')
    market = 'filgbp';
elseif (assetSymbol=='FORTH')
    market = 'forthgbp';
elseif (assetSymbol=='EOS')
    market = 'eosgbp';
elseif (assetSymbol=='AAVE')
    market = 'aavegbp';
elseif (assetSymbol=='BAL')
    market = 'balgbp';
elseif (assetSymbol=='BAND')
    market = 'bandgbp';
elseif (assetSymbol=='DNT')
    market = 'dntgbp';
elseif (assetSymbol=='DAI')
    market = 'daigbp';
elseif (assetSymbol=='COMP')
    market = 'compgbp';
elseif (assetSymbol=='BAT')
    market = 'batgbp';
elseif (assetSymbol=='BNT')
    market = 'bntgbp';
elseif (assetSymbol=='AMP')
    market = 'ampgbp';
elseif (assetSymbol=='CGLD')
    market = 'celogbp';
elseif (assetSymbol=='CHSB')
    market = 'chsbgbp';
elseif (assetSymbol=='REN')
    market = 'rengbp';
elseif (assetSymbol=='ENJ')
    market = 'enjgbp';
elseif (assetSymbol=='UTK')
    market = 'utkgbp';
elseif (assetSymbol=='CHZ')
    market = 'chzgbp';
elseif (assetSymbol=='USDT')
    market = 'usdtgbp';
elseif (assetSymbol=='XRP')
    market = 'xrpgbp';
elseif (assetSymbol=='GETH')
    % GETH historical prices are not available on CoinCodex, so use 
    % ETH instead
    market = 'ethgbp';
elseif (assetSymbol=='NEXONEXO')
    market = 'nexogbp';
elseif (assetSymbol=='USD')
    % Using USDC for USD conversions
    market = 'usdcgbp';
elseif (assetSymbol=='VITE')
    market = 'vitegbp';
elseif (assetSymbol=='VET')
    market = 'vetgbp';
elseif (assetSymbol=='TLM')
    market = 'tlmgbp';
elseif (assetSymbol=='THETA')
    market = 'thetagbp';
elseif (assetSymbol=='VTHO')
    market = 'vthogbp';
elseif (assetSymbol=='XMR')
    market = 'xmrgbp';
elseif (assetSymbol=='PROM')
    market = 'promgbp';
elseif (assetSymbol=='SOL')
    market = 'solgbp';
elseif (assetSymbol=='MDX')
    market = 'mdxgbp';
elseif (assetSymbol=='MATIC')
    market = 'maticgbp';
elseif (assetSymbol=='KSM')
    market = 'ksmgbp';
elseif (assetSymbol=='KLAY')
    market = 'klaygbp';
elseif (assetSymbol=='INJ')
    market = 'injgbp';
elseif (assetSymbol=='ICP')
    market = 'icpgbp';
elseif (assetSymbol=='DOT')
    market = 'dotgbp';
elseif (assetSymbol=='DODO')
    market = 'dodogbp';
elseif (assetSymbol=='CAKE')
    market = 'cakegbp';
elseif (assetSymbol=='BUSD')
    market = 'busdgbp';
elseif (assetSymbol=='ATA')
    market = 'atagbp';
elseif (assetSymbol=='ARPA')
    market = 'arpagbp';
elseif (assetSymbol=='1INCH')
    market = '1inchgbp';
elseif (assetSymbol=='NEO')
    market = 'neogbp';
elseif (assetSymbol=='GAS')
    market = 'gasgbp';
elseif (assetSymbol=='DUSK')
    market = 'duskgbp';
end

return
end

