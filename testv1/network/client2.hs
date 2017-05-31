module Main (main) where

import Network.Socket as NS
import Network.Socket.ByteString as NSB
import Network (listenOn, withSocketsDo, accept, PortID(..), Socket)
import System.Environment (getArgs)
import System.IO (hSetBuffering, hGetLine, hPutStrLn, BufferMode(..), Handle)
import Control.Concurrent (forkIO)
import qualified Data.ByteString.Char8 as BC


main :: IO ()
main = do
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    bind sock  (SockAddrInet 5555 iNADDR_ANY)
    listen sock 2
    mainLoop sock
    
mainLoop :: Socket -> IO()
mainLoop sock = do
    conn <- NS.accept sock
    runConn conn
    mainLoop sock
    
runConn :: (Socket, SockAddr) -> IO()
runConn (sock, _) = do
    NSB.send sock $ BC.pack "Hello!\n"
    close sock



client :: String -> Int -> IO ()
client host port = withSocketsDo $ do
                addrInfo <- getAddrInfo Nothing (Just host) (Just $ show port)
                let serverAddr = head addrInfo
                sock <- socket (addrFamily serverAddr) Stream defaultProtocol
                connect sock (addrAddress serverAddr)
                msgSender sock
                close sock

msgSender :: Socket -> IO ()
msgSender sock = do
  msg <- B8.getLine
  send sock msg
  rMsg <- recv sock 10
  B8.putStrLn rMsg
  if msg == B8.pack "q" then putStrLn "Disconnected!" else msgSender sock

main :: IO ()
main = do
    client "127.0.0.1" 5555