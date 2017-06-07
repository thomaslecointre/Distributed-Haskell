import qualified Network as N
import System.IO
import System.Environment
import Control.Concurrent
import Data.String
import Control.Monad

main :: IO ()
main = do
    print $ "Connecting to Master @185.167.204.218:4444"
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
    writeChan incomingOrder order
    receiveOrder handle incomingOrder

-- | Reads and executes next order
executeOrder :: Chan [[String]] -> IO ()
executeOrder incomingOrder = do
	order <- readChan incomingOrder
	let work = process order -- !!!
	handle <- N.connectTo "185.167.204.218" (N.PortNumber 4446)
	hSetBuffering handle 
    hPutStrLn handle work
	hClose handle
