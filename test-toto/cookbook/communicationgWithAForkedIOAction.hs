import Network.HTTP
import Control.Concurrent


-- Create a new variable that will be used by the fork process. The newEmptyMVar function is of the IO (MVar a) type, so we will extract the expression out and label it m as follows:
main = do
  m <- newEmptyMVar
  forkIO $ process m
-- After running the fork, send it some data by calling putMVar :: MVar a -> a -> IO (), as shown in the following lines of code. The variable will hold the given value, and the forked process waiting on that data will resume:
  putStrLn "sending first website..."
  putMVar m "http://www.haskell.com"
-- We can reuse the expression and send it more data as follows:
  putStrLn "sending second website..."
  putMVar m "http://www.gnu.org"
-- To make sure main does not terminate before the forked process is finished, we just force main to wait for 10 seconds by calling the threadDelay function. This is for demonstration purposes only, and a complete solution should terminate main immediately once the fork is complete, as presented in the following code snippet:
  threadDelay $ 10 * 1000000

-- Define the code that will be forked to run in parallel as follows:
process m = do 
  putStrLn "waiting..."
  v <- takeMVar m
  resp <- get v
  putStrLn $ "response from " ++ show v ++ " is " ++ resp
  process m

-- Create a function to perform an HTTP GET request on a URL as follows:
get :: String -> IO String
get url = do
   resp <- simpleHTTP (getRequest url)
   body <- getResponseBody resp
   return $ take 10 body