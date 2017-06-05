module Traitementv2 where

import qualified LireArgumentMaitre as LAM
import qualified LireArgumentEsclavev2 as LAE
import qualified LireURLJson as LUJ
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat
import qualified KeyWordOccurrence as KWO
import qualified Sort as Sort

import qualified Data.Text as DT

masterShareSeason :: [[String]]
masterShareSeason =
    let args = ["ip","port","Ned","GoT","3","3","2"] in
    LAM.lireArgumentMaitre args -- [["ip","port","Ned","GoT","1","3"],["ip","port","Ned","GoT","2","3"],["ip","port","Ned","GoT","3","2"]]





slaveProcessEpisode :: (String, Int, Int, String) -> (Int, Int,Int)
slaveProcessEpisode (keyword, season, episode, url) =
    -- let luj = LUJ.lireURL url in -- "\"Jon, the Hand of the King, ... an army.\""
    let luj = "\"Jon, the Hand of the King, ... an army.\"" in
    let gwf = GWF.getWordsFile luj in -- "Jon the Hand of the King ... an army"
    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) in -- root of the keyword
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    (season, episode, KWO.keyWordOccurrence kw ps)

slaveProcess :: [(Int,Int,Int)]
slaveProcess =
    let args = ["ip","port","Ned","GoT","1","3"] in
    -- let args = ["ip","port","Jon","GoT","1","3"] in
    let lae = LAE.lireArgumentEsclave args in -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    map slaveProcessEpisode lae

slaveChronologicalSort :: String
slaveChronologicalSort =
    let args = ["ip","port","Ned","GoT","1","3"] in
    -- let args = ["ip","port","Jon","GoT","1","3"] in
    let lae = LAE.lireArgumentEsclave args in -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    let seo = map slaveProcessEpisode lae in
    Sort.chronogicalSort seo -- "1" : [2,3], "2" : [4,3], "3" : [2,1]}

slaveSortBySeason :: String
slaveSortBySeason =
    let args = ["ip","port","Ned","GoT","1","3"] in
    -- let args = ["ip","port","Jon","GoT","1","3"] in
    let lae = LAE.lireArgumentEsclave args in -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    let seo = map slaveProcessEpisode lae in
    Sort.sortBySeason seo -- {"1" : [{ "2" : 3 }, { "1" : 2 }], "2" : [{ "1" : 4 }, { "2" : 3 }], "3" : [{ "1" : 2 }, { "2" : 1 }]}

slaveSortByRelevanceToJson :: String
slaveSortByRelevanceToJson =
    let args = ["ip","port","Ned","GoT","1","3"] in
    -- let args = ["ip","port","Jon","GoT","1","3"] in
    let lae = LAE.lireArgumentEsclave args in -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    let seo = map slaveProcessEpisode lae in
    Sort.sortByRelevanceToJSON seo -- {"1_3" : 4, "2_1" : 4, "2_3" : 4, "1_1" : 3, "1_2" : 3, "2_2" : 3}



{-
--slaveStatisticsProcessEpisode :: (String, Int, Int, String) -> IO ()
slaveStatisticsProcessEpisode (keyword, season, episode, url) =
    -- let luj = LUJ.lireURL url in -- "\"Jon, the Hand of the King, ... an army.\""
    let luj = "\"Jon, the Hand of the King, ... an army.\"" in
    let gwf = GWF.getWordsFile luj in -- "Jon the Hand of the King ... an army"
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    Stat.statistics ps ("statistics" ++ show season ++ "_" ++ show episode ++ ".txt")

-- slaveStatisticsProcess :: [IO ()]
slaveStatisticsProcess = do
    let args = ["ip","port","Ned","GoT","1","3"]
    let lae = LAE.lireArgumentEsclave args -- [("Ned",1,1,"ip:port/GoT/1/1"),("Ned",1,2,"ip:port/GoT/1/2"),("Ned",1,3,"ip:port/GoT/1/3")]
    map slaveStatisticsProcessEpisode lae
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