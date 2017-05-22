import System.Environment

parseIpPortKeywordSerieSeasonEpisode :: [String] -> (String, String)
parseIpPortKeywordSerieSeasonEpisode [] = ("","")
parseIpPortKeywordSerieSeasonEpisode (ip:port:keyword:serie:season:episode:[]) = (keyword, ip ++ ":" ++ port ++ "/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

firstPair :: (String, String) -> String
firstPair (a,b) = a

secondPair :: (String, String) -> String
secondPair (a,b) = b


main = do -- ne marche pas 
    args <- getArgs -- [IP, Port, "Ned, "GoT","1","10"]
    let keywordURL = parseIpPortKeywordSerieSeasonEpisode args -- ("Ned", IP:Port"/GoT/1/10")
    print keywordURL
    print $ "\n keyword : " ++ (firstPair keywordURL) -- "Ned"
    print $ "\n URL : " ++ (secondPair keywordURL) -- "IP:Port"/GoT/1/10"
    