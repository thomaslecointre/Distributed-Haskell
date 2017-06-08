{-# LANGUAGE DeriveGeneric #-}

module Statisticsv2 where

import Data.List
import System.Environment
import Data.Aeson (FromJSON, ToJSON, encode)
import GHC.Generics (Generic)
import qualified Data.ByteString.Lazy.Char8 as BL


data NuageDeMots = NuageDeMots { mot :: String, occurrence :: Int }
    deriving (Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots

--statistics :: Int -> Int -> String -> String
statisticsSeasonEpisodeText season episode text =
    let ws = lines text in
    let ds = nub ws in
    let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds in
    let ts = map (\(m,c) -> NuageDeMots { mot = m, occurrence = c}) rs in
    "\"" ++ show season ++ "_" ++ show episode ++ "\" : " ++ BL.unpack (encode ts)
-- 1 1 "jon\njon\ntest" -> "1_1" : {"jon":2,"test":1,"arryn":5}

concatStatistics :: [String] -> String
concatStatistics [] = ""
concatStatistics l = "{" ++ concat (intersperse "," l) ++ "}"
-- ["ep1","ep2","ep3"] -> {ep1,ep2,ep3}