-- http://stackoverflow.com/questions/7867723/haskell-file-reading
import System.IO  
import Control.Monad


main = do  
        main = do  
        contents <- readFile "readFileTest.txt"
        print . map unwords $ map words $ lines contents
