{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import Data.Aeson
import qualified Data.ByteString.Lazy as B
import GHC.Generics
import Control.Concurrent



data Serie = Serie { serie :: String, saison :: String, episode :: String , titre :: String, resume :: String, nuageDeMots ::  Maybe [NuageDeMots] }
    deriving (Show, Generic)

instance FromJSON Serie
instance ToJSON Serie

data NuageDeMots = NuageDeMots { mot :: String, occurence :: String }
    deriving (Show, Generic)

instance FromJSON NuageDeMots
instance ToJSON NuageDeMots


-- Define the code that will be forked to run in parallel as follows:
process m = do 
  putStrLn "waiting..."
  v <- takeMVar m
  resp <- get v
  putStrLn $ "response from " ++ show v ++ " is " ++ resp
  process m

get :: String -> IO String
get path = do
    testJson <- B.readFile path
    let req = decode testJson :: Maybe Serie
    case req of
        Nothing -> print "error parsing JSON"
        Just success -> (putStrLn.greet) success

greet m = "saison " ++ (show.saison) m ++ " episode " ++ (show.episode) m









main = do
  m <- newEmptyMVar
  forkIO $ process m
  putStrLn "Saison 1 ep 1"
  putMVar m "../../serie/Game_of_Thrones_S1_E1.json"
--  putMVar m "D:\tompe\Documents\workspace\git_Haskell\Distributed-Haskell\serie\Game_of_Thrones_S1_E1.json"
{-  putStrLn "Saison 1 ep 2"
  putMVar m "D:\tompe\Documents\workspace\git_Haskell\Distributed-Haskell\serie\Game_of_Thrones_S1_E2.json"
  putStrLn "Saison 1 ep 3"
  putMVar m "D:\tompe\Documents\workspace\git_Haskell\Distributed-Haskell\serie\Game_of_Thrones_S1_E3.json"
  putStrLn "Saison 2 ep 1"
  putMVar m "D:\tompe\Documents\workspace\git_Haskell\Distributed-Haskell\serie\Game_of_Thrones_S2_E1.json"
  putStrLn "Saison 2 ep 2"
  putMVar m "D:\tompe\Documents\workspace\git_Haskell\Distributed-Haskell\serie\Game_of_Thrones_S2_E2.json"-}
-- To make sure main does not terminate before the forked process is finished, we just force main to wait for 10 seconds by calling the threadDelay function. This is for demonstration purposes only, and a complete solution should terminate main immediately once the fork is complete, as presented in the following code snippet:
  threadDelay $ 10 * 1000000
