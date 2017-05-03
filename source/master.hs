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