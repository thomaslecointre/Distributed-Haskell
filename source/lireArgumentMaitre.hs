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
seasonEpisodeList l = convertIntToString (episodesList (length l) l)

ipPortKeywordSerieSeasonEpisodeToList :: [String] -> [(String, String)] -> [[String]]
ipPortKeywordSerieSeasonEpisodeToList _ [] = []
ipPortKeywordSerieSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(ipPortKeywordSerieSeasonEpisodeToList l1 l2)


main = do -- ne marche pas
    args <- getArgs -- [IP, Port, "Ned", "GoT","3","3","2"]
    let (ipPortKeywordSerie, episodes) = parseIpPortKeywordSerieNumberEpisodePerSeason args -- ([IP, Port, "Ned", "GoT"], ["3","3","2"])
    let seasonEpisode = seasonEpisodeList episodes -- [("1","3"),("2","3"),("3","2")]
    let res = ipPortKeywordSerieSeasonEpisodeToList ipPortKeywordSerie seasonEpisode -- [[IP,Port,"Ned","GoT","1","3"], [IP,Port,"Ned","GoT","2","3"], [IP,Port,"Ned","GoT","3","2"]]
    print res
    
-- ip, port, mot, serie, saison, nbEpisodes    ->     url = ip:port/Public/serie/saison/[1..nbEpisodes]
