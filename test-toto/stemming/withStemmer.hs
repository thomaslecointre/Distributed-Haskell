-- https://github.com/bgamari/stemmer/blob/master/examples/StemWords.hs

import NLP.Stemmer
import Control.Monad (unless)
import System.IO (hSetBuffering, stdout, BufferMode(NoBuffering))
import Criterion.Main
 
main' :: IO ()
main' = do
    putStrLn "Enter a sentence to stem, an empty line to stop."
    hSetBuffering stdout NoBuffering -- to print a prompt
    stemUserInput
 
stemUserInput :: IO ()
stemUserInput = do
    putStr "> "
    string <- getLine
    unless (string == "") $ do 
        putStrLn $ (++) "< " $ unwords $ 
                               map (stem English) $ 
                               words string
        stemUserInput

bread :: Int -> [String]
bread n = take n (repeat "brood")

main = defaultMain [
        bgroup "stemmer" [ bench "stem"    $ B (map (stem Dutch))   (bread 100000)
                         -- , bench "stem'"   $ B (map (stem' Dutch))  (bread 100000)
                         -- , bench "stem''"  $ B (map (stem'' Dutch)) (bread 100000)
                         -- , bench "stemWords" $ B (stemWords Dutch)   (bread 10000)
                         ]
                   ]