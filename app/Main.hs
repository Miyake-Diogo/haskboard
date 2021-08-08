module Main where

import System.Environment

import SIR (plotaSIR)
import Santos (plotaSantos)
import SP (plotaSP)

parseArgs :: [String] -> IO ()
parseArgs ("SIR":_)       = plotaSIR
parseArgs ("Santos":_)    = plotaSantos
parseArgs ("SP":cidade:_) = plotaSP cidade
parseArgs _               = error "Uso: stack run {SIR|SP cidade|Santos}"

main :: IO ()
main = do
  args <- getArgs
  parseArgs args 
