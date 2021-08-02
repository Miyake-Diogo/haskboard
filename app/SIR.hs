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

plotaSIR = print 
           $ take 10 
           $ sir 0.2 0.1 20000 100 0