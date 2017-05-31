-- tcp-server.hs

import Network
import System.IO

main :: IO ()
main = withSocketsDo $ do
	sock <- listenOn $ PortNumber 3001
	putStrLn "Starting server ..."
	handleConnections sock

handleConnections :: Socket -> IO ()
handleConnections sock = do
	(handle, host, port) <- accept sock
	output <- hGetLine handle
	putStrLn output 
	handleConnections sock