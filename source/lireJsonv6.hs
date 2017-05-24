{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module LireJsonv6 (main) where

import Prelude ()
import Prelude.Compat
import System.Environment
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
    args <- getArgs
    let path = "jsonSansNuageDeMots.json"
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    case req :: Maybe Serie of
      Just req -> BL.writeFile "tmp2.txt" (BL.pack ((show.resume) req))
      Nothing -> print "Couldn't load the JSON data"
-- dans cmd : runhaskell lireJsonv5.hs -> jsonSansNuageDeMots.json
