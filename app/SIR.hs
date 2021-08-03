{-# language OverloadedStrings #-}

module SIR where
import Graphics.Vega.Vegalite


sir :: Double -> Double -> Double -> Double -> Double -> [[Double]]
sir beta gamma s i r = go (s/n) (i/n) (r/n)
    where
        n = s + i + r
        go s i r = [s,i,r] : go s' i' r'
            where
                s'= s - si
                i'= i + si -  ir
                r'= r + ir
                si = beta*s*i
                ir = gamma*i 

geraDados :: Int -> [[Double]] -> [DataColumn] -> Data
geraDados n dados = dataFromColumns []
                    . dataColumn "Dia" (Numbers eixoX)
                    . dataColumn "Casos" (Numbers eixoY)
                    . dataColumns "SIR" (Strings grupos)
                        where
                            eixoX = concat $ take n [[x,x,x] | x <- [1 ..]]
                            eixoY = concat $ take n dados
                            grupos = concat $ replicate n ["S", "I", "R"] -- take n $ repeat == replicate n

enc = encoding 
      . position X [ PName "Dia", PmType Quantitative ]
      . position Y [ PName "Casos", PmType Quantitative ]
      . color [ MName "SIR", MmType Nominal, Mlegend [LLabelFontSize 32, LtitleFontSize 40 ] ]
      . tooltip [ TName "Casos", TmType Quantitative ]

dados = geraDados 365 $ sir 0.2 0.1 20000 100 0

plotaSIR = toHtmlFile "SIR.html" 
           $ toVegaLite [ dados [], mark Line [MStrokeWidth 10], enc [], height 800, width 800] 