{-# LANGUAGE DeriveGeneric #-}

module KeyWordOccurrence where

keyWordInList :: String -> [String] -> Int -> Int
keyWordInList _ [] n = n
keyWordInList keyword (x:l) n =
    if x == keyword
    then keyWordInList keyword l (n+1)
    else keyWordInList keyword l n

keyWordOccurrence :: String -> String -> Int
keyWordOccurrence keyword text = keyWordInList keyword (lines text) 0
