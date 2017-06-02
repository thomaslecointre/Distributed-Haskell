-- http://www.catonmat.net/blog/simple-haskell-tcp-server/

-- runhaskell server.hs 5555

module Main (main) where

import Network.Socket as NS
import Network.Socket.ByteString as NSB
import Network (listenOn, withSocketsDo, accept, PortID(..), Socket)
import System.Environment (getArgs)
import System.IO (hSetBuffering, hGetLine, hPutStrLn, BufferMode(..), Handle)
import Control.Concurrent (forkIO)
import qualified Data.ByteString.Char8 as BC


main :: IO ()
{--
main = withSocketsDo $ do
    args <- getArgs
    let port = fromIntegral (read $ head args :: Int)
    sock <- listenOn $ PortNumber port
    putStrLn $ "Listening on " ++ (head args)
    -- sockHandler sock
    mainLoop sock
--}
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
{-
sockHandler :: Socket -> IO ()
sockHandler sock = do
    (handle, _, _) <- NS.accept sock
    hSetBuffering handle NoBuffering
    forkIO $ commandProcessor handle
    sockHandler sock

commandProcessor :: Handle -> IO ()
commandProcessor handle = do
    line <- hGetLine handle
    let cmd = words line
    case (head cmd) of
        ("echo") -> echoCommand handle cmd
        ("add") -> addCommand handle cmd
        _ -> do hPutStrLn handle "Unknown command"
    commandProcessor handle

echoCommand :: Handle -> [String] -> IO ()
echoCommand handle cmd = do
    hPutStrLn handle (unwords $ tail cmd)

addCommand :: Handle -> [String] -> IO ()
addCommand handle cmd = do
    hPutStrLn handle $ show $ (read $ cmd !! 1) + (read $ cmd !! 2)
-}