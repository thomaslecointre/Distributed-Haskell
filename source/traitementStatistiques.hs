module TraitementStatistiques where

import qualified LireArgumentMaitre as LAM
import qualified LireArgumentEsclave as LAE
import qualified LireURLJson as LUJ
import qualified LireJsonv6 as LJ
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat

traitementStatistiques1 :: IO ()
traitementStatistiques1 =
    let args = ["ip","port","Ned","GoT","3","3","2"] in
    let lam = LAM.lireArgumentMaitre args in -- [["ip","port","Ned","GoT","1","3"],["ip","port","Ned","GoT","2","3"],["ip","port","Ned","GoT","3","2"]]
    let lae = map (LAE.lireArgumentEsclave) lam in -- [[("Ned","ip:port/GoT/1/1"),("Ned","ip:port/GoT/1/2"),("Ned","ip:port/GoT/1/3")],[("Ned","ip:port/GoT/2/1"),("Ned","ip:port/GoT/2/2"),("Ned","ip:port/GoT/2/3")],[("Ned","ip:port/GoT/3/1"),("Ned","ip:port/GoT/3/2")]]
    writeFile "tmp.txt" (show lae)
--    let luj = map (LUJ.lireURLJson) $ map (LUJ.lireURLJson) lae in

--traitementStatistiques2 :: String -> ...
traitementStatistiques2 =
    let args = "jsonSansNuageDeMots.json" in
    let lj = LJ.lireJsonv6 args in
    writeFile "tmp.txt" (show lj)
--    let gwf = GWF.getWordsFile lj in
--    let ps = PS.porterStemmer gwf in
--    Stat.statisticsv2


--    lireArgumentMaitre.hs www.test.org 8080 Ned GoT 10 10 10 10 7
    -- -> [["www.test.org","8080","Ned","GoT","1","10"], ["www.test.org","8080","Ned","GoT","2","10"], ... ["www.test.org","8080","Ned","GoT","5","7"]]
--    lireArgumentEsclave.hs www.test.org 8080 Ned GoT 1 10
    -- -> [("Ned", "www.test.org:8080/GoT/1/1"),("Ned", "www.test.org:8080/GoT/1/2"), ... ("Ned", "www.test.org:8080/GoT/1/10")]
--    lireURLJson.hs www.test.org:8080/GoT/1/1
    -- -> tmp.json ou jsonSansNuageDeMots.json
--    lireJsonv6.hs jsonSansNuageDeMots.json
    -- -> tmp2.txt
--    getWordsFile.hs tmp2.txt
    -- -> tmp3.txt
--    PorterStemmer.hs tmp3.txt
    -- -> tmp4.txt
--    Statistics2.hs tmp4.txt
    -- -> statistics.txt
    
--    filtre
--    return