module Utils where

import Data.String
import Data.List
import qualified Network.Socket as NS

stripIP :: NS.SockAddr -> String
stripIP socketAddress = do
    let elements = words (map whiteSpace (show socketAddress))
    elements !! 2

whiteSpace :: Char -> Char
whiteSpace ':' = ' '
whiteSpace ']' = ' '
whiteSpace c = c
