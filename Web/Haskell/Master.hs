import Network
import System.IO
import System.Environment
import Numeric
import Control.Concurrent
import Data.String

main = do
    xs <- getArgs
    let p = read (xs !! 0) :: Integer
    let port = fromInteger p
    interpreter port

interpreter :: PortNumber -> IO()
interpreter port = withSocketsDo $  do
    sock <- listenOn $ PortNumber port
    putStrLn ("Interpreter ("++show port++")")
    handleConnections sock

handleConnections :: Socket -> IO ()
handleConnections sock = do
    (handle, host, port) <- accept sock
    putStrLn "Accepting connections..."
    code <- hGetLine handle
    putStrLn "Reading client's message..."
    putStrLn code
    -- if i == "END" then hClose handle
    threadDelay 500000
    handleConnections sock