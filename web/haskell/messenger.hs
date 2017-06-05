import Network
import System.Exit
import System.IO
import System.Environment
import Numeric
import Control.Concurrent
import Data.String

main = do
    xs <- getArgs
    sendOrder 4445 xs

sendOrder :: PortNumber -> [String] -> IO ()
sendOrder port xs = withSocketsDo $ do
    print $ "Connecting to Master @localhost:" ++ (show port)
    handle <- connectTo "localhost" (PortNumber port)
    hSetBuffering handle LineBuffering
    hPutStrLn handle (show xs)
    response <- hGetLine handle
    if response == "KO" 
        then die "Master was unable to process request"
        else if response == "OK"
            then exitSuccess
            else die "Unexpected failure"
    
