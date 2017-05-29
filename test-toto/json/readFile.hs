-- http://stackoverflow.com/questions/7867723/haskell-file-reading
import System.IO  
import Control.Monad


main = do  
        contents <- readFile "readFileTest.txt"
        print . map readInt . words $ contents
-- alternately, main = print . map readInt . words =<< readFile "readFileTest.txt"

readInt :: String -> Int
readInt = read