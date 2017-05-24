{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module LireURLJson (main) where

import Prelude ()
import Prelude.Compat

import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import Network.HTTP

import Network.Stream


data Person = Person { firstName :: String, lastName :: String, age :: Int , likePizza :: Bool }
    deriving (Show, Generic)

instance FromJSON Person
instance ToJSON Person

{-
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
-}

main = do
  response <- simpleHTTP $ getRequest "http://daniel-diaz.github.io/misc/pizza.json"
  let body = fmap rspBody response
  case body :: Either Network.Stream.ConnError String of
    Right body -> writeFile "tmp.json" body
    Left body -> print "Couldn't load the JSON data"