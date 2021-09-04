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
end

return
end

