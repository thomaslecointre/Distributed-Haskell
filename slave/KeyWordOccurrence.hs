{-# LANGUAGE DeriveGeneric #-}
{-|
Module      : KeyWordOccurrence
Description : Returns the number of occurrence of a keyword in a text where each word is on a new line
Copyright   : (c) Thomas Lecointre, 2017
                  Thomas Perles, 2017
License     : MIT
Maintainer  :   thomas.lecointre@uha.fr
                thomas.perles@uha.fr
Stability   : experimental
Portability : Windows

We use this module to count the number of occurrences of a keyword in a text

-}
module KeyWordOccurrence where

-- |Returns the number of occurrence of a keyword in a list
keyWordInList   :: String   -- ^ The keyword
                -> [String] -- ^ The list
                -> Int      -- ^ The number of occurrence already found
                -> Int      -- ^ The number of occurrence of the keyword in the list
keyWordInList _ [] n = n
keyWordInList keyword (x:l) n =
    if x == keyword
    then keyWordInList keyword l (n+1)
    else keyWordInList keyword l n

-- |Returns the number of occurrence of a keyword in a text where each word is on a new line
keyWordOccurrence   :: String   -- ^ The keyword
                    -> String   -- ^ The text where each word is on a new line
                    -> Int      -- ^ The number of occurrence of the keyword in the text
keyWordOccurrence keyword text = keyWordInList keyword (lines text) 0
