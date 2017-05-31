{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Prelude ()
import Prelude.Compat

import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.ByteString.Lazy as B
import GHC.Generics (Generic)

-- testJson = "{ \"serie\": \"Game of Thrones\", \"saison\": \"1\", \"episode\": \"1\", \"titre\": \"Winter Is Coming\", \"resume\": \"Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.\"}"

data Serie = Serie { serie :: String, saison :: String, episode :: String , titre :: String, resume :: String }
             deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

main :: IO ()
main = do
  path <- getLine
  testJson <- B.readFile path
  let req = decode testJson :: Maybe Serie
  print req
-- dans cmd : runhaskell lireJsonv2.hs -> lireJson.json
  let reply = Serie { serie = "Game of Thrones", saison = "1", episode = "1", titre = "Winter Is Coming", resume = "Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army." }
  BL.putStrLn (encode reply)