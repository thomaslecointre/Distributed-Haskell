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


main = do
    args <- getArgs
    f <- readFile "tmp4.txt"
    let ws = lines f
    let ds = nub ws
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds
    let ts = map (\(m,c) -> NuageDeMots { mot = m, occurence = (show c)}) rs
    BL.writeFile "statistics.txt" (encode ts)
