{-# LANGUAGE CPP#-}
module Paths (getStaticDir, samplesURL) where

import Control.Monad
import System.FilePath

#if defined(CABAL)
-- using cabal
import qualified Paths_threepenny_gui (getDataDir)

getStaticDir :: IO FilePath
getStaticDir = (</> "app/static") `liftM` Paths_threepenny_gui.getDataDir

#elif defined(FPCOMPLETE)

getStaticDir :: IO FilePath
getStaticDir = return "app/static"

#else
-- using GHCi

getStaticDir :: IO FilePath
getStaticDir = return "static"

#endif

-- | Base URL for the example source code.
samplesURL :: String
samplesURL = ""