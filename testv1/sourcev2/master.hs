import Network.HTTP
import System.Environment
import GHC.IO.Encoding
import Text.HTML.TagSoup

openURL :: [Char] -> IO String
openURL x = getResponseBody =<< simpleHTTP (getRequest x)

main :: IO()
main = do
    setLocaleEncoding utf8
    args <- getArgs
    case args of 
      reference -> do
        src <- openURL ("http://www.imdb.com/title/" ++ (reference !! 0) ++ "/episodes?season=" ++ (reference !! 1))
        writeFile ((reference !! 0) ++ ".html") src

{-
"Game of Thrones", "tt0944947"
"Breaking Bad", "tt0903747"
"Skins", "tt0840196"
"How I Met Your Mother", "tt0460649"
"Misfits", "tt1548850"
"NCIS: Enquêtes spéciales", "tt0364845"
"Mentalist", "tt1196946"
"Bones", "tt0460627"
"13 Reasons Why", "tt1837492"
-}