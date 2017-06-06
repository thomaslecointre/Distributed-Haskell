import qualified Network as N
import System.IO
import System.Environment
import Control.Concurrent
import Data.String

main :: IO ()
main = do
    let port = 4444
    print $ "Connecting to Master @185.167.204.218:" ++ (show port)
    handle <- N.connectTo "185.167.204.218" (N.PortNumber port)
    putStrLn "Connected"
    {--
    socket <- N.listenOn (N.PortNumber 5000)
    (handle, host, port) <- N.accept socket
    hSetBuffering handle LineBuffering
    data <- hGetLine handle
    --}
