import qualified Network as N
import qualified Network.Socket as NS
import qualified Utils as U
import qualified OrderDistribution as OD
import qualified StatisticsMaster as Stat
import qualified SortMaster as Sort

import System.IO
import System.Environment
import System.Directory
import Control.Concurrent
import Control.Monad

import Data.String

main :: IO ()
main = do
    orders <- newChan
    orderType <- newEmptyMVar
    registering <- newChan
    registered <- newMVar []
    workStatus <- newChan
    workFiltering <- newChan
    okToProcess <- newChan
    filteredWork <- newMVar []
    forkIO $ receiveOrders orders orderType workStatus
    forkIO $ receiveRegistrations registering
    forkIO $ sortRegistrations registering registered
    forkIO $ sendOrders orders registered
    forkIO $ receiveWork workFiltering okToProcess registered
    forkIO $ filterWork workFiltering filteredWork
    forkIO $ processWork okToProcess filteredWork orderType workStatus
    forever $ do
        putStrLn "Master is active..."
        threadDelay 5000000

-- |Receives connections from messengers
receiveOrders :: Chan [String]    -- ^ Channel used for broadcasting orders across threads
              -> MVar String      -- ^ Variable used to define the type of order to be executed by each slave (keyword research or statistics)
              -> Chan String      -- ^ Channel used for broadcasting status of work            
              -> IO ()
receiveOrders orders orderType workStatus = do
    socket <- N.listenOn (N.PortNumber 4445)
    putStrLn "Receiving orders on 4445..."
    forever $ N.accept socket >>= handleOrders orders orderType workStatus
   
{-|
    Reads order from messenger and broadcasts order to orders channel. 
    Upon order's completion or failure, the function sends a status reply to messenger.
-}
handleOrders :: Chan [String]                        -- ^ Channel used for broadcasting orders across threads
             -> MVar String                          -- ^ Variable used to define the type of order to be executed by each slave (keyword research or statistics)
             -> Chan String                          -- ^ Channel used for broadcasting status of work
             -> (Handle, NS.HostName, NS.PortNumber) -- ^ Returned by N.accept method
             -> IO ()
handleOrders orders orderType workStatus (handle, hostName, portNumber) = do
    hSetBuffering handle LineBuffering
    code <- hGetLine handle
    let order = read code :: [String]
    let typeOfOrder = order !! 0
    putMVar orderType typeOfOrder
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
    orders' <- readChan orders
    print $ "Orders to be parsed : " ++ (show orders')
    registered' <- takeMVar registered
    putMVar registered registered'
    let numberOfRegistered = length registered'
    if numberOfRegistered > 0
        then do
            let parsedOrders = OD.parseArguments orders' numberOfRegistered
            print $ "Parsed orders : " ++ (show parsedOrders)
            dispatchOrders parsedOrders registered'
            sendOrders orders registered
        else do
            putStrLn "No slaves available!"
            threadDelay 5000000
            sendOrders orders registered
           
-- |Dispatches orders to all slaves
dispatchOrders :: [[[String]]]     -- ^ Parsed orders
               -> [String]         -- ^ slave IP address table
               -> IO ()
dispatchOrders _ [] = putStrLn "All orders dispatched or no slaves available"
dispatchOrders [] _ = putStrLn "All orders dispatched or no parsed orders"
dispatchOrders (x:xs) (y:ys) = do
    print $ "Dispatching orders to " ++ (show (y:ys))
    dispatchOrder x y
    print $ "Dispatched order to : " ++ y
    dispatchOrders xs ys

-- |Dispatches order to a slave
dispatchOrder :: [[String]]   -- ^ Order
              -> String       -- ^ IP address of a particular slave  
              -> IO ()
dispatchOrder o a = do
    print $ "Attempting to connect to : " ++ a
    handle <- N.connectTo a (N.PortNumber 5000)
    print $ "Connected to slave @ " ++ a
    hPutStrLn handle (show o)
    hClose handle

{-|
    Function intercepting all incoming work from slaves.
    Each slave has its work transferred to the workFiltering channel.
    The function then reads all work on the workFiltering channel and generates
    a large table which is then used for JSON creation.
-}
receiveWork :: Chan String      -- ^ Channel where work from slaves is deposited on
            -> Chan String      -- ^ Channel used to indicated all expected work has arrived
            -> MVar [String]    -- ^ Variable containing all registered slaves 
            -> IO ()
receiveWork workFiltering okToProcess registered = do
    slaveCountReception <- newMVar 1
    socket <- N.listenOn (N.PortNumber 4446)
    forever $ N.accept socket >>= forkIO . (handleWork workFiltering okToProcess registered slaveCountReception)

-- |Transfers each slave's work onto workFiltering channel
handleWork :: Chan String                           -- ^ Channel where work from slaves is deposited on
           -> Chan String                           -- ^ Channel used to indicated all expected work has arrived
           -> MVar [String]                         -- ^ Variable containing all registered slaves 
           -> MVar Int                              -- ^ Variable/counter of all slaves who have currently deposited work
           -> (Handle, NS.HostName, NS.PortNumber)  -- ^ Result of N.accept
           -> IO ()
handleWork workFiltering okToProcess registered slaveCountReception (handle, hostName, portNumber) = do
    putStrLn "Slave ready to return work"
    code <- hGetLine handle
    print $ "Work retrieved : " ++ code
    writeChan workFiltering code
    registered' <- takeMVar registered
    let slaveCount = length registered'
    putMVar registered registered'
    print $ "Number of registered slaves : " ++ (show slaveCount)
    slaveCountReception' <- takeMVar slaveCountReception
    print $ "Number of slaves who have sent back work : " ++ (show slaveCountReception') 
    if slaveCountReception' == slaveCount
        then do
            putMVar slaveCountReception 1
            writeChan okToProcess "OK"
            putStrLn "Ok to process"
        else do
            putMVar slaveCountReception (slaveCountReception' + 1)

-- |Filters incoming work by reading workFiltering channel and adding work to the filteredWork table variable.            
filterWork :: Chan String   -- ^ Channel where work from slaves is deposited on
           -> MVar [String] -- ^ Variable containing all currently received work from slaves
           -> IO ()
filterWork workFiltering filteredWork = do
    work <- readChan workFiltering
    filteredWork' <- takeMVar filteredWork
    if (elem work filteredWork')
        then do
            putStrLn "Duplicated work detected!"
            putMVar filteredWork filteredWork'
            filterWork workFiltering filteredWork
        else do
            putMVar filteredWork (work : filteredWork')
            filterWork workFiltering filteredWork

{-|
    Extracts filteredWork variable and sends it to the appropriate function (statistics or keyword) 
    depending on the first argument of the order.
-}    
processWork :: Chan String      -- ^ Channel used to indicated all expected work has arrived
            -> MVar [String]    -- ^ Variable containing all currently received work from slaves
            -> MVar String      -- ^ Variable used to define the type of order to be executed by each slave (keyword research or statistics)
            -> Chan String      -- ^ Channel used for broadcasting status of work
            -> IO ()
processWork okToProcess filteredWork orderType workStatus = do
    status <- readChan okToProcess
    if status == "OK"
        then do
            allOfTheWork <- takeMVar filteredWork
            orderType' <- takeMVar orderType
            if orderType' == "N/A"
                then statistics allOfTheWork
                else keyword allOfTheWork
            writeChan workStatus "OK"
            putMVar filteredWork []
            processWork okToProcess filteredWork orderType workStatus
        else do
            putStrLn "Waiting for all slaves to submit work"
            processWork okToProcess filteredWork orderType workStatus

-- |Creates JSON for statistics display
statistics  :: [String] -- ^ Extracted value from filteredWork mvar
            -> IO ()
statistics work = do
    putStrLn "Working on statistics"
    path <- getCurrentDirectory
    let jsonPath =  (take ((length path) - 7) ) path ++ "public\\views\\json"
    writeFile (jsonPath ++ "\\" ++ "statistics.json") (Stat.concatStatistics work)
    putStrLn "Statistics done"

-- |Creates JSON for keyword display
keyword :: [String] -- ^ Extracted value from filteredWork mvar
        -> IO ()
keyword work = do
    putStrLn "Working on keywords"
    path <- getCurrentDirectory
    let jsonPath =  (take ((length path) - 7) ) path ++ "public\\views\\json"
    writeFile (jsonPath ++ "\\" ++ "chronological.json") (Sort.concatChronologicalSort work)
    writeFile (jsonPath ++ "\\" ++ "per-season.json") (Sort.concatSeasonSort work)
    writeFile (jsonPath ++ "\\" ++ "pertinence.json") (Sort.concatRelevanceSort work)
    putStrLn "Keywords done"
