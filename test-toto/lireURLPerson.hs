{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

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
main :: IO ()
main = do
    path <- getLine
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    print req
-- dans cmd : runhaskell lireJsonv3.hs -> lireJsonv3.json
    let reply = Serie2 { serie2 = "Game of Thrones", saison2 = "1", episode2 = "1", titre2 = "Winter Is Coming", resume2 = "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.", nuageDeMots = [NuageDeMots { mot = "jon", occurence = "2"}, NuageDeMots { mot = "test", occurence = "1"} ]}
    BL.putStrLn (encode reply)
-}

main = do
  response <- simpleHTTP $ getRequest "http://daniel-diaz.github.io/misc/pizza.json"
  let body = fmap rspBody response
--  print response
--  writeFile "tmp.json" body
--  writeFile "tmp.json" $ Right body
  case body :: Either Network.Stream.ConnError String of
    Right body -> writeFile "tmp.json" body
    Left body -> print "Couldn't load the JSON data"