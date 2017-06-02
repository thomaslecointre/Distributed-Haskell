import System.Environment
import Data.String
import Network.HTTP.Client
import Network.HTTP.Types.Status (statusCode)

main :: IO()
main = do
  args <- getArgs
  putStrLn $ args !! 0
  let url = buildUrl args
  print url

  manager <- newManager defaultManagerSettings

  request <- parseRequest url
  response <- httpLbs request manager

  putStrLn $ "The status code was: " ++ (show $ statusCode $ responseStatus response)
  print $ responseBody response



buildUrl :: [String] -> String
buildUrl [""]   = ""
buildUrl a = "http://localhost:8081/Public/" ++ a !! 0 ++ "/1/" ++ a !! 1
