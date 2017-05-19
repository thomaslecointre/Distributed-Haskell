-- import Data.List
import System.Environment

firstList :: [String] -> String
firstList [] = ""
firstList (x:l) = x

tailList :: [String] -> [String]
tailList [] = []
tailList (x:l) = l

episodesList :: Int -> [String] -> [(Int,String)]
episodesList 0 _ = []
episodesList _ [] = []
episodesList n (x:l) = (n - length l, x):(episodesList n l)

listStringNumberToList :: String -> [Int]
listStringNumberToList n = [1..(read n :: Int)]

listSeasonEpisode :: Int -> [Int] -> [(String,String)]
listSeasonEpisode _ [] = []
listSeasonEpisode season (x:l) = (show season, show x):(listSeasonEpisode season l)

listAllSeasonEpisode :: [(Int, String)] -> [(String, String)]
listAllSeasonEpisode [] = []
listAllSeasonEpisode ((season,nbEpisodes):l) = (listSeasonEpisode season (listStringNumberToList nbEpisodes))++(listAllSeasonEpisode l)

listTotale :: [String] -> [(String, String)]
listTotale s = listAllSeasonEpisode (episodesList (length s) s)

listURL :: String -> [(String,String)] -> [String]
listURL _ [] = []
listURL serie ((season,episode):l) = (serie ++ "/" ++ season ++ "/" ++ episode):(listURL serie l)


main = do
    args <- getArgs -- ne marche pas -- ["GoT","3","3","2"]
    let serie = firstList args -- "GoT"
    let episodes = tailList args -- ["3","3","2"]
    let tmp = listTotale episodes -- [("1","1"),("1","2"),("1","3"),("2","1"),("2","2"),("2","3"),("3","1"),("3","2")]
    let res = listURL serie tmp -- ["GoT/1/1","GoT/1/2","GoT/1/3","GoT/2/1","GoT/2/2","GoT/2/3","GoT/3/1","GoT/3/2"]
    print res