{-|
Module      : OrderDistribution
Description : Extracts the two first elements of a list and splits the rest into the number passed in argument
Copyright   : (c) Thomas Lecointre, 2017
                  Thomas Perles, 2017
License     : MIT
Maintainer  :   thomas.lecointre@uha.fr
                thomas.perles@uha.fr
Stability   : experimental
Portability : Windows

We use this module to distribute data using a list

-}
module OrderDistribution where

import System.Environment

-- |Splits the list on the third element
parseKeywordSeriesNumberEpisodePerSeason    :: [String]                 -- ^ A list of at least 3 elements like [1,2,3]
                                            -> ([String], [String])     -- ^ A tuple with the two first elements in the first list and the rest in the second list like ([1,2],[3])
parseKeywordSeriesNumberEpisodePerSeason (keyword:series:episodes) = ((keyword:series:[]), episodes)

-- |Creates a list of pairs with the index of the element in the first element of the pair
episodeList :: Int                  -- ^ An index like 3
            -> [String]             -- ^ A list like ["3","3","2"]
            -> [(String,String)]    -- ^ A list of pairs (index, element) like [("1","3"),("2","3"),("3","2")]
episodeList _ [] = []
episodeList n (x:l) = (show n, x):(episodeList (n+1) l)

-- |Adds two elements of a pair of a list to the end of another list
keywordSeriesSeasonEpisodeToList    :: [String]             -- ^ The list which receives the two elements like ["Ned", "GoT",]
                                    -> [(String, String)]   -- ^ The list of pairs which gives the elements like [("1","3"),("2","3"),("3","2")]
                                    -> [[String]]           -- ^ A list of list where the pair is adds at the end like [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
keywordSeriesSeasonEpisodeToList _ [] = []
keywordSeriesSeasonEpisodeToList l1 ((season, episode):l2) = (l1 ++ (season:episode:[])):(keywordSeriesSeasonEpisodeToList l1 l2)

-- |Concatenates the number of element defined in argument from the second list to the first list
concatSeasonPerSlave    :: [[String]]                   -- ^ The first list which is added some elements like []
                        -> [[String]]                   -- ^ The second list which is taken some elements like [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
                        -> Int                          -- ^ The number of elements which are exchanged like 2
                        -> ([[String]], [[String]])     -- ^ The two list mixed ([["Ned","GoT","1","3"], ["Ned","GoT","2","3"]], [["Ned","GoT","3","2"]])
concatSeasonPerSlave x xs 0     = (x, xs)
concatSeasonPerSlave l (x:xs) i = concatSeasonPerSlave (l++[x]) xs (i-1)

-- |Splits the list into several lists and distributes some seasons for each slave
seasonPerSlave  :: [[String]]       -- ^ The list to be split like [["Ned","GoT","1","3"], ["Ned","GoT","2","3"], ["Ned","GoT","3","2"]]
                -> Int              -- ^ The number of elements which each list has at least like 1
                -> Int              -- ^ The number of list which have one more element like 1
                -> [[[String]]]     -- ^ A list of list where each list has the number of elements defined like [[["Ned","GoT","1","3"], ["Ned","GoT","2","3"]], [["Ned","GoT","3","2"]]]
seasonPerSlave [] _ _ = []
seasonPerSlave l q r  = if r > 0
                        then let (x,xs) = concatSeasonPerSlave [] l (q+1) in
                        x:(seasonPerSlave xs q (r-1))
                        else let (x,xs) = concatSeasonPerSlave [] l q in
                        x:(seasonPerSlave xs q 0)

-- |Extracts the two first elements of a list and splits the rest into the number defined
parseArguments  :: [String]         -- ^ The list which is treated like ["Ned", "GoT","10","9","10","7","8","10","7"]
                -> Int              -- ^ The number of lists which will be created like 3
                -> [[[String]]]     -- ^ [[["Ned","GoT","1","10"],["Ned","GoT","2","9"],["Ned","GoT","3","10"]], [["Ned","GoT","4","7"], ["Ned","GoT","5","8"]], [["Ned","GoT","6","10"],["Ned","GoT","7","7"]]]
parseArguments args nbSlaves =
    let (keywordSeries, episodes) = parseKeywordSeriesNumberEpisodePerSeason args in
    let seasonEpisode = episodeList 1 episodes in
    let listSeasons = keywordSeriesSeasonEpisodeToList keywordSeries seasonEpisode in -- 
    let a = length listSeasons in
    let (q, r) = (div a nbSlaves, mod a nbSlaves) in
    seasonPerSlave listSeasons q r
