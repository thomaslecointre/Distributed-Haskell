module OrderDistribution where

import System.Environment

parseKeywordSeriesNumberEpisodePerSeason :: [String] -> ([String], [String])
parseKeywordSeriesNumberEpisodePerSeason (keyword:series:episodes) = ((keyword:series:[]), episodes)

episodeList :: Int -> [String] -> [(String,String)]
episodeList _ [] = []
episodeList n (x:l) = (show n, x):(episodeList (n+1) l)

keywordSeriesSeasonEpisodeToList :: [String] -> [(String, String)] -> [[String]]
keywordSeriesSeasonEpisodeToList _ [] = []
keywordSeriesSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(keywordSeriesSeasonEpisodeToList l1 l2)

concatSeasonPerSlave :: [[String]] -> [[String]] -> Int -> ([[String]], [[String]])
concatSeasonPerSlave x xs 0     = (x, xs)
concatSeasonPerSlave l (x:xs) i = concatSeasonPerSlave (l++[x]) xs (i-1)

seasonPerSlave :: [[String]] -> Int -> Int -> [[[String]]]
seasonPerSlave [] _ _ = []
seasonPerSlave l q r  = if r > 0
                        then let (x,xs) = concatSeasonPerSlave [] l (q+1) in
                        x:(seasonPerSlave xs q (r-1))
                        else let (x,xs) = concatSeasonPerSlave [] l q in
                        x:(seasonPerSlave xs q 0)

parseArguments :: [String] -> Int -> [[[String]]]
parseArguments args nbSlaves = -- ["Ned", "GoT","3","3","2"] 2
    let (keywordSeries, episodes) = parseKeywordSeriesNumberEpisodePerSeason args in -- (["Ned", "GoT"], ["3","3","2"])
    let seasonEpisode = episodeList 1 episodes in -- [("1","3"),("2","3"),("3","2")]
    let listSeasons = keywordSeriesSeasonEpisodeToList keywordSeries seasonEpisode in -- [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
    let a = length listSeasons in
    let (q, r) = (div a nbSlaves, mod a nbSlaves) in
    seasonPerSlave listSeasons q r -- [[["Ned","GoT","1","3"],["Ned","GoT","2","3"]],[["Ned","GoT","3","2"]]]
    
-- mot-clef, serie, saison, nbEpisodes    ->     url = ip:port/Public/serie/saison/[1..nbEpisodes]
