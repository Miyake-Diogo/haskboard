{-# language OverloadedStrings #-}
module Santos where

import Data.List.Split
import qualified Data.Text as T
import Graphics.Vega.VegaLite hiding (repeat)

ax = PAxis [AxLabelFontSize 14, AxTitleFontSize 18]

enc = encoding
        . position X [ PName "Dia", PmType Quantitative, ax]
        . position Y [ PName "Casos", PmType Quantitative, ax]

sel = selection
        . select "line" Single [ On "mouseover", Nearest True ]

encHover = encoding
             . color [MSelectionCondition (Not (SelectionName "line"))
                         [MString "transparent"] [MString "grey"]
                     ]
             . tooltips [ [ TName "Casos", TmType Quantitative ]
                        , [ TName "Dia", TmType Quantitative ]
                        ]

layers = layer [asSpec [mark Line [MStrokeWidth 1] ]
               ,asSpec [mark Rule [], sel [], encHover []]]

geraDados eixoX eixoY = dataFromColumns []
                          . dataColumn "Dia" (Numbers eixoX)
                          . dataColumn "Casos" (Numbers eixoY)

parseCSV csv = (eixoX, eixoY)
  where
    linhas     = lines csv
    campos     = [splitOn "," linha | linha <- linhas]
    eixoX      = [0 .. length' campos]
    eixoY      = [read casos | (_:casos:_) <- campos]
    length' xs = fromIntegral (length xs)

mediaMovel n xs = replicate (n-1) 0 ++ mediaMovel' n xs

mediaMovel' :: Int -> [Double] -> [Double]
mediaMovel' n xs 
  | length xs < n = []
  | otherwise     = media : mediaMovel' n (tail xs)
  where
    media = sum (take n xs) / fromIntegral n

geraHtml nome dados titulo = toHtmlFile nome 
                           $ toVegaLite [ dados []
                                        , layers
                                        , enc []
                                        , altura
                                        , largura
                                        , tituloFormatado
                                        ]
  where
    altura          = height 800
    largura         = width  1400
    tituloFormatado = title titulo [TFontSize 18]

plotaSantos :: IO ()
plotaSantos = do
  csv <- readFile "covid.csv"
  let
    (eixoX, eixoY) = parseCSV csv
    eixoY'         = mediaMovel 7 eixoY -- take 6 (repeat 0)
    dados          = geraDados eixoX eixoY
    dados'         = geraDados eixoX eixoY'
  geraHtml "santos.html" dados "Novos casos diários em Santos"
  geraHtml "santosAvg.html" dados' "Novos casos diários em Santos (média móvel)"
