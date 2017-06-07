import qualified Network as N
import qualified Network.Socket as NS
import qualified Utils as U
import qualified OrderDistribution as OD
import System.IO
import System.Environment
import Control.Concurrent
import Data.String
import Control.Monad

main = do
    orders <- newChan
    registering <- newChan
    registered <- newMVar []
    workStatus <- newChan
    forkIO $ receiveOrders orders workStatus
    forkIO $ receiveRegistrations registering
    forkIO $ sortRegistrations registering registered
    forkIO $ sendOrders orders registered
    forkIO $ receiveWork workStatus
    forever $ do
        putStrLn "Master is active..."
        threadDelay 5000000

-- |Receives connections from messengers
receiveOrders :: Chan [String] -> Chan String -> IO ()
receiveOrders orders workStatus = do
    socket <- N.listenOn (N.PortNumber 4445)
    putStrLn "Receiving orders on 4445..."
    forever $ N.accept socket >>= handleOrders orders workStatus
   
{-|
	Reads order from messenger and broadcasts order to orders channel. 
	Upon order's completion or failure, the function sends a status reply to messenger.
-}
handleOrders :: Chan [String] -> Chan String -> (N.Handle, N.HostName, N.PortNumber) -> IO ()
handleOrders orders workStatus (handle, hostName, portNumber) = do
    hSetBuffering handle LineBuffering
    code <- hGetLine handle
    let order = read code :: [String]
    print $ "Received orders : " ++ (show order)
    writeChan orders order
    status <- readChan workStatus -- OK or KO
    hPutStrLn handle status 
    hClose handle

receiveRegistrations :: Chan String -> IO ()
receiveRegistrations registering = do
    socket <- N.listenOn (N.PortNumber 4444)
    putStrLn "Receiving registrations on 4444..."
    forever $ NS.accept socket >>= (handleRegistrations registering)

handleRegistrations :: Chan String -> (NS.Socket, NS.SockAddr) -> IO ()
handleRegistrations registering (socket, sockaddr) = do
    let socketAddress = sockaddr
    let ipAddress = U.stripIP socketAddress
    print $ "New slave registering from " ++ ipAddress
    writeChan registering ipAddress

sortRegistrations :: Chan String -> MVar [String] -> IO()
sortRegistrations registering registered = do
    newAddress <- readChan registering
    registered' <- takeMVar registered
    if (elem newAddress registered')
        then do
            putMVar registered registered'
            sortRegistrations registering registered
        else do
            let currentlyRegistered = registered' ++ [newAddress]
            print $ "Slaves currently registered : " ++ (show currentlyRegistered)
            putMVar registered currentlyRegistered
            sortRegistrations registering registered

sendOrders :: Chan [String] -> MVar [NS.SockAddr] -> IO ()
sendOrders orders registered = do
    registered' <- takeMVar registered -- Needs to be placed back
    let numberOfRegistered = length registered'
    if numberOfRegistered > 0
        then do
            orders' <- readChan orders
            let parsedOrders = OD.parseArguments orders' numberOfRegistered
            dispatchOrders parsedOrders registered'
            putMVar registered registered'
        else putStrLn "No slaves available!"

{-
    Parsed orders
    IP table
-}
dispatchOrders :: [[String]] -> [String] -> IO ()
dispatchOrders (x:xs) (y:ys) = do
	dispatchOrder x y
	dispatchOrders xs ys

{-
    Order
    IP Address
-}
dispatchOrder :: [String] -> String -> IO ()
dispatchOrder o a = do
    handle <- N.connectTo a (N.PortNumber 5000)
    hSetBuffering handle LineBuffering
    handle hPutStrLn (show o)
    hClose handle
	
receiveWork :: 