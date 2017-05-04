-- http://stackoverflow.com/questions/7867723/haskell-file-reading
import System.IO  
import Control.Monad

{-
main = do  
        let list = []
        handle <- openFile "readFileTest.txt" ReadMode
        contents <- hGetContents handle
        let singlewords = words contents
            list = f singlewords
        print list
        hClose handle   

f :: [String] -> [Int]
f = map read
-}

main = do  
        contents <- readFile "readFileTest.txt"
        print . map readInt . words $ contents
-- alternately, main = print . map readInt . words =<< readFile "readFileTest.txt"

readInt :: String -> Int
readInt = read