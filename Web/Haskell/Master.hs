import qualified Network as N
import qualified Network.Socket as NS
import System.IO
import System.Environment
import Control.Concurrent
import Data.String
import Control.Concurrent.MVar
import Control.Monad

main = do
    orders <- newEmptyMVar
    registering <- newChan
    registered <- newMVar []
    workStatus <- newEmptyMVar
    forkIO $ receiveOrders orders
    forkIO $ receiveRegistrations registering
    forkIO $ sortRegistrations registering registered
    -- forkIO $ sendOrders
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
    putMVar orders order

receiveRegistrations :: Chan NS.SockAddr -> IO ()
receiveRegistrations registering = do
    socket <- N.listenOn (N.PortNumber 4444)
    putStrLn "Receiving registrations on 4444..."
    forever $ NS.accept socket >>= (handleRegistrations registering)

handleRegistrations :: Chan NS.SockAddr -> (NS.Socket, NS.SockAddr) -> IO ()
handleRegistrations registering (socket, sockaddr) = do
    let newAddress = sockaddr
    writeChan registering newAddress

sortRegistrations :: Chan NS.SockAddr -> MVar [NS.SockAddr] -> IO()
sortRegistrations registering registered = do
    newAddress <- readChan registering
    registered' <- takeMVar registered
    if (elem newAddress registered')
        then do
            putMVar registered registered'
            sortRegistrations registering registered
        else do
            putMVar registered (registered' ++ [newAddress])
            sortRegistrations registering registered