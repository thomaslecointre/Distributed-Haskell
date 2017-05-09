-- import System.Environment
-- import Data.Set
import Data.Aeson
import Data.ByteString.Lazy
import Data.ByteString.Lazy.Char8 (unlines)

import Control.Monad (mzero)
import Control.Applicative ((<$>), (<*>))

import Prelude hiding (unlines)


testJson = unlines
    [ "{"
    , "  \"serie\": \"Game of Thrones\","
    , "  \"saison\": \"1\","
    , "  \"episode\": \"1\","
    , "  \"titre\": \"Winter Is Coming\","
    , "  \"resume\": \"Jon Arryn, the Hand of the King, is dead. King Robert Baratheon plans to ask his oldest friend, Eddard Stark, to take Jon's place. Across the sea, Viserys Targaryen plans to wed his sister to a nomadic warlord in exchange for an army.\""
    , "}"
    ]

data NuageDeMots = NuageDeMots
    { mot :: String
    , occurence :: String
    } deriving (Eq, Show)

data Serie = Serie
    { serie :: String
    , saison :: String
    , episode :: String
    , titre :: String
    , resume :: String
--    , nuageDeMots :: NuageDeMots
    } deriving (Eq, Show)

instance FromJSON NuageDeMots where
    parseJSON (Object v) = do
        mot <- v .: "mot"
        occurence  <- v .: "occurence"
        return $ NuageDeMots mot occurence
    parseJSON _ = mzero

instance FromJSON Serie where
    parseJSON (Object v) = do
        serie     <- v .: "serie"
        saison     <- v .: "saison"
        episode     <- v .: "episode"
        titre     <- v .: "titre"
        resume     <- v .: "resume"
--        nuage <- v .: "nuageDeMots"
--        nuageDeMots    <- parseJSON nuage
--        return $ Serie serie saison episode titre resume nuageDeMots
        return $ Serie serie saison episode titre resume nuageDeMots

{-
main = do
    setLocaleEncoding utf8
    args <- getArgs
    case args of 
      jsonFile -> do
        let path = "C:/Users/Tom/Documents/GitKraken/Distributed-Haskell/serie/Game of Thrones S1 E1.json"
        contents <- readFile path -- jsonFile
        testJson <- unlines contents
        case decode testJson :: Maybe Serie of
          Just serie -> print serie
          Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
-}
main = case decode testJson :: Maybe Serie of
    Just serie -> print serie
    Nothing -> Prelude.putStrLn "Couldn't parse the JSON data"
        
        

{-
src <- openURL ("http://www.imdb.com/title/" ++ (reference !! 0) ++ "/episodes?season=1")
print src
writeFile ((reference !! 0) ++ ".html") src
-}
{-
https://gist.github.com/bheklilr/98ac8f8e663cf02fcaa6
-}