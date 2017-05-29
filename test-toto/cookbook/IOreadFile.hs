import Control.Exception (catch, SomeException)
import System.Environment (getArgs)
import System.Directory (doesFileExist)

countWords :: String -> [Int]
countWords input = map (length.words) (lines input)

main :: IO ()
main = do
    args <- getArgs
    let filename = case args of
                    (a:_) -> a
                    _ -> "input.txt"
    exists <- doesFileExist filename
    input <- if exists then readFile filename else return ""
    print $ countWords input
    
--    print "test"
--    print args
    