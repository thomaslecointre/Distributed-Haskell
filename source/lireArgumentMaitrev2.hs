module LireArgumentMaitrev2 where

import System.Environment

parseKeywordSerieNumberEpisodePerSeason :: [String] -> ([String], [String])
--parseKeywordSerieNumberEpisodePerSeason [] = ("","")
parseKeywordSerieNumberEpisodePerSeason (keyword:serie:episodes) = ((keyword:serie:[]), episodes)

episodesList :: Int -> [String] -> [(String,String)]
episodesList _ [] = []
episodesList n (x:l) = (show n, x):(episodesList (n+1) l)

keywordSerieSeasonEpisodeToList :: [String] -> [(String, String)] -> [[String]]
keywordSerieSeasonEpisodeToList _ [] = []
keywordSerieSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(keywordSerieSeasonEpisodeToList l1 l2)

lireArgumentMaitre :: [String] -> [[String]]
lireArgumentMaitre [] = [[]]
lireArgumentMaitre args = -- ["Ned", "GoT","3","3","2"]
    let (keywordSerie, episodes) = parseKeywordSerieNumberEpisodePerSeason args in -- (["Ned", "GoT"], ["3","3","2"])
    let seasonEpisode = episodesList 1 episodes in -- [("1","3"),("2","3"),("3","2")]
    keywordSerieSeasonEpisodeToList keywordSerie seasonEpisode -- [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
    
-- mot-clef, serie, saison, nbEpisodes    ->     url = ip:port/Public/serie/saison/[1..nbEpisodes]
