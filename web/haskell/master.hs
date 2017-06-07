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
    orders <- newEmptyMVar
    registering <- newChan
    registered <- newMVar []
    workStatus <- newEmptyMVar
    forkIO $ receiveOrders orders
    forkIO $ receiveRegistrations registering
    forkIO $ sortRegistrations registering registered
    -- forkIO $ sendOrders orders registered
    -- forkIO $ receiveWork
    forever $ do
        putStrLn "Master is active..."
        threadDelay 5000000

receiveOrders :: MVar [String] -> IO ()
receiveOrders orders = do
    socket <- N.listenOn (N.PortNumber 4445)
    putStrLn "Receiving orders on 4445..."
    handleOrders socket orders
    
handleOrders :: N.Socket -> MVar [String] -> IO ()
handleOrders socket orders = do
    (handle, host, port) <- N.accept socket
    hSetBuffering handle LineBuffering
    code <- hGetLine handle
    let order = read code :: [String]
    print $ "Received orders : " ++ (show order)
    putMVar orders order

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

sendOrders :: MVar [String] -> MVar [NS.SockAddr] -> IO ()
sendOrders orders registered = do
    orders' <- takeMVar orders -- Needs to be placed back
    registered' <- takeMVar registered -- Needs to be placed back
    let numberOfRegistered = length registered'
    let parsedOrders = OD.ParseArguments orders'
    if numberOfRegistered > 0
        then dispatchOrders numberOfRegistered parsedOrders registered'
        else putStrLn "No slaves available!"

{-
    Number of slaves available
    IP table
    Number of seasons
    Parsed orders
-}
dispatchOrders :: Int -> [String] -> Int -> [[String]] -> IO ()
dispatchOrders _ _ 0 _              = putStrLn "All orders dispatched"
dispatchOrders 0 _ n _              = if n > 0
                                        then 
dispatchOrders n (x:xs) m (y:ys)    = do
                                    dispatchOrder x y
                                    dispatchOrders n-1 xs m-1 ys

{-
    Order
    IP Address
-}
dispatchOrder :: [String] -> String -> IO ()
dispatchOrder o a = do
    handle <- N.connectTo a (N.PortNumber 5000)
    handle hPutStrLn (show o)
    hClose handle