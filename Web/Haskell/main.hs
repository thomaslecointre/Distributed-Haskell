import System.Environment
import Data.String

main :: IO()
main = do
  print args
  url <- buildUrl getArgs
  -- print url
  print "hello"

buildUrl :: IO [String] -> String
buildUrl [""]   = ""
buildUrl args = "http://localhost:8081/" ++ (args !! 0) ++ "/" ++ "1" ++ "/" ++ (args !! 1)
