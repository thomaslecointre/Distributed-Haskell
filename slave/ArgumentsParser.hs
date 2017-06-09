module ArgumentsParser where

import System.Environment

-- |Splits the list on the forth argument
keywordSeriesSeasonNbEpisode    :: [String]    -- ^ List with four arguments like (keyword : series : season : nbEpisode : [])
                                -> ([String], String)    -- ^ (a,b) the first three arguments in a and the forth argument in b
keywordSeriesSeasonNbEpisode (keyword:series:season:nbEpisode:[]) = (keyword:series:season:[], nbEpisode)

-- |Creates a list from 1 to the argument
listStringNumberToList  :: String   -- ^ The end of the list "n"
                        -> [Int]    -- ^ List from 1 to n
listStringNumberToList n = [1..(read n :: Int)]

-- |Transforms a list of Int to a list of String
listSeasonEpisode   :: [Int]    -- ^ List of Int from 1 to n
                    -> [String] -- ^ Lsit of String from "1" to "n"
listSeasonEpisode [] = []
listSeasonEpisode (x:l) = (show x):(listSeasonEpisode l)

-- |Transforms ["kw","serie","s","e"] into ("kw",s,e,"url")
parseKeywordSeriesSeasonEpisode :: [String] -- ^ List of 4 arguments like ["kw","serie","s","e"]
                                -> (String, Int, Int, String)   -- ^ Tuple of 4 arguments like ("kw",s,e,"url")
parseKeywordSeriesSeasonEpisode (keyword:serie:season:episode:[]) = (keyword, read season :: Int, read episode :: Int, "http://185.167.204.218:8081/public/" ++ serie ++ "/" ++ season ++ "/" ++ episode)

-- |Tranforms 2 lists of String (["kw","serie","s"] and ["e1","e2",...]) into a list of tuples of 4 arguments like [("kw",s,e,"url")]
keywordSeriesSeasonEpisodes :: [String] -- ^ List of 3 String like ["kw","serie","s"]
                            -> [String] -- ^ List of n String like ["e1","e2",...,"en"]
                            -> [(String, Int, Int, String)] -- ^ List of tuple like [("kw",s,e,"url")]
keywordSeriesSeasonEpisodes _ [] = []
keywordSeriesSeasonEpisodes l (x:xs) = (parseKeywordSeriesSeasonEpisode (l ++ (x:[]))):(keywordSeriesSeasonEpisodes l xs)

-- |Transforms a list of String like ["kw", "serie","s","n"] into a list of tuples like [("kw",s,e,"url")]
parseArguments  :: [String] -- ^ List of String like ["jon", "game_of_thrones","1","10"]
                -> [(String, Int, Int, String)] -- ^ List of tuples like [("jon",1,1,"http://185.167.204.218:8081/public/game_of_thrones/1/1"), ("jon",1,2,"http.../1/2"), ... ("jon", 1, 10, "http.../1/10")]
parseArguments [] = []
parseArguments args = -- ["Ned", "GoT","1","10"]
    let (keywordSeriesSeason, nbEpisodes) = keywordSeriesSeasonNbEpisode args in
    keywordSeriesSeasonEpisodes keywordSeriesSeason (listSeasonEpisode (listStringNumberToList nbEpisodes))
