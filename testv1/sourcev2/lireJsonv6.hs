{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module LireJsonv6 where

import Prelude ()
import Prelude.Compat
import System.Environment
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
-- import System.Exit

data Serie = Serie { serie :: String, saison :: String, episode :: String , titre :: String, resume :: String }
    deriving (Eq, Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

data NuageDeMots = NuageDeMots { mot :: String, occurence :: String }
    deriving (Eq, Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots

{-
main :: IO ()
main = do
    args <- getArgs
    let path = "jsonSansNuageDeMots.json"
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    case req :: Maybe Serie of

      Nothing -> print "Couldn't load the JSON data"
-- dans cmd : runhaskell lireJsonv5.hs -> jsonSansNuageDeMots.json
-}

lireJsonv6 :: FilePath -> IO ()
lireJsonv6 path = do -- "jsonSansNuageDeMots.json"
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    case req :: Maybe Serie of
--      Just req -> BL.writeFile "tmp2.txt" (BL.pack ((show.resume) req))
      Just req -> print $ (show.resume) req
      Nothing -> print "Couldn't load the JSON data"
                 -- exitFailure
-- dans cmd : runhaskell lireJsonv6.hs -> jsonSansNuageDeMots.json

main = do
    lireJsonv6 "jsonSansNuageDeMots.json"
