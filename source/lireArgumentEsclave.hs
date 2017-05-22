import System.Environment

ipPortKeywordSerieSeasonNbEpisode :: [String] -> ([String], String)
--ipPortKeywordSerieSeasonNbEpisode [] = ("","")
ipPortKeywordSerieSeasonNbEpisode (ip:port:keyword:serie:season:nbEpisode:[]) = (ip:port:keyword:serie:season:[], nbEpisode)

listStringNumberToList :: String -> [Int]
listStringNumberToList n = [1..(read n :: Int)]

listSeasonEpisode :: [Int] -> [String]
listSeasonEpisode [] = []
listSeasonEpisode (x:l) = (show x):(listSeasonEpisode l)

parseIpPortKeywordSerieSeasonEpisode :: [String] -> (String, String)
--parseIpPortKeywordSerieSeasonEpisode [] = ("","")
parseIpPortKeywordSerieSeasonEpisode (ip:port:keyword:serie:season:episode:[]) = (keyword, ip ++ ":" ++ port ++ "/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

ipPortKeywordSerieSeasonEpisodes :: [String] -> [String] -> [(String, String)]
ipPortKeywordSerieSeasonEpisodes _ [] = []
ipPortKeywordSerieSeasonEpisodes l (x:xs) = (parseIpPortKeywordSerieSeasonEpisode (l ++ (x:[]))):(ipPortKeywordSerieSeasonEpisodes l xs)


main = do -- ne marche pas 
    args <- getArgs -- [IP, Port, "Ned", "GoT","1","10"]
    let (ipPortKeywordSerieSeason, nbEpisodes) = ipPortKeywordSerieSeasonNbEpisode args -- ([IP,Port,"Ned","GoT","1"],"10")
    let keywordURLList = ipPortKeywordSerieSeasonEpisodes ipPortKeywordSerieSeason (listSeasonEpisode (listStringNumberToList nbEpisodes)) -- [("Ned", IP:Port"/GoT/1/1"),("Ned", IP:Port"/GoT/1/2"), ... ("Ned", IP:Port"/GoT/1/10")]
    print keywordURLList
    

{-
let (keyword, URL) = parseIpPortKeywordSerieSeasonEpisode args -- ("Ned", IP:Port"/GoT/1/10")
print $ "\n keyword : " ++ keyword -- "Ned"
print $ "\n URL : " ++ URL -- "IP:Port"/GoT/1/10"
-}
