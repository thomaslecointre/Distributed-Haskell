module StatisticsMaster where

import Data.List

concatResult :: [String] -> [[[String]]]
concatResult [] = []
concatResult (x:l) = (read x :: [[String]]):(concatResult l)

{-
argument : "season,episode,[("word",occurence)]"
output : {"word1":occurence, "word2":occurence, ...}
ex : "1,1,[(\"a\",1),(\"b\",2)]" -> {"a":1,"b":2}
-}
episodeToJSON :: String -> String
episodeToJSON e =
    let wordOccurrence = read $ dropWhile (/='[') e :: [(String, Int)] in
    "{" ++ (concat $ intersperse "," $ map (\(w,o) -> show w ++ ":" ++ show o) wordOccurrence) ++ "}"

{-
argument : [["season,episode,[("word",occurence)]"]]
output : ["seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}] ] 
ex : [["1,1,[(\"a\",1),(\"b\",2)]","1,2,[(\"c\",1),(\"d\",2)]"],["2,1,[(\"e\",1),(\"f\",2)]","2,2,[(\"g\",1),(\"h\",2)]"]] -> ["1":[{"a":1,"b":2},{"c":1,"d":2}], "2":[{"f":1,"g":2,"h":3},{"i":1,"j":2}]]
-}
seasonToJSON :: [[String]] -> Int -> [String]
seasonToJSON [] _ = []
seasonToJSON (x:l) n = ((show $ show n) ++ ":[" ++ (concat $ intersperse "," $ map episodeToJSON x) ++ "]"):(seasonToJSON l (n+1))

{-
argument : [[["season,episode,[("word",occurence)]"]]]
output : { "seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}], "seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}] }
ex : ["[[\"1,1,[(\\\"a\\\",1),(\\\"b\\\",2),(\\\"c\\\",3)]\",\"1,2,[(\\\"d\\\",1),(\\\"e\\\",2)]\"],[\"2,1,[(\\\"f\\\",1),(\\\"g\\\",2),(\\\"h\\\",3)]\",\"2,2,[(\\\"i\\\",1),(\\\"j\\\",2)]\"]]","[[\"3,1,[(\\\"k\\\",1),(\\\"l\\\",2)]\",\"3,2,[(\\\"m\\\",1),(\\\"n\\\",2)]\"],[\"4,1,[(\\\"o\\\",1),(\\\"p\\\",2)]\",\"4,2,[(\\\"q\\\",1),(\\\"r\\\",2)]\"]]"] -> {"1":[{"a":1,"b":2,"c":3},{"d":1,"e":2}], "2":[{"f":1,"g":2,"h":3},{"i":1,"j":2}], "3":[{"k":1,"l":2},{"m":1,"n":2}], "4":[{"o":1,"p":2},{"q":1,"r":2}]}
-}
concatStatistics :: [String] -> String
concatStatistics listAllSlave =
    let listEachSlave = concatResult listAllSlave in
    let listEachSeason = sort $ concat listEachSlave in -- pour sort : vérifier qu'on ait bien "1,1,[(\"word\",1)]"
    "{" ++ concat (intersperse "," (seasonToJSON listEachSeason 1)) ++ "}"
