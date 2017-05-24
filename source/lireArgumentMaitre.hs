module LireArgumentMaitre where

import System.Environment

parseIpPortKeywordSerieNumberEpisodePerSeason :: [String] -> ([String], [String])
--parseIpPortKeywordSerieNumberEpisodePerSeason [] = ("","")
parseIpPortKeywordSerieNumberEpisodePerSeason (ip:port:keyword:serie:episodes) = ((ip:port:keyword:serie:[]), episodes)

episodesList :: Int -> [String] -> [(Int,String)]
episodesList _ [] = []
episodesList n (x:l) = (n, x):(episodesList (n+1) l)

convertIntToString :: [(Int,String)] -> [(String, String)]
convertIntToString [] = []
convertIntToString ((n,s):l) = (show n, s):(convertIntToString l)

seasonEpisodeList :: [String] -> [(String, String)]
seasonEpisodeList l = convertIntToString (episodesList 1 l)

ipPortKeywordSerieSeasonEpisodeToList :: [String] -> [(String, String)] -> [[String]]
ipPortKeywordSerieSeasonEpisodeToList _ [] = []
ipPortKeywordSerieSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(ipPortKeywordSerieSeasonEpisodeToList l1 l2)

lireArgumentMaitre :: [String] -> [[String]]
lireArgumentMaitre [] = [[]]
lireArgumentMaitre args = -- [IP, Port, "Ned", "GoT","3","3","2"]
    let (ipPortKeywordSerie, episodes) = parseIpPortKeywordSerieNumberEpisodePerSeason args in -- ([IP, Port, "Ned", "GoT"], ["3","3","2"])
    let seasonEpisode = seasonEpisodeList episodes in -- [("1","3"),("2","3"),("3","2")]
    ipPortKeywordSerieSeasonEpisodeToList ipPortKeywordSerie seasonEpisode -- [[IP,Port,"Ned","GoT","1","3"], [IP,Port,"Ned","GoT","2","3"], [IP,Port,"Ned","GoT","3","2"]]
    
-- ip, port, mot, serie, saison, nbEpisodes    ->     url = ip:port/Public/serie/saison/[1..nbEpisodes]
