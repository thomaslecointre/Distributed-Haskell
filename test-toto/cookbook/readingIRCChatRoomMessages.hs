import Network
import Control.Monad (forever)
import System.IO
import Text.Printf

-- Specify the IRC server specifics:
server = "irc.freenode.org"
port   = 6667
chan   = "#haskelldata"
nick   = "awesome-bot"

-- Connect to the server and listen to all text being passed in a chat room:
main = do
  h <- connectTo server (PortNumber (fromIntegral port))
  hSetBuffering h NoBuffering
  write h "NICK" nick
  write h "USER" (nick++" 0 * :tutorial bot")
  write h "JOIN" chan
  listen h
 
write :: Handle -> String -> String -> IO ()
write h s t = do
  hPrintf h "%s %s\r\n" s t
  printf    "> %s %s\n" s t

-- Define our listener. For this recipe, we will just echo all events to the console:
listen :: Handle -> IO ()
listen h = forever $ do
  s <- hGetLine h
  putStrLn s