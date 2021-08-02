module Main where

import System.Environment
import SIR (plotaSIR)

-- plotaSIR
-- plotaSantos
-- PlotaSP cidade


parseArgs :: [String] -> IO ()
parseArgs ["SIR"] = plotaSIR
parseArgs ["Santos"] = print "Executar Santos"
parseArgs ["SP", cidade] = print ("Executar SP com " ++ cidade)
parseArgs _ = putStrLn "Use: stack run {SIR|Santos|SP cidade}"


main :: IO ()
main = do
    args <- getArgs
    parseArgs args
