module OrderDistribution where

import System.Environment

parseKeywordSeriesNumberEpisodePerSeason :: [String] -> ([String], [String])
--parseKeywordSeriesNumberEpisodePerSeason [] = ("","")
parseKeywordSeriesNumberEpisodePerSeason (keyword:series:episodes) = ((keyword:series:[]), episodes)

episodeList :: Int -> [String] -> [(String,String)]
episodeList _ [] = []
episodeList n (x:l) = (show n, x):(episodeList (n+1) l)

keywordSeriesSeasonEpisodeToList :: [String] -> [(String, String)] -> [[String]]
keywordSeriesSeasonEpisodeToList _ [] = []
keywordSeriesSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(keywordSeriesSeasonEpisodeToList l1 l2)

ParseArguments :: [String] -> [[String]]
ParseArguments [] = [[]]
ParseArguments args = -- ["Ned", "GoT","3","3","2"]
    let (keywordSeries, episodes) = parseKeywordSeriesNumberEpisodePerSeason args in -- (["Ned", "GoT"], ["3","3","2"])
    let seasonEpisode = episodeList 1 episodes in -- [("1","3"),("2","3"),("3","2")]
    keywordSeriesSeasonEpisodeToList keywordSeries seasonEpisode -- [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
    
-- mot-clef, serie, saison, nbEpisodes    ->     url = ip:port/Public/serie/saison/[1..nbEpisodes]
