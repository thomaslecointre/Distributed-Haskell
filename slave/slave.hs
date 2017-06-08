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



