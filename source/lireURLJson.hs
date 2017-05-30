{-# LANGUAGE DeriveGeneric #-}

module LireURLJson where

import Prelude.Compat
import Data.Aeson (FromJSON, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy.Char8 as BL
import GHC.Generics (Generic)
import Network.HTTP
import Network.Stream

{-
data NuageDeMots = NuageDeMots { mot :: String, occurence :: String }
    deriving (Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots

data Serie = Serie { season :: String, name :: String, year :: String, rated :: String, released :: String, episode :: Int, runtime :: String, genres :: String, director :: String, writer :: String, actors :: String, plot :: String, languages :: String, country :: String, awards :: String, poster :: String, ratings :: Ratings, metascore :: String, rating :: String, votes :: String, imdbid :: String, seriesid :: String, _type :: String, response :: String }
-}

data Serie = Serie { season :: Int, name :: String, episode :: Int, plot :: String }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

lireURL :: String -> IO ()
lireURL url = do --"http://localhost:8081/Public/Game_of_Thrones/1/1/"
  response <- simpleHTTP $ getRequest url
  let body = fmap rspBody response
  case body :: Either Network.Stream.ConnError String of
    Left body -> print "Couldn't load the JSON data from URL"
    Right body -> lireJSON body

lireJSON :: String -> IO ()
lireJSON body = do
    let req = decode $ BL.pack body :: Maybe Serie
    case req :: Maybe Serie of
      Just req -> print $ (show.plot) req
      Nothing -> print "Couldn't load the JSON data from decode Aeson"

lireURLJson :: IO ()
lireURLJson = do
    lireURL "http://localhost:8081/Public/Game_of_Thrones/1/1/"
