import Network
import System.Exit
import System.IO
import System.Environment
import System.Directory
import Numeric
import Control.Concurrent
import Data.String
import Data.List

main = do
    xs <- getArgs
    let seasonName = xs !! 1
    currentPath <- getCurrentDirectory
    threadDelay 50000 -- Give the web server some time to download all files (?? Not sure how to make this work all the time)
    let path = (fixFullPath currentPath) ++ seasonName
    seasons <- listDirectory path
    files <- discoverFiles seasons path
    let arguments = map (show . verifiedLengths) files
    sendOrder 4445 (xs ++ arguments)

-- |Function exists only to solve the strange pathing problems as a result of getCurrentDirectory function.
fixFullPath :: FilePath -- ^ Result of getCurrentDirectory
            -> String   -- ^ Complete path up until public directory
fixFullPath p = do
    if last p == 'b'
        then p ++ "\\public\\"
        else p ++ "\\Web\\public\\" 

-- |Discovers files recently downloaded by web server.
discoverFiles   :: [FilePath]       -- ^ List of season numbers
                -> String           -- ^ Path of season folder
                -> IO [[FilePath]]  -- ^ List of episode numbers organised by season
discoverFiles seasons path = do
    let paths = sort seasons
    let paths' = map ((path ++ "/") ++) paths
    mapM listDirectory paths'

-- |Counts episodes for all seasons. This mitigates the possibility of missing episodes after the api call has finished which could potentially corrupt the work of Slaves.
verifiedLengths :: [FilePath] -- ^ List of episode numbers
                -> Int        -- ^ Number of episodes actually downloadable
verifiedLengths seasonEpisodes = do
    let episodeCount = length seasonEpisodes
    let verifiedEpisodes = takeWhile (\n -> elem (show n) seasonEpisodes) [1..episodeCount]
    length verifiedEpisodes


{-|
    Sends the order received from web server to Master haskell process.
-}
sendOrder   :: PortNumber   -- ^ The port number used for communicating with master haskell process
            -> [String]     -- ^ Arguments received in main from web server
            -> IO ()
sendOrder port xs = withSocketsDo $ do
    print $ "Connecting to Master @localhost:" ++ (show port)
    handle <- connectTo "localhost" (PortNumber port)
    hSetBuffering handle LineBuffering
    hPutStrLn handle (show xs)
    response <- hGetLine handle
    if response == "KO" 
        then die "Master was unable to process request"
        else if response == "OK"
            then exitSuccess
            else die "Unexpected failure"
    
