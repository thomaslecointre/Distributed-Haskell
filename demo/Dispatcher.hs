--module Dispatcher where

import Network
import System.IO
import System.Environment
import Numeric

import Instr

--code = "maximum [12,14,8,19,5,15]"

code = Max [12,14,8,19,5,15]

split (Max xs) = [Max xs1,Max xs2]
 where xs1 = take n xs
       xs2 = drop n xs
       n   = div (length xs) 2

main = do
 xs <- getArgs
 let ps = read (xs!!0) :: [Integer]
 let [port1,port2] = map fromInteger ps
 dispatcher port1 port2

dispatcher :: PortNumber -> PortNumber -> IO ()
dispatcher port1 port2 = withSocketsDo $ do
 putStrLn ("Compute: "++ show code)
 let code' = split code
 putStrLn ("Split  : Max "++ show code')
 handle1 <- connectTo "localhost" (PortNumber port1)
 handle2 <- connectTo "localhost" (PortNumber port2)
 putStrLn ("Send ("++show port1++"): "++ show (code'!!0))
 putStrLn ("Send ("++show port2++"): "++ show (code'!!1))
 hPutStrLn handle1 (show (code'!!0))
 hPutStrLn handle2 (show (code'!!1))
 res1 <- hGetLine handle1
 res2 <- hGetLine handle2
 let r1 = read res1 :: Int
 let r2 = read res2 :: Int
 putStrLn ("Receive ("++show port1++"): "++ show r1)
 putStrLn ("Receive ("++show port2++"): "++ show r2)
 putStrLn ("Compute: Max "++ show [r1,r2])
 putStrLn ("Return : "++show (max r1 r2))
 hClose handle1
 hClose handle2

