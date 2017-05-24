module GetWordsFile (main) where

--import Prelude ()
--import Prelude.Compat

--import Data.Aeson (FromJSON, ToJSON, decode, encode)
--import qualified Data.ByteString.Lazy as B
--import qualified Data.ByteString.Lazy.Char8 as BL
--import GHC.Generics (Generic)
import System.Environment


separators = " \"',.\n"

cut :: String -> [String]
cut "" = []
cut t = 
 let w = takeWhile (\x -> notElem x separators) t
     r = dropWhile (\x -> elem x separators) (dropWhile (\x -> notElem x separators) t)
 in w:(cut r)

toLine :: String -> String
toLine s = unlines $ cut s


main :: IO ()
main = do
    args <- getArgs
    resume <- readFile (args !! 0)
    writeFile "tmp3.txt" (toLine resume)
{-
    case resume of
      Just x -> writeFile "tmp3.txt" (toLine x)
      Nothing -> print "Couldn't load the JSON data"
-}
-- dans cmd : runhaskell getWordsFile.hs -> tmp2.txt