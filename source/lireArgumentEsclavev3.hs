module LireArgumentEsclavev3 where

import System.Environment

keywordSerieSeasonNbEpisode :: [String] -> ([String], String)
--keywordSerieSeasonNbEpisode [] = ("","")
keywordSerieSeasonNbEpisode (keyword:serie:season:nbEpisode:[]) = (keyword:serie:season:[], nbEpisode)

listStringNumberToList :: String -> [Int]
listStringNumberToList n = [1..(read n :: Int)]

listSeasonEpisode :: [Int] -> [String]
listSeasonEpisode [] = []
listSeasonEpisode (x:l) = (show x):(listSeasonEpisode l)

parseKeywordSerieSeasonEpisode :: [String] -> (String, Int, Int, String)
parseKeywordSerieSeasonEpisode (keyword:serie:season:episode:[]) = (keyword, read season :: Int, read episode :: Int, "http://185.167.204.218:8081/public/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

keywordSerieSeasonEpisodes :: [String] -> [String] -> [(String, Int, Int, String)]
keywordSerieSeasonEpisodes _ [] = []
keywordSerieSeasonEpisodes l (x:xs) = (parseKeywordSerieSeasonEpisode (l ++ (x:[]))):(keywordSerieSeasonEpisodes l xs)


lireArgumentEsclave :: [String] -> [(String, Int, Int, String)]
lireArgumentEsclave [] = []
lireArgumentEsclave args = -- ["Ned", "GoT","1","10"]
    let (keywordSerieSeason, nbEpisodes) = keywordSerieSeasonNbEpisode args in -- (["Ned","GoT","1"],"10")
    keywordSerieSeasonEpisodes keywordSerieSeason (listSeasonEpisode (listStringNumberToList nbEpisodes)) -- [("Ned", 1, 1, "http://185.167.204.218:8081/public/GoT/1/1"),("Ned", 1, 2,"http://.../GoT/1/2"), ... ("Ned", 1, 10, "http://.../GoT/1/10")]
