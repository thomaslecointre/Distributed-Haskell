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
    if last currentPath == 'b'
        then do
            let path = currentPath ++ "\\public\\" ++ seasonName
            seasons <- listDirectory path
            files <- discoverFiles seasons path
            let arguments = map (show . verifiedLengths) files
            sendOrder 4445 (xs ++ arguments)
        else do
            let path = currentPath ++ "\\Web\\public\\" ++ seasonName
            seasons <- listDirectory path
            files <- discoverFiles seasons path
            let arguments = map (show . verifiedLengths) files
            sendOrder 4445 (xs ++ arguments)


discoverFiles :: [FilePath] -> String -> IO [[FilePath]]
discoverFiles seasons path = do
    let paths = sort seasons
    let paths' = map ((path ++ "/") ++) paths
    mapM listDirectory paths'

verifiedLengths :: [FilePath] -> Int
verifiedLengths seasonEpisodes = do
    let episodeCount = length seasonEpisodes
    let verifiedEpisodes = takeWhile (\n -> elem (show n) seasonEpisodes) [1..episodeCount]
    length verifiedEpisodes


{-|
    Sends the order received from web server to master haskell process.
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
    
