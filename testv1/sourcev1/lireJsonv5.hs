{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Prelude ()
import Prelude.Compat

import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)

data Serie = Serie { serie :: String, saison :: String, episode :: String , titre :: String, resume :: String }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

data Serie2 = Serie2 { serie2 :: String, saison2 :: String, episode2 :: String , titre2 :: String, resume2 :: String, nuageDeMots :: [NuageDeMots] }
    deriving (Show, Generic)

instance FromJSON Serie2
instance ToJSON Serie2

data NuageDeMots = NuageDeMots { mot :: String, occurence :: String }
    deriving (Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots

main :: IO ()
main = do
    path <- getLine
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    print req
-- dans cmd : runhaskell lireJsonv5.hs -> jsonSansNuageDeMots.json
    print "\n\n"
    let reply = Serie2 { serie2 = "Game of Thrones", saison2 = "1", episode2 = "1", titre2 = "Winter Is Coming", resume2 = "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.", nuageDeMots = [NuageDeMots { mot = "jon", occurence = "2"}, NuageDeMots { mot = "test", occurence = "1"} ]}
    BL.putStrLn (encode reply)