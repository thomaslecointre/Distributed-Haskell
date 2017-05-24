module Traitement (main) where

import qualified LireArgumentMaitre as LAM
import qualified LireArgumentEsclave as LAE
import qualified LireURLJson as LUJ
import qualified LireJsonv6 as LJ
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat

main = do
--    LAM.main
--    LAE.main
--    LUJ.main
    LJ.main
    GWF.main
    PS.main
    Stat.main
    
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