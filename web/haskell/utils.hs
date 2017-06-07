module Utils where

import Data.String
import Data.List
import qualified Network.Socket as NS

-- |Strips an IPv4 address from SockAddr of Network.Socket
stripIP :: NS.SockAddr -> String
stripIP socketAddress = do
    let elements = words (map whiteSpace (show socketAddress))
    elements !! 2

-- |Replaces : and ] with whitespace
whiteSpace :: Char -> Char
whiteSpace ':' = ' '
whiteSpace ']' = ' '
whiteSpace c = c
