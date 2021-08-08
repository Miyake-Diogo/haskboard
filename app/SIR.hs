{-# language OverloadedStrings #-}
module SIR where

import Graphics.Vega.VegaLite hiding (repeat)

enc = encoding
        . position X [ PName "Dia", PmType Quantitative ]
        . position Y [ PName "Casos", PmType Quantitative ]
        . color [ MName "SIR", MmType Nominal, MLegend [LLabelFontSize 32, LTitleFontSize 40] ]
        . tooltip [ TName "Casos", TmType Quantitative ]

sir :: Double -> Double -> Double -> Double -> Double -> [[Double]]
sir beta gamma s i r = go (s/n) (i/n) (r/n)
  where
    n        = s+i+r
    go s i r = [s, i, r] : go (s - si) (i + si - ir) (r +ir)
      where
        si = beta*s*i
        ir = gamma*i

geraDados n dados = dataFromColumns []
                     . dataColumn "Dia" (Numbers eixoX)
                     . dataColumn "Casos" (Numbers eixoY)
                     . dataColumn "SIR" (Strings grupos)
  where
    eixoX  = take n $ concatMap (\x -> [x,x,x]) [1 .. ]
    eixoY  = take n $ concat dados
    grupos = take n 
           $ concat
           $ repeat ["S","I","R"]

plotaSIR :: IO ()
plotaSIR = do
  let dados = geraDados 365 $ sir 0.2 0.1 20000 100 0
  toHtmlFile "SIR.html" $ toVegaLite [ dados [], mark Line [MStrokeWidth 10], enc [], height 800, width 800]
