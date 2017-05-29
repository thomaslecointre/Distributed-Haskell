import Network
import System.IO
import System.Environment
import Numeric
import Control.Concurrent

main = do
    xs <- getArgs
    let p = read (xs !! 0) :: Integer
    let port = fromInteger p
    converse port

connect :: PortNumber -> IO ()
connect port = withSocketsDo $ do
    let message = "Connecting to Master on " ++ (show port)
    putStrLn message
    handle <- connectTo "localhost" (PortNumber port)

    hPutStrLn handle message
    hClose handle