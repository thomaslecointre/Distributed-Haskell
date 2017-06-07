module ArgumentsParser where

import System.Environment

keywordSeriesSeasonNbEpisode :: [String] -> ([String], String)
--keywordSerieSeasonNbEpisode [] = ("","")
keywordSeriesSeasonNbEpisode (keyword:series:season:nbEpisode:[]) = (keyword:series:season:[], nbEpisode)

listStringNumberToList :: String -> [Int]
listStringNumberToList n = [1..(read n :: Int)]

listSeasonEpisode :: [Int] -> [String]
listSeasonEpisode [] = []
listSeasonEpisode (x:l) = (show x):(listSeasonEpisode l)

parseKeywordSeriesSeasonEpisode :: [String] -> (String, Int, Int, String)
parseKeywordSeriesSeasonEpisode (keyword:serie:season:episode:[]) = (keyword, read season :: Int, read episode :: Int, "http://185.167.204.218:8081/public/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

keywordSeriesSeasonEpisodes :: [String] -> [String] -> [(String, Int, Int, String)]
keywordSeriesSeasonEpisodes _ [] = []
keywordSeriesSeasonEpisodes l (x:xs) = (parseKeywordSeriesSeasonEpisode (l ++ (x:[]))):(keywordSeriesSeasonEpisodes l xs)


parseArguments :: [String] -> [(String, Int, Int, String)]
parseArguments [] = []
parseArguments args = -- ["Ned", "GoT","1","10"]
    let (keywordSeriesSeason, nbEpisodes) = keywordSeriesSeasonNbEpisode args in -- (["Ned","GoT","1"],"10")
    keywordSeriesSeasonEpisodes keywordSeriesSeason (listSeasonEpisode (listStringNumberToList nbEpisodes)) -- [("Ned", 1, 1, "http://185.167.204.218:8081/public/GoT/1/1"),("Ned", 1, 2,"http://.../GoT/1/2"), ... ("Ned", 1, 10, "http://.../GoT/1/10")]
