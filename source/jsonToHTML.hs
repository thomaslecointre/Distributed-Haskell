-- import System.Environment
-- import Data.Set
import Data.Aeson
-- import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (unlines)

import Control.Monad (mzero)
import Control.Applicative ((<$>), (<*>))

import Prelude hiding (unlines)


data NuageDeMots = NuageDeMots
    { mot :: String
    , occurence :: Int
    } deriving (Eq, Show)

data Serie = Serie
    { serie :: String
    , saison :: Int
    , episode :: Int
    , titre :: String
    , resume :: String
    , nuageDeMots :: NuageDeMots
    } deriving (Eq, Show)

instance FromJSON NuageDeMots where
    parseJSON (Object v) = do
        mot <- v .: "mot"
        occurence  <- v .: "occurence"
        return $ NuageDeMots mot occurence
    parseJSON _ = mzero

instance FromJSON Serie where
    parseJSON (Object v) = do
        serie     <- v .: "serie"
        saison     <- v .: "saison"
        episode     <- v .: "episode"
        titre     <- v .: "titre"
        resume     <- v .: "resume"
        nuage <- v .: "nuageDeMots"
        nuageDeMots    <- parseJSON nuage
        return $ Serie serie saison episode titre resume nuageDeMots

main = do
    setLocaleEncoding utf8
    args <- getArgs
    case args of 
      jsonFile -> do
        let path = "C:/Users/Tom/Documents/GitKraken/Distributed-Haskell/serie/Game of Thrones S1 E1.json"
        contents <- readFile path -- jsonFile
        testJson <- unlines contents
        case decode testJson :: Maybe Serie of
          Just serie -> print serie
          Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
        
        

{-
src <- openURL ("http://www.imdb.com/title/" ++ (reference !! 0) ++ "/episodes?season=1")
print src
writeFile ((reference !! 0) ++ ".html") src
-}
{-
https://gist.github.com/bheklilr/98ac8f8e663cf02fcaa6

testJson :: ByteString
testJson = unlines
    [ "{"
    , "  \"age\": 25,"
    , "  \"name\": {"
    , "    \"first\": \"John\","
    , "    \"last\": \"Doe\""
    , "  }"
    , "}"
    ]

data Name = Name
    { firstName :: String
    , lastName :: String
    } deriving (Eq, Show)

data Person = Person
    { personName :: Name
    , personAge :: Int
    } deriving (Eq, Show)

instance FromJSON Name where
    parseJSON (Object v) = do
        first <- v .: "first"
        last  <- v .: "last"
        return $ Name first last
    parseJSON _ = mzero

instance FromJSON Person where
    parseJSON (Object v) = do
        nameObj <- v .: "name"
        name    <- parseJSON nameObj
        age     <- v .: "age"
        return $ Person name age


main :: IO ()
main = case decode testJson :: Maybe Person of
    Just person -> print person
    Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
-}


