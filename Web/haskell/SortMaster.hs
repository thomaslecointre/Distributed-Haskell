module SortMaster where

import qualified Data.List as DL

-- |Transforms a list of String where String is like "[[[Int]]]" to a list of [[[Int]]]
concatSlaveResult   :: [String]     -- ^ 
                    -> [[[[Int]]]]  -- ^ 
concatSlaveResult [] = []
concatSlaveResult (x:l) = (read x :: [[[Int]]]):(concatSlaveResult l)

-- |
takeThird   :: [[Int]]  -- ^ 
            -> [Int]    -- ^ 
takeThird [] = []
takeThird ([season, episode, occurrence]:l) = occurrence:(takeThird l)

-- |
chronogicalSort :: [[Int]]  -- ^ 
                -> String   -- ^ 
chronogicalSort [] = ""
chronogicalSort ([season, episode, occurrence]:l) =
    let sortedList = DL.sort ([season, episode, occurrence]:l) in
    (show $ show season) ++ " : " ++ (show $ takeThird sortedList)

-- chronogicalSort [[1,2,3],[1,1,2],[1,3,4]] -> "\"1\" : [2,3,4]"

-- |
chronogicalSortToJSON   :: [[[Int]]]    -- ^ 
                        -> String       -- ^ 
chronogicalSortToJSON [] = ""
chronogicalSortToJSON l = "{" ++ (concat $ DL.intersperse "," $ map chronogicalSort l) ++ "}"

-- chronogicalSortToJSON [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]] -> {"1" : [2,3], "2" : [4,3], "3" : [2,1]}

-- |
concatChronogicalSort :: [String] -> String
concatChronogicalSort l =
    let listEachSeason = concat $ concatSlaveResult l in
    chronogicalSortToJSON listEachSeason
-- concatChronogicalSort ["[[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]]]","[[[3,1,2],[3,2,1]]]"] -> {"1" : [2,3], "2" : [4,3], "3" : [2,1]}




-- |
changeList :: [[Int]] -> [[Int]]
changeList [] = []
changeList ([season, episode, occurrence]:l) =
    [season, occurrence, -episode]:(changeList l)

-- |
occurrenceEpisode :: [[Int]] -> String
occurrenceEpisode [] = ""
occurrenceEpisode ([season, occurrence, episode]:[]) =
    "{ " ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ " }"
occurrenceEpisode ([season, occurrence, episode]:l) =
    "{ " ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ " }, " ++ (occurrenceEpisode l)
    

-- |
sortBySeason :: [[Int]] -> String
sortBySeason [] = ""
sortBySeason ([season, episode, occurrence]:l) =
    let tmpList = changeList ([season, episode, occurrence]:l) in
    let sortedList = reverse $ DL.sort tmpList in
    (show $ show season) ++ " : [" ++ (occurrenceEpisode sortedList) ++ "]"
    
-- sortBySeason [[1,2,3],[1,1,3],[1,3,4]] -> "\"1\" : [{\"3\":4},{\"1\":3},{\"2\":3}]"

-- |
sortBySeasonToJSON :: [[[Int]]] -> String
sortBySeasonToJSON [] = ""
sortBySeasonToJSON l = "{" ++ (concat $ DL.intersperse "," $ map sortBySeason l) ++ "}"

-- sortBySeasonToJSON [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]] -> {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}

-- |
concatSeasonSort :: [String] -> String
concatSeasonSort l =
    let listEachSeason = concat $ concatSlaveResult l in
    sortBySeasonToJSON listEachSeason
-- concatSeasonSort ["[[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]]]","[[[3,1,2],[3,2,1]]]"] -> {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}






-- |
changeList2 :: [[Int]] -> [[Int]]
changeList2 [] = []
changeList2 ([season, episode, occurrence]:l) =
    [occurrence, -season, -episode]:(changeList2 l)

-- |
relevanceToJSON :: [[Int]] -> String
relevanceToJSON [] = ""
relevanceToJSON ([occurrence, season, episode]:[]) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence)
relevanceToJSON ([occurrence, season, episode]:l) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence) ++ ", " ++ (relevanceToJSON l)

-- |
sortByRelevanceToJSON :: [[[Int]]] -> String
sortByRelevanceToJSON [] = ""
sortByRelevanceToJSON l =
    let tmpList = changeList2 $ concat l in
    let sortedList = reverse $ DL.sort tmpList in
    "{" ++ relevanceToJSON sortedList ++ "}"
    
-- sortByRelevanceToJSON [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]] -> {"2_1" : 4, "1_2" : 3, "2_2" : 3, "1_1" : 2, "3_1" : 2, "3_2" : 1}

-- |
concatRelevanceSort :: [String] -> String
concatRelevanceSort l =
    let listEachSeason = concat $ concatSlaveResult l in
    sortByRelevanceToJSON listEachSeason
-- concatRelevanceSort ["[[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]]]","[[[3,1,2],[3,2,1]]]"] -> {"2_1" : 4, "1_2" : 3, "2_2" : 3, "1_1" : 2, "3_1" : 2, "3_2" : 1}
