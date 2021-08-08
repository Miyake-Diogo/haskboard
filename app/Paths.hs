{-# LANGUAGE CPP#-}
module Paths (getStaticDir, samplesURL) where

import Control.Monad
import System.FilePath

#if defined(CABAL)
-- using cabal
import qualified Paths_threepenny_gui (getDataDir)

getStaticDir :: IO FilePath
getStaticDir = (</> "HASKBOARD/plots") `liftM` Paths_threepenny_gui.getDataDir

#elif defined(FPCOMPLETE)

getStaticDir :: IO FilePath
getStaticDir = return "HASKBOARD/plots"

#else
-- using GHCi

getStaticDir :: IO FilePath
getStaticDir = return "plots"

#endif

-- | Base URL for the example source code.
samplesURL :: String
samplesURL = "https://github.com/HeinrichApfelmus/threepenny-gui/blob/master/samples/"