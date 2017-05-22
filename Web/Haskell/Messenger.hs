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

converse :: PortNumber -> IO ()
converse port = withSocketsDo $ do
    handle <- connectTo "localhost" (PortNumber port)
    let message = "Connecting to Master on " ++ (show port)
    putStrLn message
    hPutStrLn handle message
    hClose handle