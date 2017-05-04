-- https://gist.github.com/bheklilr/98ac8f8e663cf02fcaa6
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Aeson
import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (unlines)

import Control.Monad (mzero)
import Control.Applicative ((<$>), (<*>))

import Prelude hiding (unlines)

testJson :: ByteString
testJson = unlines
    [ "{"
    , "  \"age\": 25,"
    , "  \"name\": {"
    , "    \"first\": \"John\","
    , "    \"last\": \"Doe\""
    , "  }"
    , "}"
    ]

data Name = Name
    { firstName :: String
    , lastName :: String
    } deriving (Eq, Show)

data Person = Person
    { personName :: Name
    , personAge :: Int
    } deriving (Eq, Show)

instance FromJSON Name where
    parseJSON (Object v) = do
        first <- v .: "first"
        last  <- v .: "last"
        return $ Name first last
    parseJSON _ = mzero

instance FromJSON Person where
    parseJSON (Object v) = do
        nameObj <- v .: "name"
        name    <- parseJSON nameObj
        age     <- v .: "age"
        return $ Person name age


main :: IO ()
main = case decode testJson :: Maybe Person of
    Just person -> print person
    Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"