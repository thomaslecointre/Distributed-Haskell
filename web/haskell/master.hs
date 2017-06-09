import qualified Network as N
import qualified Network.Socket as NS
import qualified Utils as U
import qualified OrderDistribution as OD

import System.IO
import System.Environment

import Control.Concurrent
import Control.Monad

import Data.String

main = do
    orders <- newChan
    registering <- newChan
    registered <- newMVar []
    workStatus <- newChan
    workFiltering <- newChan
    okToProcess <- newChan
    filteredWork <- newMVar []
    forkIO $ receiveOrders orders workStatus
    forkIO $ receiveRegistrations registering
    forkIO $ sortRegistrations registering registered
    forkIO $ sendOrders orders registered
    forkIO $ receiveWork workFiltering okToProcess registered
    forkIO $ filterWork workFiltering filteredWork
    forkIO $ processWork okToProcess filteredWork
    forever $ do
        putStrLn "Master is active..."
        threadDelay 5000000

-- |Receives connections from messengers
receiveOrders :: Chan [String]    -- ^ Channel used for broadcasting orders across threads
              -> Chan String      -- ^ Channel used for broadcasting status of work            
              -> IO ()
receiveOrders orders workStatus = do
    socket <- N.listenOn (N.PortNumber 4445)
    putStrLn "Receiving orders on 4445..."
    forever $ N.accept socket >>= handleOrders orders workStatus
   
{-|
    Reads order from messenger and broadcasts order to orders channel. 
    Upon order's completion or failure, the function sends a status reply to messenger.
-}
handleOrders :: Chan [String]                        -- ^ Channel used for broadcasting orders across threads
             -> Chan String                          -- ^ Channel used for broadcasting status of work
             -> (Handle, NS.HostName, NS.PortNumber) -- ^ Returned by N.accept method
             -> IO ()
handleOrders orders workStatus (handle, hostName, portNumber) = do
    hSetBuffering handle LineBuffering
    code <- hGetLine handle
    let order = read code :: [String]
    print $ "Received orders : " ++ (show order)
    writeChan orders order
    status <- readChan workStatus -- "OK" or "KO"
    hPutStrLn handle status 
    hClose handle

-- |Opens port no. 4444 for slave registration
receiveRegistrations :: Chan String -- ^ Channel used for broadcasting registering slaves
                     -> IO ()
receiveRegistrations registering = do
    socket <- N.listenOn (N.PortNumber 4444)
    putStrLn "Receiving registrations on 4444..."
    forever $ NS.accept socket >>= (handleRegistrations registering)
    
-- |Receives connections from registering slaves
handleRegistrations :: Chan String              -- ^ Channel used for broadcasting registering slaves
                    -> (NS.Socket, NS.SockAddr) -- ^ Returned by NS.accept method
                    -> IO ()
handleRegistrations registering (socket, sockaddr) = do
    let socketAddress = sockaddr
    let ipAddress = U.stripIP socketAddress
    print $ "New slave registering from " ++ ipAddress
    writeChan registering ipAddress

{-|
    Sorts registering slaves by ensuring that there are no duplicate IPs in slave IP address table
-}
sortRegistrations :: Chan String      -- ^ Channel used for broadcasting registering slaves
                  -> MVar [String]    -- ^ Variable containing all registered slaves
                  -> IO()             
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

-- |Checks if slaves are present. If so, orders are dispatched to slaves.          
sendOrders :: Chan [String] -- ^ Channel used for broadcasting orders across threads
           -> MVar [String] -- ^ Variable containing all registered slaves
           -> IO ()
sendOrders orders registered = do
    registered' <- takeMVar registered
    putMVar registered registered'
    let numberOfRegistered = length registered'
    if numberOfRegistered > 0
        then do
            orders' <- readChan orders
            let parsedOrders = OD.parseArguments orders' numberOfRegistered
            dispatchOrders parsedOrders registered'
            sendOrders orders registered
        else do
            putStrLn "No slaves available!"
            sendOrders orders registered
            
-- |Dispatches orders to all slaves
dispatchOrders :: [[[String]]]     -- ^ Parsed orders
               -> [String]         -- ^ slave IP address table
               -> IO ()
dispatchOrders (x:xs) (y:ys) = do
    dispatchOrder x y
    dispatchOrders xs ys

-- |Dispatches order to a slave
dispatchOrder :: [[String]]   -- ^ Order
              -> String       -- ^ IP address of a particular slave  
              -> IO ()
dispatchOrder o a = do
    handle <- N.connectTo a (N.PortNumber 5000)
    hSetBuffering handle LineBuffering
    hPutStrLn handle (show o)
    hClose handle

{-|
    Function intercepting all incoming work from slaves.
    Each slave has its work transferred to the workFiltering channel.
    The function then reads all work on the workFiltering channel and generates
    a large table which is then used for JSON creation.
-}
receiveWork :: Chan String 
            -> Chan String
            -> MVar [String]
            -> IO ()
receiveWork workFiltering okToProcess registered = do
    registered' <- takeMVar registered
    let slaveCount = length registered'
    putMVar registered registered'
    slaveCountReception <- newMVar 1
    socket <- N.listenOn (N.PortNumber 4446)
    forever $ N.accept socket >>= forkIO . (handleWork workFiltering okToProcess slaveCount slaveCountReception)

-- |Transfers each slave's work onto workFiltering channel
handleWork :: Chan String
           -> Chan String
           -> Int
           -> MVar Int
           -> (Handle, NS.HostName, NS.PortNumber)
           -> IO ()
handleWork workFiltering okToProcess slaveCount slaveCountReception (handle, hostName, portNumber) = do
    hSetBuffering handle LineBuffering
    code <- hGetLine handle
    writeChan workFiltering code
    slaveCountReception' <- takeMVar slaveCountReception
    if slaveCountReception' == slaveCount
        then do
            putMVar slaveCountReception 1
            writeChan okToProcess "OK"
        else do
            putMVar slaveCountReception (slaveCountReception' + 1)
            
    
filterWork :: Chan String
           -> MVar [String]
           -> IO ()
filterWork workFiltering filteredWork = do
    work <- readChan workFiltering
    filteredWork' <- takeMVar filteredWork
    if (elem work filteredWork')
        then do
            putStrLn "Duplicated work detected!"
            putMVar filteredWork filteredWork'
        else do
            putMVar filteredWork (work : filteredWork')

processWork :: Chan String
            -> MVar [String]
            -> IO ()
processWork okToProcess filteredWork = do
    status <- readChan okToProcess
    if status == "OK"
        then do
            allOfTheWork <- takeMVar filteredWork
            -- sortWork allOfTheWork -- !!
            putMVar filteredWork []
        else putStrLn "Waiting for all slaves to submit work"
            
    
