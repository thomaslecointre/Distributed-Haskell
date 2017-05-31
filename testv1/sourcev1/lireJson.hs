{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Aeson
import qualified Data.ByteString.Lazy as B
--import Data.ByteString.Lazy hiding (readFile)
import Data.ByteString.Lazy.Char8 (unlines)

import Control.Monad (mzero)
import Control.Applicative ((<$>), (<*>))

import Prelude hiding (unlines)


testJson :: B.ByteString
testJson = unlines
    [ "{"
    , "  \"serie\": \"Game of Thrones\","
    , "  \"saison\": \"1\","
    , "  \"episode\": \"1\","
    , "  \"titre\": \"Winter Is Coming\","
    , "  \"resume\": \"Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.\""
    , "}"
    ]


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


main :: IO ()
main = do
    path <- getLine
    testJson <- B.readFile path
    case decode testJson :: Maybe Serie of
        Just serie -> print serie
        Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
-- dans cmd : runhaskell lireJson.hs -> lireJson.json