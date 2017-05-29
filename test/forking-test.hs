import qualified Network as N
import qualified Network.Socket as NS
import System.IO
import System.Environment
import Control.Concurrent
import Control.Monad
import Data.List

main :: IO ()
main = do
    let registry = []
    registrationChan <- newChan
    forkIO $ register 4444 registrationChan
    updateRegistry registry registrationChan

register :: Int -> Chan Int -> IO ()
register p c = NS.withSocketsDo $ do
    sock <- N.listenOn $ N.PortNumber $ fromIntegral p
    putStrLn ("Accepting on ("++show p++")")
    handleConnections sock c

handleConnections :: N.Socket -> Chan Int -> IO ()
handleConnections sock c = do
    -- (handle, host, port) <- accept sock
    (socket, sockaddr) <- NS.accept sock
    handle <- NS.socketToHandle socket ReadMode
    print sockaddr 
    {--
    putStrLn "Registering connections..."
    hSetBuffering handle LineBuffering
    buffer <- hGetLine handle
    let registering = read buffer :: Int
    writeChan c registering
    --}
    threadDelay 500000
    handleConnections sock c

updateRegistry :: [Int] -> Chan Int -> IO () -- ?
updateRegistry r c = do
    connection <- readChan c
    if (elem connection r)
        then updateRegistry r c
        else do
            let r' = r ++ [connection]
            putStrLn $ show r'
            updateRegistry r' c
