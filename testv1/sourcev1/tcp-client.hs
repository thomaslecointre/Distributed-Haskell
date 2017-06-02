--tcp-client.hs

import Network
import System.IO

main :: IO ()
main = withSocketsDo $ do
	handle <- connectTo "localhost" (PortNumber 3001)
	hPutStr handle "Hello, world!"
	hClose handle
	
