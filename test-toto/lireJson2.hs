{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson
import Data.ByteString.Lazy hiding (readFile)
import Data.ByteString.Lazy.Char8 (unlines)

import Control.Monad (mzero)
import Control.Applicative ((<$>), (<*>))

import Prelude hiding (unlines)


{-
testJson :: ByteString
testJson = unlines
    [ "{"
    , "  \"serie\": \"Game of Thrones\","
    , "  \"saison\": \"1\","
    , "  \"episode\": \"1\","
    , "  \"titre\": \"Winter Is Coming\","
    , "  \"resume\": \"Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.\""
    , "}"
    ]
-}
--lines "{\n  \"episode\": \"1\",\n  \"titre\": \"Winter Is Coming\"\n }"
--["{","  \"episode\": \"1\",", "  \"titre\": \"Winter Is Coming\""," }"]

data Serie = Serie
    { serie :: String
    , saison :: String
    , episode :: String
    , titre :: String
    , resume :: String
    } deriving (Eq, Show)

instance FromJSON Serie where
    parseJSON (Object v) = do
        serie   <- v .: "serie"
        saison  <- v .: "saison"
        episode <- v .: "episode"
        titre   <- v .: "titre"
        resume  <- v .: "resume"
        return $ Serie serie saison episode titre resume


main = do
    path <- getLine
    testJson <- readFile path
    case decode testJson :: Maybe Serie of
        Just serie -> print serie
        Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
{-
main = do
    setLocaleEncoding utf8
    args <- getArgs
    case args of 
      jsonFile -> do
        let path = "GotTest.json"
        contents <- readFile path -- jsonFile
        testJson <- unlines contents
        case decode testJson :: Maybe Serie of
          Just serie -> print serie
          Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
-}
{-
main :: IO ()
main = case decode testJson :: Maybe Serie of
    Just serie -> print serie
    Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
-}

--print . unlines . map unwords $ map words $ lines "je\nje"
--print . unlines $ lines "je\nje"
--print $ "je\nje"


{-
src <- openURL ("http://www.imdb.com/title/" ++ (reference !! 0) ++ "/episodes?season=1")
print src
writeFile ((reference !! 0) ++ ".html") src
-}
{-
https://gist.github.com/bheklilr/98ac8f8e663cf02fcaa6
-}