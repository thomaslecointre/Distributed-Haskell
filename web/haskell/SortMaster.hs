{-|
Module      : SortMaster
Description : Transforms a list of String to a list of [[[Int]]], sorts it and creates a JSON content
Copyright   : (c) Thomas Lecointre, 2017
                  Thomas Perles, 2017
License     : MIT
Maintainer  :   thomas.lecointre@uha.fr
                thomas.perles@uha.fr
Stability   : experimental
Portability : Windows

We use this module to transform data, sort them and create a JSON content

-}
module SortMaster where

import qualified Data.List as DL

-- |Transforms a list of String where String is like "[[[Int]]]" to a list of [[[Int]]]
concatSlaveResult   :: [String]     -- ^ A list like ["[[[1,2,3],[4,5,6]],[[7,8,9],[0,1,2]]]", "[[[3,4,5],[6,7,8]],[[9,0,1],[1,2,3]]]", "[[[4,5,6],[7,8,9]],[[0,1,2],[3,4,5]]]"]
                    -> [[[[Int]]]]  -- ^ A list like [[[[1,2,3],[4,5,6]],[[7,8,9],[0,1,2]]], [[[3,4,5],[6,7,8]],[[9,0,1],[1,2,3]]], [[[4,5,6],[7,8,9]],[[0,1,2],[3,4,5]]]]
concatSlaveResult [] = []
concatSlaveResult (x:l) = (read x :: [[[Int]]]):(concatSlaveResult l)

-- | Takes the third argument of a list composed of 3 elements
takeThird   :: [[Int]]  -- ^ A list like [[1,2,3],[4,5,6]]
            -> [Int]    -- ^ A list like [3,6]
takeThird [] = []
takeThird ([season, episode, occurrence]:l) = occurrence:(takeThird l)

-- |Sorts a list of list composed of 3 elements and prints a result
chronogicalSort :: [[Int]]  -- ^ A list like [[1,2,3],[1,1,2],[1,3,4]]
                -> String   -- ^ A String like "\"1\" : [2,3,4]"
chronogicalSort [] = ""
chronogicalSort ([season, episode, occurrence]:l) =
    let sortedList = DL.sort ([season, episode, occurrence]:l) in
    (show $ show season) ++ " : " ++ (show $ takeThird sortedList)

-- |Creates the content of a JSON file
chronogicalSortToJSON   :: [[[Int]]]    -- ^ A list like [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]]
                        -> String       -- ^ {"1" : [2,3], "2" : [4,3], "3" : [2,1]}
chronogicalSortToJSON [] = ""
chronogicalSortToJSON l = "{" ++ (concat $ DL.intersperse ", " $ map chronogicalSort l) ++ "}"

-- |Takes a list of String where each String is like "[[[Int]]]" and returns a JSON content
concatChronologicalSort :: [String] -- ^ A list like ["[[[1,2,3],[4,5,6]],[[7,8,9],[0,1,2]]]", "[[[3,4,5],[6,7,8]],[[9,0,1],[1,2,3]]]", "[[[4,5,6],[7,8,9]],[[0,1,2],[3,4,5]]]"]
                        -> String   -- ^ The content of a JSON file like {"1" : [2,3], "2" : [4,3], "3" : [2,1]}
concatChronologicalSort l =
    let listEachSeason = DL.sort $ concat $ concatSlaveResult l in
    chronogicalSortToJSON listEachSeason




-- |Changes the order of each element of a list of a list
changeList  :: [[Int]]  -- ^ The initial list like [[1,2,3],[1,1,3],[1,3,4]]
            -> [[Int]]  -- ^ The list modified like [[1,3,-2],[1,3,-1],[1,4,-3]]
changeList [] = []
changeList ([season, episode, occurrence]:l) =
    [season, occurrence, -episode]:(changeList l)

-- |Creates a String composed of {"Int" : Int}
occurrenceEpisode   :: [[Int]]  -- ^ A list of list with 3 elements like [[1,4,-3],[1,3,-1],[1,3,-2]]
                    -> String   -- ^ '"3" : 4, "1" : 3, "2" : 3'
occurrenceEpisode [] = ""
occurrenceEpisode ([season, occurrence, episode]:[]) =
    "{" ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ "}"
occurrenceEpisode ([season, occurrence, episode]:l) =
    "{" ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ "}, " ++ (occurrenceEpisode l)
    

-- |Sorts a list of list of 3 elements by the first and the third elements, the second by descending order and returns a key-value readable by JSON
sortBySeason    :: [[Int]]  -- ^ A list like [[1,2,3],[1,1,3],[1,3,4]]
                -> String   -- ^ A String like "\"1\" : {\"3\" : 4 , \"1\" : 3, \"2\" : 3}"
sortBySeason [] = ""
sortBySeason ([season, episode, occurrence]:l) =
    let tmpList = changeList ([season, episode, occurrence]:l) in
    let sortedList = reverse $ DL.sort tmpList in
    (show $ show season) ++ " : [" ++ (occurrenceEpisode sortedList) ++ "]"

-- |Sorts the list and creates a JSON file
sortBySeasonToJSON  :: [[[Int]]]    -- ^ [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]]
                    -> String       -- ^ {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}
sortBySeasonToJSON [] = ""
sortBySeasonToJSON l = "{" ++ (concat $ DL.intersperse "," $ map sortBySeason l) ++ "}"

-- |Transforms a list of String to a list of [[[Int]]], then sorts it and finally creates a JSON content
concatSeasonSort    :: [String] -- ^ ["[[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]]]","[[[3,1,2],[3,2,1]]]"]
                    -> String   -- ^ {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}
concatSeasonSort l =
    let listEachSeason = DL.sort $ concat $ concatSlaveResult l in
    sortBySeasonToJSON listEachSeason

-- |Changes the order of the elements of a list composed of 3 elements
changeList2 :: [[Int]]  -- ^ A list like [[1,1,2],[1,2,3]]
            -> [[Int]]  -- ^ A list like [[2,-1,-1],[3,-1,-2]]
changeList2 [] = []
changeList2 ([season, episode, occurrence]:l) =
    [occurrence, -season, -episode]:(changeList2 l)

-- |Creates a JSON key-value from a list of list composed of 3 elements like "Int_Int":Int
relevanceToJSON :: [[Int]]  -- ^ A list like [[1,1,2],[1,2,3]]
                -> String   -- ^ A String like "1_2":3, "1_1":2
relevanceToJSON [] = ""
relevanceToJSON ([occurrence, season, episode]:[]) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence)
relevanceToJSON ([occurrence, season, episode]:l) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence) ++ ", " ++ (relevanceToJSON l)

-- |Sorts a list of 3 elements by the third element ascending, the first and the second elements descending and creates a JSON content
sortByRelevanceToJSON   :: [[[Int]]]    -- ^ A list like [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]]
                        -> String       -- ^ A String like {"2_1" : 4, "1_2" : 3, "2_2" : 3, "1_1" : 2, "3_1" : 2, "3_2" : 1}
sortByRelevanceToJSON [] = ""
sortByRelevanceToJSON l =
    let tmpList = changeList2 $ concat l in
    let sortedList = reverse $ DL.sort tmpList in
    "{" ++ relevanceToJSON sortedList ++ "}"

-- |Transforms a list of String to a list of [[[Int]]], sorts it and creates a JSON content
concatRelevanceSort :: [String] -- ^ A list like ["[[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]]]","[[[3,1,2],[3,2,1]]]"]
                    -> String   -- ^ A String like {"2_1" : 4, "1_2" : 3, "2_2" : 3, "1_1" : 2, "3_1" : 2, "3_2" : 1}
concatRelevanceSort l =
    let listEachSeason = concat $ concatSlaveResult l in
    sortByRelevanceToJSON listEachSeason
