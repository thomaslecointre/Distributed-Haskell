module Sort where

import qualified Data.List as DL

takeThird :: [(Int, Int, Int)] -> [Int]
takeThird [] = []
takeThird ((season, episode, occurrence):l) = occurrence:(takeThird l)

chronogicalSort :: [(Int, Int, Int)] -> String
chronogicalSort [] = ""
chronogicalSort ((season, episode, occurrence):l) =
    let sortedList = DL.sort ((season, episode, occurrence):l) in
    (show $ show season) ++ " : " ++ (show $ takeThird sortedList)

-- chronogicalSort [(1,2,3),(1,1,2),(1,3,4)] -> [(1,1,2),(1,2,3),(1,3,4)] -> "\"1\" : [2,3,4]"

chronogicalSortForAllSeason :: [[(Int, Int, Int)]] -> String
chronogicalSortForAllSeason [] = ""
chronogicalSortForAllSeason (x:[]) = chronogicalSort x
chronogicalSortForAllSeason (x:l) = (chronogicalSort x) ++ ", " ++ (chronogicalSortForAllSeason l)

chronogicalSortToJSON :: [[(Int, Int, Int)]] -> String
chronogicalSortToJSON [] = ""
chronogicalSortToJSON l = "{" ++ (chronogicalSortForAllSeason l) ++ "}"

-- chronogicalSortToJSON [[(1,1,2),(1,2,3)],[(2,1,4),(2,2,3)],[(3,1,2),(3,2,1)]] -> {"1" : [2,3], "2" : [4,3], "3" : [2,1]}






changeList :: [(Int, Int, Int)] -> [(Int, Int, Int)]
changeList [] = []
changeList ((season, episode, occurrence):l) =
    (season, occurrence, -episode):(changeList l)

occurrenceEpisode :: [(Int, Int, Int)] -> String
occurrenceEpisode [] = ""
occurrenceEpisode ((season, occurrence, episode):[]) =
    "{ " ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ " }"
occurrenceEpisode ((season, occurrence, episode):l) =
    "{ " ++ (show $ show $ -episode) ++ " : " ++ (show $ occurrence) ++ " }, " ++ (occurrenceEpisode l)
    

sortBySeason :: [(Int, Int, Int)] -> String
sortBySeason [] = ""
sortBySeason ((season, episode, occurrence):l) =
    let tmpList = changeList ((season, episode, occurrence):l) in
    let sortedList = reverse $ DL.sort tmpList in
    (show $ show season) ++ " : [" ++ (occurrenceEpisode sortedList) ++ "]"
    
-- sortBySeason [(1,2,3),(1,1,3),(1,3,4)] -> "\"1\" : [{\"3\":4},{\"1\":3},{\"2\":3}]"

sortByAllSeason :: [[(Int, Int, Int)]] -> String
sortByAllSeason [] = ""
sortByAllSeason (x:[]) = sortBySeason x
sortByAllSeason (x:l) = (sortBySeason x) ++ ", " ++ (sortByAllSeason l)

sortBySeasonToJSON :: [[(Int, Int, Int)]] -> String
sortBySeasonToJSON [] = ""
sortBySeasonToJSON l = "{" ++ (sortByAllSeason l) ++ "}"

-- sortBySeasonToJSON [[(1,1,2),(1,2,3)],[(2,1,4),(2,2,3)],[(3,1,2),(3,2,1)]] -> {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}





changeList2 :: [(Int, Int, Int)] -> [(Int, Int, Int)]
changeList2 [] = []
changeList2 ((season, episode, occurrence):l) =
    (occurrence, -season, -episode):(changeList2 l)

relevanceToJSON :: [(Int, Int, Int)] -> String
relevanceToJSON [] = ""
relevanceToJSON ((occurrence, season, episode):[]) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence)
relevanceToJSON ((occurrence, season, episode):l) =
    "\"" ++ (show $ -season) ++ "_" ++ (show $ -episode) ++ "\" : " ++ (show $ occurrence) ++ ", " ++ (relevanceToJSON l)

sortByRelevanceToJSON :: [(Int, Int, Int)] -> String
sortByRelevanceToJSON [] = ""
sortByRelevanceToJSON ((season, episode, occurrence):l) =
    let tmpList = changeList2 ((season, episode, occurrence):l) in
    let sortedList = reverse $ DL.sort tmpList in
    "{" ++ relevanceToJSON sortedList ++ "}"
    
-- sortByRelevanceToJSON [(1,2,3),(1,1,3),(1,3,4),(2,1,4),(2,2,3),(2,3,4)] -> {"1_3" : 4, "2_1" : 4, "2_3" : 4, "1_1" : 3, "1_2" : 3, "2_2" : 3}
