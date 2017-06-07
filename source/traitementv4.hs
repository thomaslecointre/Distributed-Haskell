{-# LANGUAGE DeriveGeneric #-}

module Traitementv4 where

--master
import qualified OrderDistribution as OD
import qualified Sortv2 as Sort
--slave
import qualified LireArgumentEsclavev3 as LAE
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat
import qualified KeyWordOccurrence as KWO
--other
import qualified Data.Text as DT
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import System.Environment
import Data.String
import Network.HTTP.Client
import Network.HTTP.Types.Status (statusCode)




-- master process
masterShareSeason :: [String] -> Int -> [[[String]]]
masterShareSeason args nbSlaves = -- ["Ned","GoT","3","3","2"] 2
    OD.parseArguments args nbSlaves -- [[["Ned","GoT","1","3"],["Ned","GoT","2","3"]],[["Ned","GoT","3","2"]]]

masterSort :: String -> [[[Int]]] -> String
masterSort sort seasonEpisodeOccurrence = -- [[[1,1,2],[1,2,3]],[[2,1,4],[2,2,3]],[[3,1,2],[3,2,1]]]
    case sort of
        "chronological" -> Sort.chronogicalSortToJSON seasonEpisodeOccurrence -- {"1" : [2,3], "2" : [4,3], "3" : [2,1]}
        "bySeason" ->Sort.sortBySeasonToJSON seasonEpisodeOccurrence -- {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}
        "byRelevance" -> Sort.sortByRelevanceToJSON seasonEpisodeOccurrence -- {"2_1" : 4, "1_2" : 3, "2_2" : 3, "1_1" : 2, "3_1" : 2, "3_2" : 1}

{-
masterStatistics :: [String] -> String
masterStatistics l = Stat.concatStatistics l

--masterStatisticsProcessEpisode :: (String, Int, Int, String) -> IO ()
masterStatisticsProcessEpisode (keyword, season, episode, url) =
    -- let luj = LUJ.lireURL url in -- "\"Jon, the Hand of the King, ... an army.\""
    let luj = "\"Jon, the Hand of the King, ... an army.\"" in
    let gwf = GWF.getWordsFile luj in -- "Jon the Hand of the King ... an army"
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    Stat.statistics ps ("statistics" ++ show season ++ "_" ++ show episode ++ ".txt")

-- masterStatisticsProcess :: [IO ()]
masterStatisticsProcess = do
    let args = ["N/A","Ned","GoT","1","3"]
    let lae = LAE.lireArgumentEsclave args -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    map masterStatisticsProcessEpisode lae
-}







-- slave process
data Serie = Serie { season :: Int, name :: String, episode :: Int, plot :: String }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

slaveArgs args =
    --let args = [["Ned","GoT","1","3"],["Ned","GoT","2","3"]] in
    let lae = map LAE.lireArgumentEsclave args in
    print lae
    --map lireURL lae

slaveProcess keyword season episode req =
    --let (keyword, season, episode, req) = ("jon", 1, 1, "Jon the Hand of the King ... an army") in
    let gwf = GWF.getWordsFile req in
    --let gwf = GWF.getWordsFile  $ (show.plot) req  -- "Jon the Hand of the King ... an army"
    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) in -- root of the keyword
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    (season:episode:(KWO.keyWordOccurrence kw ps):[])


{-
lireURL (keyword, season, episode, url) = do
    manager <- newManager defaultManagerSettings
    request <- parseRequest url
    response <- httpLbs request manager
    lireJSON (keyword, season, episode, BL.unpack $ responseBody response)

lireJSON :: (String, Int, Int, String) -> IO ()
lireJSON (keyword, season, episode, body) = do
    let req = decode $ BL.pack body :: Maybe Serie
    case req :: Maybe Serie of
      Nothing -> putStrLn "Couldn't load the JSON data from decode Aeson"
      Just req -> do
                    let gwf = GWF.getWordsFile  $ (show.plot) req  -- "Jon the Hand of the King ... an army"
                    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) -- root of the keyword
                    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf  -- "jon\nhand\nking\n...\narmi\n"
                    print (season:episode:(KWO.keyWordOccurrence kw ps):[])

--slaveProcess :: [[Int,Int,Int]]
slaveProcess =
    let args = ["Ned","game_of_thrones","1","3"] in
    -- let args = ["Jon","GoT","1","3"] in
    let lae = LAE.lireArgumentEsclave args in -- [("Ned",1,1,"http://185.167.204.218:8081/public/GoT/1/1"),("Ned",1,2,"http://.../1/2"),("Ned",1,3,"http://.../1/3")]
    map lireURL lae

slaveStat = do
    lireURL
    getWordsFile
    Stemming
    Stat.statisticsSeasonEpisodeText
-}

















{-
traitement.hs
module TraitementStatistiques where

import qualified LireArgumentMaitre as LAM
import qualified LireArgumentEsclave as LAE
import qualified LireURLJson as LUJ
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat
import qualified KeyWordOccurrence as KWO
import qualified Sort as Sort

import qualified Data.Text as DT

reconstructionURL :: IO ()
reconstructionURL =
    let args = ["ip","port","Ned","GoT","3","3","2"] in
    let lam = LAM.lireArgumentMaitre args in -- [["ip","port","Ned","GoT","1","3"],["ip","port","Ned","GoT","2","3"],["ip","port","Ned","GoT","3","2"]]
    let lae = map (LAE.lireArgumentEsclave) lam in -- [[("Ned","ip:port/GoT/1/1"),("Ned","ip:port/GoT/1/2"),("Ned","ip:port/GoT/1/3")],[("Ned","ip:port/GoT/2/1"),("Ned","ip:port/GoT/2/2"),("Ned","ip:port/GoT/2/3")],[("Ned","ip:port/GoT/3/1"),("Ned","ip:port/GoT/3/2")]]
    writeFile "tmp.txt" (show lae)

{-
    let args = "jsonSansNuageDeMots.json" in
    let luj = map (LUJ.lireURLJson) $ map (LUJ.lireURLJson) lae in
    writeFile "tmp.txt" lj

-}

traitementStatistiques :: String -> IO ()
traitementStatistiques resume =
--    let resume = "\"Jon, the Hand King, an army.\"" in
    let gwf = GWF.getWordsFile resume in
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in
    Stat.statistics ps "statistics.txt"

traitementKeyWord :: String -> String -> Int
traitementKeyWord keyword resume =
    let gwf = GWF.getWordsFile resume in
    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) in
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in
    KWO.keyWordOccurrence kw ps


-- sort

-- Sort.chronogicalSortToJSON [[(1,1,2),(1,2,3)],[(2,1,4),(2,2,3)],[(3,1,2),(3,2,1)]] -> {"1" : [2,3], "2" : [4,3], "3" : [2,1]}

-- Sort.sortBySeasonToJSON [[(1,1,2),(1,2,3)],[(2,1,4),(2,2,3)],[(3,1,2),(3,2,1)]] -> {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}

-- Sort.sortByRelevanceToJSON [(1,2,3),(1,1,3),(1,3,4),(2,1,4),(2,2,3),(2,3,4)] -> {"1_3" : 4, "2_1" : 4, "2_3" : 4, "1_1" : 3, "1_2" : 3, "2_2" : 3}

-}