import Network.HTTP
import System.Environment

openURL x = getResponseBody =<< simpleHTTP (getRequest x)

main = do
    args <- getArgs
    case args of 
      reference -> do
        let saison = "1"
        src <- openURL ("http://www.imdb.com/title/" ++ reference ++ "/episodes?season=1&ref_=tt_eps_sn_" ++ saison)
        writeFile (reference ++ ".html")
      _ -> putStrLn "Wrong number of arguments"

{-
Main.nameSerie.add("Game of Thrones");
Main.referenceSerie.add("tt0944947");
Main.nameSerie.add("Breaking Bad");
Main.referenceSerie.add("tt0903747");
Main.nameSerie.add("Skins");
Main.referenceSerie.add("tt0840196");
Main.nameSerie.add("How I Met Your Mother");
Main.referenceSerie.add("tt0460649");
Main.nameSerie.add("Misfits");
Main.referenceSerie.add("tt1548850");
Main.nameSerie.add("NCIS: Enquêtes spéciales");
Main.referenceSerie.add("tt0364845");
Main.nameSerie.add("Mentalist");
Main.referenceSerie.add("tt1196946");
Main.nameSerie.add("Bones");
Main.referenceSerie.add("tt0460627");
Main.nameSerie.add("13 Reasons Why");
Main.referenceSerie.add("tt1837492");
-}