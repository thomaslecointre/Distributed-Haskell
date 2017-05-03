import Data.List
import Network.HTTP

openURL x = getResponseBody =<< simpleHTTP (getRequest x)

main = do src <- openURL "http://haskell.org/haskellwiki/Haskell"
          writeFile "temp.htm" src

