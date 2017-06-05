module LireArgumentEsclavev2 where

import System.Environment

ipPortKeywordSerieSeasonNbEpisode :: [String] -> ([String], String)
--ipPortKeywordSerieSeasonNbEpisode [] = ("","")
ipPortKeywordSerieSeasonNbEpisode (ip:port:keyword:serie:season:nbEpisode:[]) = (ip:port:keyword:serie:season:[], nbEpisode)

listStringNumberToList :: String -> [Int]
listStringNumberToList n = [1..(read n :: Int)]

listSeasonEpisode :: [Int] -> [String]
listSeasonEpisode [] = []
listSeasonEpisode (x:l) = (show x):(listSeasonEpisode l)

parseIpPortKeywordSerieSeasonEpisode :: [String] -> (String, Int, Int, String)
parseIpPortKeywordSerieSeasonEpisode (ip:port:keyword:serie:season:episode:[]) = (keyword, read season :: Int, read episode :: Int, ip ++ ":" ++ port ++ "/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

ipPortKeywordSerieSeasonEpisodes :: [String] -> [String] -> [(String, Int, Int, String)]
ipPortKeywordSerieSeasonEpisodes _ [] = []
ipPortKeywordSerieSeasonEpisodes l (x:xs) = (parseIpPortKeywordSerieSeasonEpisode (l ++ (x:[]))):(ipPortKeywordSerieSeasonEpisodes l xs)


lireArgumentEsclave :: [String] -> [(String, Int, Int, String)]
lireArgumentEsclave [] = []
lireArgumentEsclave args = -- [IP, Port, "Ned", "GoT","1","10"]
    let (ipPortKeywordSerieSeason, nbEpisodes) = ipPortKeywordSerieSeasonNbEpisode args in -- ([IP,Port,"Ned","GoT","1"],"10")
    ipPortKeywordSerieSeasonEpisodes ipPortKeywordSerieSeason (listSeasonEpisode (listStringNumberToList nbEpisodes)) -- [("Ned", 1, 1, IP:Port"/GoT/1/1"),("Ned", 1, 2, IP:Port"/GoT/1/2"), ... ("Ned", 1, 10, IP:Port"/GoT/1/10")]

{-
let (keyword, URL) = parseIpPortKeywordSerieSeasonEpisode args -- ("Ned", IP:Port"/GoT/1/10")
print $ "\n keyword : " ++ keyword -- "Ned"
print $ "\n URL : " ++ URL -- "IP:Port"/GoT/1/10"
-}
