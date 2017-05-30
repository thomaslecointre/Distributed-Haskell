{-# LANGUAGE DeriveGeneric #-}

module Statisticsv2 where

import Data.List
import System.Environment
import Data.Aeson (FromJSON, ToJSON, encode)
import GHC.Generics (Generic)
import qualified Data.ByteString.Lazy.Char8 as BL


data NuageDeMots = NuageDeMots { mot :: String, occurence :: String }
    deriving (Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots

statistics :: String -> FilePath -> IO ()
statistics text path =
    let ws = lines text in
    let ds = nub ws in
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds in
    let ts = map (\(m,c) -> NuageDeMots { mot = m, occurence = (show c)}) rs in
    BL.writeFile path $ encode ts
