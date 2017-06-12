{-# LANGUAGE DeriveGeneric #-}

import qualified Network as N
import Network.HTTP.Client

import System.IO
import System.Environment

import Control.Concurrent
import Control.Monad

import qualified Data.ByteString.Lazy.Char8 as BL
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import Data.String

import GHC.Generics (Generic)

import qualified ArgumentsParser as AP
import qualified Data.Text as DT
import qualified GetWordsFile as GWF
import qualified PorterStemmer as PS
import qualified StatisticsSlave as Stat
import qualified KeyWordOccurrence as KWO

main :: IO ()
main = do
    print "Connecting to Master @10.57.110.10:4444"
    handle <- N.connectTo "10.57.110.10" (N.PortNumber 4444)
    putStrLn "Connected"
    socket <- N.listenOn (N.PortNumber 5000)
    incomingOrder <- newChan
    outgoingOrder <- newChan
    (handle, host, port) <- N.accept socket
    hSetBuffering handle LineBuffering
    forkIO $ receiveOrder handle incomingOrder
    forkIO $ executeOrder incomingOrder outgoingOrder
    forkIO $ prepareToSendWork outgoingOrder
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
    -- receiveOrder handle incomingOrder

-- | Reads and executes next order
executeOrder    :: Chan [[String]] 
                -> Chan String 
                -> IO ()
executeOrder incomingOrder outgoingOrder = do
    order <- readChan incomingOrder
    let parsedArguments = map AP.parseArguments order
    let urls = map extractURLs parsedArguments
    putStrLn "Attempting to download all contents"
    contents <- getAllContent urls
    putStrLn "All descriptions downloaded"
    let work = process parsedArguments contents
    writeChan outgoingOrder work
    executeOrder incomingOrder outgoingOrder

prepareToSendWork :: Chan String -> IO ()
prepareToSendWork outgoingOrder = do
    handle <- N.connectTo "10.57.110.10" (N.PortNumber 4446)
    forever $ sendWork outgoingOrder handle
    
sendWork :: Chan String -> Handle -> IO ()
sendWork outgoingOrder handle = do
    work <- readChan outgoingOrder
    putStrLn "Attempting to send work back"
    hPutStrLn handle work
    putStrLn "Work sent back"
    
extractURLs :: [(String, Int, Int, String)] -> [String]
extractURLs [] = []
extractURLs (x:xs) = (getURL x) : (extractURLs xs)

getURL :: (String, Int, Int, String) -> String
getURL (_,_,_,u) = u

get :: String -> IO String
get url = do
    manager <- newManager defaultManagerSettings
    request <- parseRequest url
    response <- httpLbs request manager
    return $ BL.unpack $ responseBody response

getAllContent :: [[String]] -> IO [[String]]
getAllContent [] = return []
getAllContent (s:sx) = do
    c <- getContent s
    cx <- getAllContent sx
    return (c:cx)

getContent :: [String] -> IO [String]
getContent [] = return []
getContent (e:ex) = do
    c <- get e
    -- print $ "Content successfully downloaded : " ++ c
    cx <- getContent ex
    return (c:cx)

updateAllContent :: [[(String, Int, Int, String)]] -> [[String]] -> [[(String, Int, Int, String)]]
updateAllContent [] _ = []
updateAllContent (x:xs) (y:ys) = (updateContent x y) : (updateAllContent xs ys)

updateContent ::  [(String, Int, Int, String)] -> [String] -> [(String, Int, Int, String)]
updateContent [] [] = []
updateContent ((a,b,c,url):xs) (body:ys) = (a, b, c, body) : (updateContent xs ys)

getKeyword :: [[(String, Int, Int, String)]] -> String
getKeyword [] = ""
getKeyword (((keyword,_,_,_):_):_) = keyword

process :: [[(String, Int, Int, String)]] -> [[String]] -> String
process parsedArguments descriptions = do
    let updatedContent = updateAllContent parsedArguments descriptions
    if getKeyword updatedContent == "N/A"
        then show $ statisticProcess updatedContent
        else show $ map processEachSeason updatedContent


statisticProcess :: [[(String, Int, Int, String)]] -> [[String]]
statisticProcess l = Stat.statisticsEachSlave $ statisticProcessAllSeason l

statisticProcessAllSeason :: [[(String, Int, Int, String)]] -> [[(String, Int, Int, String)]]
statisticProcessAllSeason l = map statisticProcessEachSeason l

statisticProcessEachSeason :: [(String, Int, Int, String)] -> [(String, Int, Int, String)]
statisticProcessEachSeason l = map statisticProcessEachEpisode l

statisticProcessEachEpisode :: (String, Int, Int, String) -> (String, Int, Int, String)
statisticProcessEachEpisode (a,b,c,text) =
    let gwf = GWF.getWordsFile text in
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    (a,b,c,ps)
    
    
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
        Nothing  -> []
        Just req -> stemmingProcess (keyword, season, episode, (show.plot) req)

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

