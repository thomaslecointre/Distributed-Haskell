import qualified Network as N
import qualified ArgumentsParser as AP
import qualified Network.Download as ND
import System.IO
import System.Environment
import Control.Concurrent
import Data.String
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import System.Environment
import Data.String
import Network.HTTP.Client
import Network.HTTP.Types.Status (statusCode)

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
    -- let work = process order -- !!!
    let parsedArguments = map AP.parseArguments order
    let urls = map extractURLs parsedArguments
    descriptions <- (mapM . mapM) ( \url -> do
                                    manager <- newManager defaultManagerSettings
                                    request <- parseRequest url
                                    response <- httpLbs request manager
                                    return $ BL.unpack $ responseBody response ) urls
    
    -- ...
    handle <- N.connectTo "185.167.204.218" (N.PortNumber 4446)
    hSetBuffering handle LineBuffering
    -- hPutStrLn handle work
    hClose handle

extractURLs :: [(String, Int, Int, String)] -> [String]
extractURLs [] = []
extractURLs (x:xs) = (getURL x) : (extractURLs xs)

getURL :: (String, Int, Int, String) -> String
getURL (_,_,_,u) = u