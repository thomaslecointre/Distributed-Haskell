import Control.Concurrent (forkIO, threadDelay)


-- Define a function that takes in the number of seconds to sleep, and apply threadDelay :: Int -> IO () to that value as follows:
sleep :: Int -> IO ()
sleep t = do
  let micro = t * 1000000
  threadDelay micro
  putStrLn $ "[Just woke up after " ++ show t ++ " seconds]"


main = do
  putStr "Enter number of seconds to sleep: "
  time <- fmap (read :: String -> Int) getLine
  forkIO $ sleep time
  main