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


-- Insert a title for dashbaord
greet :: [UI Element]
greet =
    [ UI.h1  #+ [string "My Haskboard"]
    ]        

-- canvas size for make dashboards          
canvasWidth = 1024 
canvasHeight = 768



setup :: Window -> UI ()
setup window = do
    return window # set title "HASKELLBOARD :: HASKELL DASHBOARDS"
    
    getBody window #+
        [UI.div #. "wrap" #+ (greet)]

    canvas <- UI.canvas
        # set UI.height canvasHeight
        # set UI.width  canvasWidth
        # set style [("border", "solid black 1px"), ("background", "#eee")]

-- Buttons

    drawPieChart <- UI.button #+ [string "Insert pie chart!"]
    drawLineChart <- UI.button #+ [string "Insert line chart!"]
    drawHorizontalBarChart <- UI.button #+ [string "Insert horizaontal bar chart!"]
    drawVerticalBarChart <- UI.button #+ [string "Insert vertical bar chart!"]
    clear     <- UI.button #+ [string "Clear the canvas."]

    dashboardNameInput <- UI.input # set (attr "placeholder") "Dashboard name"
    insertDashboardNameButton <- UI.button #+ [ string "Add Dashboard Name" ]

    getBody window #+
        [ column [element canvas]
        , element drawPieChart
        , element drawLineChart
        , element drawHorizontalBarChart
        , element drawVerticalBarChart
        , element clear
        ]



    -- draw the Line Chart
    url <- UI.loadFile "image/png" "static/SIR.png"
    img <- UI.img # set UI.src url

    on UI.click drawLineChart $ const $ do
        canvas # UI.drawImage img (10,10)

    -- Clear the canvas    
    on UI.click clear $ const $
        canvas # UI.clearCanvas
