{-# LANGUAGE DeriveGeneric #-}

import qualified Network as N
import Network.HTTP.Client
import Network.Socket

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
    ip <- getArgs
    let ip' = ip !! 0
    print $ "Connecting to Master @" ++ ip' ++ ":4444" 
    handle <- N.connectTo ip' (N.PortNumber 4444)
    putStrLn "Connected"
    incomingOrder <- newChan
    outgoingOrder <- newChan
    socket <- N.listenOn (N.PortNumber 5000)
    forkIO $ receiveOrder incomingOrder socket
    forkIO $ executeOrder incomingOrder outgoingOrder ip'
    forkIO $ forever $ sendWork outgoingOrder ip'
    forever $ do
        putStrLn "Slave is active..."
        threadDelay 500000

-- |Receives and broadcasts next order on incomingOrder channel
receiveOrder    :: Chan [[String]]  -- ^ Channel used to broadcast incoming order
                -> N.Socket         -- ^ Socket used to accept orders from Master
                -> IO ()            
receiveOrder incomingOrder socket = do
    (handle, host, port) <- N.accept socket
    putStrLn "Receiving orders..."
    code <- hGetLine handle
    let order = read code :: [[String]]
    print $ "Order received : " ++ show order
    writeChan incomingOrder order
    hClose handle
    receiveOrder incomingOrder socket

-- | Reads and executes next order
executeOrder    :: Chan [[String]]  -- ^ Channel used to broadcast incoming order
                -> Chan String      -- ^ Channel used to transfer completed order to socket used for sending work back to Master
                -> String           -- ^ IP address of Master
                -> IO ()
executeOrder incomingOrder outgoingOrder ip = do
    order <- readChan incomingOrder
    let parsedArguments = map (AP.parseArguments ip) order 
    let urls = map extractURLs parsedArguments
    putStrLn "Attempting to download all contents"
    contents <- getAllContent urls
    putStrLn "All descriptions downloaded"
    let work = process parsedArguments contents
    writeChan outgoingOrder work
    executeOrder incomingOrder outgoingOrder ip

-- |Sends the work done to the master
sendWork    :: Chan String  -- ^ Channel where completed work is found
            -> String       -- ^ IP address of Master
            -> IO ()        
sendWork outgoingOrder ip = do
    work <- readChan outgoingOrder
    handle <- N.connectTo ip (N.PortNumber 4446)
    putStrLn "Attempting to send work back"
    hPutStrLn handle work
    putStrLn "Work sent back"
    hClose handle
    
-- |Gets all forth elements of a list of tuples of 4 elements
extractURLs :: [(String, Int, Int, String)] -- ^ A list of tuples like [(keyword, season, episode, url)]
            -> [String]                     -- ^ A list of String : [url]
extractURLs [] = []
extractURLs (x:xs) = (getURL x) : (extractURLs xs)

-- |Gets the forth element of a tuple of 4 elements
getURL  :: (String, Int, Int, String)   -- ^ A tuple like (keyword, season, episode, url)
        -> String                       -- ^ A String : url
getURL (_,_,_,u) = u

-- |Executes GET request
get :: String       -- ^ The url to be downloaded
    -> IO String    -- ^ The content of the url
get url = do
    manager <- newManager defaultManagerSettings
    request <- parseRequest url
    response <- httpLbs request manager
    return $ BL.unpack $ responseBody response

-- |Executes a list of lists of GET requests
getAllContent   :: [[String]]       -- ^ A list of lists of url to be downloaded
                -> IO [[String]]    -- ^ A list of lists of contents of url
getAllContent [] = return []
getAllContent (s:sx) = do
    c <- getContent s
    cx <- getAllContent sx
    return (c:cx)

-- |Executes a list of GET requests
getContent  :: [String]     -- ^ A list of url to be downloaded
            -> IO [String]  -- ^ A list of contents of url
getContent [] = return []
getContent (e:ex) = do
    c <- get e
    cx <- getContent ex
    return (c:cx)

-- |Exchanges the forth element of a list of lists of tuples with an element of another list of lists
updateAllContent    :: [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples [[(keyword, season, episode, url)]]
                    -> [[String]]                       -- ^ A list of lists of String [[body]]
                    -> [[(String, Int, Int, String)]]   -- ^ A list of lists which is exchanged the forth element with the other list of lists [[(keyword, season, episode, body)]]
updateAllContent [] _ = []
updateAllContent (x:xs) (y:ys) = (updateContent x y) : (updateAllContent xs ys)

-- |Exchanges the forth element of a list of tuples with an element of another list
updateContent   ::  [(String, Int, Int, String)]    -- ^ A list of tuples [(keyword, season, episode, url)]
                -> [String]                         -- ^ A list of String [body]
                -> [(String, Int, Int, String)]     -- ^ A list which is exchanged the forth element with the other list [(keyword, season, episode, body)]
updateContent [] [] = []
updateContent ((a,b,c,url):xs) (body:ys) = (a, b, c, body) : (updateContent xs ys)

-- |Returns the first element of the head of a list of lists of tuples
getKeyword  :: [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples like [[(keyword, season, episode, url)]]
            -> String                           -- ^ The first element of the tuples : keyword
getKeyword [] = ""
getKeyword (((keyword,_,_,_):_):_) = keyword

-- |Returns a process depending on a keyword ("N/A" returns the number of occurrences of every words, a keyword returns the number of occurrences of this word)
process :: [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples like [[(keyword, season, episode, url)]]
        -> [[String]]                       -- ^ A list of lists with the text to stem [[a JSON content]]
        -> String                           -- ^ a JSON content containing the results of the process depending on the keyword
process parsedArguments descriptions = do
    let updatedContent = updateAllContent parsedArguments descriptions
    if getKeyword updatedContent == "N/A"
        then show $ statisticProcess updatedContent
        else show $ map processEachSeason updatedContent


-- |Returns a list of list of String with the season number, the episode number, and a list of pairs ("word", occurrence number)
statisticProcess    :: [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples with the text to stem [[("N/A", season, episode, a JSON content)]]
                    -> [[String]]                       -- ^ A list like [["1,1,[("a",1),("b",2)]","1,2,[("d",1)]"],["2,1,[("f",1),("g",2)]","2,2,[("i",1)]"]]
statisticProcess l = Stat.statisticsEachSlave $ statisticProcessAllSeason l

-- |On a list of lists, deletes the stopwords of every text, applies the Stemming algorithm and returns all stemmed words
statisticProcessAllSeason   :: [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples with the text to stem [[("N/A", season, episode, a JSON content)]]
                            -> [[(String, Int, Int, String)]]   -- ^ A list of lists of tuples with all stemmed words [[("N/A", season, episode, text composed of stemmed words)]]
statisticProcessAllSeason l = map statisticProcessEachSeason l

-- |On a list, deletes the stopwords of every text, applies the Stemming algorithm and returns all stemmed words
statisticProcessEachSeason  :: [(String, Int, Int, String)] -- ^ A list of tuples with the text to stem [("N/A", season, episode, a JSON content)]
                            -> [(String, Int, Int, String)] -- ^ A list of tuples with all stemmed words [("N/A", season, episode, text composed of stemmed words)]
statisticProcessEachSeason l = map statisticProcessEachEpisode l

-- |Deletes the stopwords of a text, applies the Stemming algorithm and returns all stemmed words
statisticProcessEachEpisode :: (String, Int, Int, String)   -- ^ A tuple with the text to stem ("N/A", season, episode, a JSON content) like ("N/A", 1, 1, text)
                            -> (String, Int, Int, String)   -- ^ A tuple with all stemmed words ("N/A", season, episode, text composed of stemmed words) like ("N/A", 1, 1, text)
statisticProcessEachEpisode (a,b,c,text) =
    let gwf = GWF.getWordsFile text in
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in -- "jon\nhand\nking\n...\narmi\n"
    (a,b,c,ps)
    
    
data Serie = Serie { season :: Int, name :: String, episode :: Int, plot :: String }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

-- |On a list, extracts a data, takes a part of a JSON content and returns a list with the number of occurrence of a keyword in a text with the Stemming algorithm
processEachSeason   :: [(String, Int, Int, String)] -- ^ A list of tuples (keyword, season, episode, a JSON content) like ("jon", 1, 1, text)
                    -> [[Int]]                      -- ^ A list of lists composed of 3 Int [season, episode, occurrence] like [1,1,7]
processEachSeason [] = []
processEachSeason (x:xs) = (processEachEpisode x) : (processEachSeason xs) -- [("jon",1,1,"jon"),("jon",1,1,"jon jon"),("jon",1,1,"jon jon jon")]

-- |Converts body to a data and applies the Stemming algorithm on the plot
processEachEpisode  :: (String, Int, Int, String)   -- ^ A tuple (keyword, season, episode, a JSON content) like ("jon", 1, 1, text)
                    -> [Int]                        -- ^ A list composed of 3 Int [season, episode, occurrence] like [1,1,7]
processEachEpisode (keyword, season, episode, body) = do
    let req = decode $ BL.pack body :: Maybe Serie
    case req :: Maybe Serie of
        Nothing  -> []
        Just req -> stemmingProcess (keyword, season, episode, (show.plot) req)

-- |Suppresses stopwords, stems the keyword and the text, and returns a triplet with the two Int and the number of occurrence of the first argument in the text of the forth argument
stemmingProcess :: (String, Int, Int, String)   -- ^ A tuple (keyword, season, episode, text) like ("jon", 1, 1, "Jon the Hand of the King ... an army")
                -> [Int]                        -- ^ A list composed of 3 Int [season, episode, occurrence] like [1,1,7]
stemmingProcess (keyword, season, episode, text) =
    let gwf = GWF.getWordsFile text in
    let kw = (DT.unpack . DT.toLower . DT.pack) (lines (PS.porterStemmer keyword) !! 0) in
    let ps = DT.unpack . DT.toLower . DT.pack $ PS.porterStemmer gwf in
    [season,episode,KWO.keyWordOccurrence kw ps]

