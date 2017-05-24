module GetWordsFile (main) where

import System.Environment


separators = " \"',.\n"

cut :: String -> [String]
cut "" = []
cut t = 
 let w = takeWhile (\x -> notElem x separators) t
     r = dropWhile (\x -> elem x separators) (dropWhile (\x -> notElem x separators) t)
 in w:(cut r)

toLine :: String -> String
toLine s = unlines $ cut s


main :: IO ()
main = do
    args <- getArgs
    resume <- readFile (args !! 0)
    writeFile "tmp3.txt" (toLine resume)
-- dans cmd : runhaskell getWordsFile.hs -> tmp2.txt