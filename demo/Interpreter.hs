--module Interpreter where

import Network
import System.IO
import System.Environment
import Numeric

import Instr

main = do
 xs <- getArgs
 let p = read (xs!!0) :: Integer
 let port = fromInteger p
 interpreter port

interpreter :: PortNumber -> IO ()
interpreter port = withSocketsDo $ do
 sock <- listenOn $ PortNumber port
 putStrLn ("Interpreter ("++show port++")")
 handleConnections sock

handleConnections :: Socket -> IO ()
handleConnections sock = do
 (handle, host, port) <- accept sock
 code <- hGetLine handle
 let i = read code :: Instr
 putStrLn ("Execute: "++ show i)
 let r = exec i
 putStrLn ("Reply  : "++ show r)
 hPutStrLn handle (show r)
 handleConnections sock
