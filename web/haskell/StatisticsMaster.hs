module StatisticsMaster where

import Data.List

-- |Transforms a list of String to a list of list of list of String
concatResult    :: [String]     -- ^ A list like ["[["season,episode,[("word",occurence)]"]]"]
                -> [[[String]]] -- ^ A list like [[["season,episode,[("word",occurence)]"]]]
concatResult [] = []
concatResult (x:l) = (read x :: [[String]]):(concatResult l)

-- |Takes a part of a String and creates a list of key-value for JSON like "season,episode,[("word",occurence)]" to {"word1":occurence, "word2":occurence, ...}
episodeToJSON   :: String   -- ^ A String like "1,1,[(\"a\",1),(\"b\",2)]"
                -> String   -- ^ A String like {"a":1,"b":2}
episodeToJSON e =
    let wordOccurrence = read $ dropWhile (/='[') e :: [(String, Int)] in
    "{" ++ (concat $ intersperse "," $ map (\(w,o) -> show w ++ ":" ++ show o) wordOccurrence) ++ "}"

-- |Creates a key-value for a list of list taking [["season,episode,[("word",occurence)]"]] and returning ["seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}] ] 
seasonToJSON    :: [[String]]   -- ^ A list like [["1,1,[(\"a\",1),(\"b\",2)]","1,2,[(\"c\",1),(\"d\",2)]"], ["2,1,[(\"e\",1),(\"f\",2)]","2,2,[(\"g\",1),(\"h\",2)]"]]
                -> Int          -- ^ The key of the head of the list
                -> [String]     -- ^ A list like ["1":[{"a":1,"b":2},{"c":1,"d":2}], "2":[{"f":1,"g":2,"h":3},{"i":1,"j":2}]]
seasonToJSON [] _ = []
seasonToJSON (x:l) n = ((show $ show n) ++ ":[" ++ (concat $ intersperse "," $ map episodeToJSON x) ++ "]"):(seasonToJSON l (n+1))

-- |Transforms a list of String to a list of [[String]], extracts some information and creates a JSON content like [[["season,episode,[("word",occurence)]"]]] to { "seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}], "seasonNumber":[{"word1":occurence, "word2":occurence, ...}, {"word1":occurence, "word2":occurence, ...}] }
concatStatistics    :: [String] -- ^ A list like ["[[\"1,1,[(\\\"a\\\",1),(\\\"b\\\",2),(\\\"c\\\",3)]\",\"1,2,[(\\\"d\\\",1),(\\\"e\\\",2)]\"],[\"2,1,[(\\\"f\\\",1),(\\\"g\\\",2),(\\\"h\\\",3)]\",\"2,2,[(\\\"i\\\",1),(\\\"j\\\",2)]\"]]","[[\"3,1,[(\\\"k\\\",1),(\\\"l\\\",2)]\",\"3,2,[(\\\"m\\\",1),(\\\"n\\\",2)]\"],[\"4,1,[(\\\"o\\\",1),(\\\"p\\\",2)]\",\"4,2,[(\\\"q\\\",1),(\\\"r\\\",2)]\"]]"]
                    -> String   -- ^ A list like {"1":[{"a":1,"b":2,"c":3},{"d":1,"e":2}], "2":[{"f":1,"g":2,"h":3},{"i":1,"j":2}], "3":[{"k":1,"l":2},{"m":1,"n":2}], "4":[{"o":1,"p":2},{"q":1,"r":2}]}
concatStatistics listAllSlave =
    let listEachSlave = concatResult listAllSlave in
    let listEachSeason = sort $ concat listEachSlave in
    "{" ++ concat (intersperse "," (seasonToJSON listEachSeason 1)) ++ "}"
