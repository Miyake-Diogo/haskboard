{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}

-- import Control.Applicative
import Control.Monad
-- import Data.IORef
-- import Data.Maybe
import Paths
import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core


-- | Main entry point.
main :: IO ()
main = startGUI defaultConfig
          { jsPort       = Just 10000 -- port map
          -- , jsStatic     = Just "../wwwroot" -- root address
          } setup

-- canvas size for make dashboards          
canvasWidth = 1024 
canvasHeight = 768


setup :: Window -> UI ()
setup window = do
    return window # set title "HASKELLBOARD :: HASKELL DASHBOARDS"

    canvas <- UI.canvas
        # set UI.height canvasHeight
        # set UI.width  canvasWidth
        # set style [("border", "solid black 1px"), ("background", "#eee")]

-- Buttons

    drawPieChart <- UI.button #+ [string "Insert pie chart!"]
    removePieChart <- UI.button #+ [string "Remove pie chart!"]
    drawLineChart <- UI.button #+ [string "Insert line chart!"]
    removeLineChart <- UI.button #+ [string "Remove line chart!"]
    drawHorizontalBarChart <- UI.button #+ [string "Insert horizaontal bar chart!"]
    removeHorizontalBarChart <- UI.button #+ [string "Insert horizaontal bar chart!"]
    drawVerticalBarChart <- UI.button #+ [string "Insert vertical bar chart!"]
    removeVerticalBarChart <- UI.button #+ [string "Insert vertical bar chart!"]

    clear     <- UI.button #+ [string "Clear the canvas."]

    dashboardNameInput <- UI.input # set (attr "placeholder") "Dashboard name"
    insertDashboardNameButton <- UI.button #+ [ string "Add Dashboard Name" ]

    getBody window #+
        [ column [element canvas]
        , element drawPieChart, element removePieChart
        , element drawLineChart, element removeLineChart
        , element drawHorizontalBarChart, element removeHorizontalBarChart
        , element drawVerticalBarChart, element removeVerticalBarChart
        , element clear, element dashboardNameInput, element insertDashboardNameButton
        ]

    -- draw dashboard name
    on UI.click insertDashboardNameButton $ const $ do
        return canvas
            # set UI.textFont    "50px sans-serif"
            # set UI.strokeStyle "gray"
            # set UI.fillStyle   (UI.htmlColor "black")

        canvas # UI.strokeText "DashBoard Name" (141,61)
        canvas # UI.fillText   "DashBoard Name" (140,60)

    -- Clear the canvas    
    on UI.click clear $ const $
        canvas # UI.clearCanvas

    -- draw the haskell logo
    url <- UI.loadFile "image/png" "SIR.png"
    img <- UI.img # set UI.src url

    on UI.click drawLineChart $ const $ do
        canvas # UI.drawImage img (120,120)
