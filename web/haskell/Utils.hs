{-|
Module      : Utils
Description : Functions to strip an IPv4 address from SockAddr of Network.Socket and to replace : and ] with whitespace
Copyright   : (c) Thomas Lecointre, 2017
                  Thomas Perles, 2017
License     : MIT
Maintainer  :   thomas.lecointre@uha.fr
                thomas.perles@uha.fr
Stability   : experimental
Portability : Windows

We use this module to strip an IPv4 address from SockAddr of Network.Socket and to replace : and ] with whitespace

-}
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
