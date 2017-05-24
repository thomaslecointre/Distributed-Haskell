module GetWordsFilev2 where
    
import qualified Data.Set as S    
import qualified Data.Text as T
import System.Environment


separators = " \"',.\n"

cut :: String -> [String]
cut "" = []
cut t = 
 let w = takeWhile (\x -> notElem x separators) t
     r = dropWhile (\x -> elem x separators) (dropWhile (\x -> notElem x separators) t)
 in w:(cut r)

isStopWord :: T.Text -> Bool
isStopWord w = S.member w stopWords

stopWords :: S.Set T.Text
stopWords = S.fromList $ map T.pack
     [ "i"
     , "me"
     , "my"
     , "myself"
     , "we"
     , "our"
     , "ours"
     , "ourselves"
     , "you"
     , "your"
     , "yours"
     , "yourself"
     , "yourselves"
     , "he"
     , "him"
     , "his"
     , "himself"
     , "she"
     , "her"
     , "hers"
     , "herself"
     , "it"
     , "its"
     , "itself"
     , "they"
     , "them"
     , "their"
     , "theirs"
     , "themselves"
     , "what"
     , "which"
     , "who"
     , "whom"
     , "this"
     , "that"
     , "these"
     , "those"
     , "am"
     , "is"
     , "are"
     , "was"
     , "were"
     , "be"
     , "been"
     , "being"
     , "have"
     , "has"
     , "had"
     , "having"
     , "do"
     , "does"
     , "did"
     , "doing"
     , "a"
     , "an"
     , "the"
     , "and"
     , "but"
     , "if"
     , "or"
     , "because"
     , "as"
     , "until"
     , "while"
     , "of"
     , "at"
     , "by"
     , "for"
     , "with"
     , "about"
     , "against"
     , "between"
     , "into"
     , "through"
     , "during"
     , "before"
     , "after"
     , "above"
     , "below"
     , "to"
     , "from"
     , "up"
     , "down"
     , "in"
     , "out"
     , "on"
     , "off"
     , "over"
     , "under"
     , "again"
     , "further"
     , "then"
     , "once"
     , "here"
     , "there"
     , "when"
     , "where"
     , "why"
     , "how"
     , "all"
     , "any"
     , "both"
     , "each"
     , "few"
     , "more"
     , "most"
     , "other"
     , "some"
     , "such"
     , "no"
     , "nor"
     , "not"
     , "only"
     , "own"
     , "same"
     , "so"
     , "than"
     , "too"
     , "very"
     , "s"
     , "t"
     , "can"
     , "will"
     , "just"
     , "don"
     , "should"
     , "now"
     ]

deleteStopWords :: [String] -> [String]
deleteStopWords [] = []
deleteStopWords (x:l) = if isStopWord $ T.pack x then deleteStopWords l else x:(deleteStopWords l)

toLine :: String -> String
toLine s = unlines $ deleteStopWords $ cut s


main :: IO ()
main = do
    args <- getArgs
    resume <- readFile "tmp2.txt"
    writeFile "tmp3.txt" (toLine resume)
-- dans cmd : runhaskell getWordsFile.hs -> tmp2.txt
