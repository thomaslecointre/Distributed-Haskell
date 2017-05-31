module Statistics (main) where

import Data.List
import System.Environment


main = do
    args <- getArgs
    f <- readFile "tmp4.txt"
    let ws = lines f
    let ds = nub ws
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds
    let ts = map (\(m,c) -> "("++m++","++(show c)++")\n") rs
    let hs = concat ts
    writeFile "statistics.txt" hs
