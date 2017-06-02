-- cabal install simpleirc
{-# LANGUAGE OverloadedStrings #-}

import Network.SimpleIRC
import Data.Maybe
import qualified Data.ByteString.Char8 as B

-- Create an event handler when a message is received. If the message is "host?", then reply to the user with information about their host:
onMessage :: EventFunc
onMessage s m = do
  case msg of
    "host?" ->  sendMsg s chan $ botMsg
    otherwise -> return ()
  where chan = fromJust $ mChan m
        msg = mMsg m
        host = case mHost m of
          Just h -> h
          Nothing -> "unknown"
        nick = case mNick m of
          Just n -> n
          Nothing -> "unknown user"
        botMsg = B.concat [ "Hi ", nick, "
                          , your host is ", host]

-- Define on which events to listen:
events = [(Privmsg onMessage)]

--Set up the IRC server configuration. Connect to any list of channels and bind our event:
freenode = 
  (mkDefaultConfig "irc.freenode.net" "awesome-bot")
  { cChannels = ["#haskelldata"]
  , cEvents   = events
  }

-- Connect to the server. Don't run in a new thread, but print debug messages, as specified by the corresponding Boolean parameters:
main = connect freenode False True

-- Run the code, and open an IRC client to test it out: