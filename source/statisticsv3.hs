module Statisticsv3 where

import Data.List




--slave
data CloudEachEpisode = CloudEachEpisode { season :: Int, episode :: Int, cloud :: [(String, Int)]}

instance Show CloudEachEpisode where
  show (CloudEachEpisode a b c) = show a ++ ", " ++ show b ++ ", " ++ show c

{-
argument : (keyword, season, episode, text)
output : "season,episode,[("word",occurence)]"
ex : ("N/A",1,1,"a\nb\nb\nc\nc\nc") -> "1,1,[("a",1),("b",2),("c",3)]"
-}
statisticsSeasonEpisodeText :: (String, Int, Int, String) -> String
statisticsSeasonEpisodeText (_, s, e, text) =
    let ws = lines text in
    let ds = nub ws in
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds in
    show $ CloudEachEpisode {season = s, episode = e, cloud = rs}

{-
argument : [(keyword, season, episode, text)]
output : ["season,episode,[("word",occurence)]"]
ex : [("N/A",1,1,"a\nb\nb\nc\nc\nc"),("N/A",1,2,"d\ne\ne")] -> ["1,1,[("a",1),("b",2),("c",3)]","1,2,[("d",1),("e",2)]"]
-}
statisticsEachSeason :: [(String, Int, Int, String)] -> [String]
statisticsEachSeason [] = []
statisticsEachSeason l  = map statisticsSeasonEpisodeText l

{-
argument : [[(keyword, season, episode, text)]]
output : [["season,episode,[("word",occurence)]"]]
ex : [[("N/A",1,1,"a\nb\nb\nc\nc\nc"),("N/A",1,1,"d\ne\ne")],[("N/A",2,1,"f\ng\ng\nh\nh\nh"),("N/A",2,2,"i\nj\nj")]] -> [["1,1,[("a",1),("b",2),("c",3)]","1,2,[("d",1),("e",2)]"],["2,1,[("f",1),("g",2),("h",3)]","2,2,[("i",1),("j",2)]"]]
-}
statisticsEachSlave :: [[(String, Int, Int, String)]] -> [[String]]
statisticsEachSlave [] = []
statisticsEachSlave l  = map statisticsEachSeason l













--master
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
ex : [[["1,1,[(\"a\",1),(\"b\",2),(\"c\",3)]","1,2,[(\"d\",1),(\"e\",2)]"],["2,1,[(\"f\",1),(\"g\",2),(\"h\",3)]","2,2,[(\"i\",1),(\"j\",2)]"]],[["3,1,[(\"k\",1),(\"l\",2)]","3,2,[(\"m\",1),(\"n\",2)]"],["4,1,[(\"o\",1),(\"p\",2)]","4,2,[(\"q\",1),(\"r\",2)]"]]] -> {"1":[{"a":1,"b":2,"c":3},{"d":1,"e":2}], "2":[{"f":1,"g":2,"h":3},{"i":1,"j":2}], "3":[{"k":1,"l":2},{"m":1,"n":2}], "4":[{"o":1,"p":2},{"q":1,"r":2}]}
-}
concatStatistics :: [[[String]]] -> String
concatStatistics listEachSlave =
    let listEachSeason = sort $ concat listEachSlave in -- pour sort : vérifier qu'on ait bien "1,1,[(\"word\",1)]"
    "{" ++ concat (intersperse "," (seasonToJSON listEachSeason 1)) ++ "}"
