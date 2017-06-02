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
