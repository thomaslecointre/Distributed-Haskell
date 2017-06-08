{-# LANGUAGE DeriveGeneric #-}

import qualified Network as N
import qualified ArgumentsParser as AP
import System.IO
import System.Environment
import Control.Concurrent
import Data.String
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import System.Environment
import Data.String
import Network.HTTP
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.Text as DT
import qualified GetWordsFilev2 as GWF
import qualified PorterStemmer as PS
import qualified Statisticsv2 as Stat
import qualified KeyWordOccurrence as KWO

main :: IO ()
main = do
    print "Connecting to Master @185.167.204.218:4444"
    handle <- N.connectTo "185.167.204.218" (N.PortNumber 4444)
    putStrLn "Connected"
    socket <- N.listenOn (N.PortNumber 5000)
    incomingOrder <- newChan
    (handle, host, port) <- N.accept socket
    hSetBuffering handle LineBuffering
    forkIO $ receiveOrder handle incomingOrder
    forkIO $ executeOrder incomingOrder
    forever $ do
        putStrLn "Slave is active..."
        threadDelay 5000000
		
-- |Receives and broadcasts next order on incomingOrder channel
receiveOrder :: Handle -> Chan [[String]] -> IO ()
receiveOrder handle incomingOrder = do
    code <- hGetLine handle
    let order = read code :: [[String]]
    print $ "Order received : " ++ show order
    writeChan incomingOrder order
    receiveOrder handle incomingOrder

-- | Reads and executes next order
executeOrder :: Chan [[String]] -> IO ()
executeOrder incomingOrder = do
 order <- readChan incomingOrder

 let parsedArguments = map AP.parseArguments order
 let urls = map extractURLs parsedArguments
 descriptions <- getAllContent urls
 let updatedContent = updateAllContent parsedArguments descriptions
 let tabtabSeasonEpisodeOccurrence = map processEachSeason updatedContent
 putStrLn ""
 {-
 handle <- N.connectTo "185.167.204.218" (N.PortNumber 4446)
 hSetBuffering handle LineBuffering
 -- hPutStrLn handle work
 hClose handle
 -}

extractURLs :: [(String, Int, Int, String)] -> [String]
extractURLs [] = []
extractURLs (x:xs) = (getURL x) : (extractURLs xs)

getURL :: (String, Int, Int, String) -> String
getURL (_,_,_,u) = u

get 	:: String -> IO String
get url = simpleHTTP (getRequest url) >>= getResponseBody

getAllContent 			:: [[String]] -> IO [[String]]
getAllContent (s:sx)  	= do
 c <- getContent s
 cx <- getAllContent sx
 return (c:cx)

getContent 			:: [String] -> IO [String]
getContent (e:ex) = do
 c <- get e
 cx <- getContent ex
 return (c:cx)

updateAllContent :: [[(String, Int, Int, String)]] -> [[String]] -> [[(String, Int, Int, String)]]
updateAllContent [] _ = []
updateAllContent (x:xs) (y:ys) = do
 (updateContent x y) : (updateAllContent xs ys)

updateContent ::  [(String, Int, Int, String)] -> [String] -> [(String, Int, Int, String)]
updateContent [] [] = []
updateContent ((a,b,c,url):xs) (body:ys) = (a, b, c, body) : (updateContent xs ys)


data Serie = Serie { season :: Int, name :: String, episode :: Int, plot :: String }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

processEachSeason :: [(String, Int, Int, String)] -> [[Int]]
processEachSeason [] = []
processEachSeason (x:xs) = (processEachEpisode x) : (processEachSeason xs) -- [("jon",1,1,"jon"),("jon",1,1,"jon jon"),("jon",1,1,"jon jon jon")]

processEachEpisode :: (String, Int, Int, String) -> [Int] 
processEachEpisode (keyword, season, episode, body) = do
    let req = decode $ BL.pack body :: Maybe Serie
    case req :: Maybe Serie of
        Nothing -> do
                --putStrLn "Couldn't load the JSON data from decode Aeson"
                []
        Just req -> do
                    stemmingProcess (keyword, season, episode, (show.plot) req)

{-
    Entree :
        - keyword
        - season
        - episode
        - text
        ex : ("jon", 1, 1, "Jon the Hand of the King ... an army")
    Sortie :
        [Int] (season, episode, occurrence)
-}
stemmingProcess :: (String, Int, Int, String) -> [Int]
stemmingProcess (keyword, season, episode, text) = --let (keyword, season, episode, req) = ("jon", 1, 1, "Jon the Hand of the King ... an army") in
    let gwf = GWF.getWordsFile text in
    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) in -- root of the keyword
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    [season,episode,KWO.keyWordOccurrence kw ps]

