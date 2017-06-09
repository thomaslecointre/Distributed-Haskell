-- code récupéré en partie sur
--https://hackage.haskell.org/package/Condor-0.2/docs/src/Condor-Language-English-StopWords.html#isStopWord

module GetWordsFilev2 where
    
import qualified Data.Set as S    
import qualified Data.Text as T
import System.Environment

-- |Deletes the defined punctuation characters
removePunc  :: String   -- ^ Text with punctuation characters
            -> String   -- ^ Text without punctuation characters
removePunc xs = [ x | x <- xs, not (x `elem` ",.?!-:;\"\'") ]

-- |Returns if the word in input is or not a stopword
isStopWord  :: T.Text   -- ^ A word
            -> Bool     -- ^ Is or not a stopword
isStopWord w = S.member w stopWords

-- |Gives a set of stopwords
stopWords :: S.Set T.Text   -- ^ Set of stopwords
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

-- |Deletes stopwords of a text
deleteStopWords :: [String] -- ^ A text with stopwords
                -> [String] -- ^ The text without stopwords
deleteStopWords [] = []
deleteStopWords (x:l) = if isStopWord $ T.pack x then deleteStopWords l else x:(deleteStopWords l)

-- |Returns all the non stopwords of a text, each on a new line
getWordsFile    :: String   -- ^ A text with stopwords like "there is a fish in the water"
                -> String   -- ^ The text without stopwords, each word on a new line like "fish\nwater\n"
getWordsFile resume = unlines $ deleteStopWords $ words $ removePunc resume
