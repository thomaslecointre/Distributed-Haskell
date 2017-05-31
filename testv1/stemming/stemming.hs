-- http://stackoverflow.com/questions/21023201/displaying-the-stemming-word-and-the-stemming-using-haskell

import Data.List


stemming :: String -> String
stemming []        = []
stemming (x:"ing") = [x]
stemming (x:"ed")  = [x] 
stemming (x:"er")  = [x]
stemming (x:xs)    = x : stemming xs

-- Operate on a single word only.
hasStem :: String -> Bool
hasStem w = or $ zipWith isSuffixOf ["ed", "ing", "er"] $ repeat w

-- Let this function work on a list of words instead
removeStemmings :: [String] -> [String]
removeStemmings = map stemming

-- findWords now takes a sentence, splits into words, remove the stemmings,
-- zips with the original word list, and filters that list by which had stems
findWords :: String -> [(String, String)]
findWords sentence = filter (hasStem . fst) . zip ws $ removeStemmings ws
    where ws = words sentence

main :: IO ()
main = do
    sentence <- getLine
    print $ findWords sentence


{-
> findWords "he is a good fisher man. he is fishing and catched two fish"
[("fisher","fish"),("fishing","fish"),("catched","catch")]
-}