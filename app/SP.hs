{-# language OverloadedStrings #-}
module SP where

import Prelude hiding (filter, lookup, repeat)

import qualified Data.Text as T
import Graphics.Vega.VegaLite

ax = PAxis [AxLabelFontSize 14, AxTitleFontSize 18]

encX = encoding 
         . position X [ PName "datahora", PmType Temporal, PTitle "Data", ax]

encY = encoding
         . position Y [ PName "casos_novos", PmType Quantitative, PTitle "Casos", ax]

sel = selection
        . select "line" Single [ On "mouseover", Nearest True ]

tr cidade = transform
              . filter (FExpr $ T.concat ["datum.nome_munic == '", cidade, "'"])
              . window [ ([WAggregateOp Mean, WField "casos_novos"], "CasosAvg") ] [WFrame (Just (-6)) (Just 0)]

encMean = encoding
            . position Y [ PName "CasosAvg", PmType Quantitative, PTitle "Casos (média móvel)", ax]

encHover = encoding
             . color [MSelectionCondition (Not (SelectionName "line"))
                         [MString "transparent"] [MString "grey"]
                     ]
             . tooltips [ [ TName "casos_novos", TmType Quantitative ]
                        , [ TName "CasosAvg", TmType Quantitative ]
                        , [ TName "datahora", TmType Temporal ]
                        ]

layers = layer [asSpec [mark Point [MOpacity 0.3], encY []]
               ,asSpec [mark Line [MStrokeWidth 3], encMean [] ]
               ,asSpec [mark Rule [], sel [], encHover []]]

endereco = "https://raw.githubusercontent.com/seade-R/dados-covid-sp/master/data/dados_covid_sp.csv"
    
altura  = height 700
largura = width 1800

dados = dataFromUrl endereco [DSV ';']

plotaSP :: String -> IO ()
plotaSP cidade = 
  toHtmlFile nomeHtml $ toVegaLite [ dados
                                   , tr cidade' []
                                   , largura
                                   , altura
                                   , encX []
                                   , layers
                                   , title titulo [TFontSize 18]
                                   ]
  where
    nomeHtml = concat ["covid_", cidade, ".html"]
    cidade'  = T.pack cidade
    titulo   = T.concat ["Novos casos diários (", cidade', ")"]
