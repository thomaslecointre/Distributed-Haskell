import Network.Info
import System.IO
import System.Environment


main = do
    interfaces <- getNetworkInterfaces
    mapM extractIP interfaces

extractIP :: NetworkInterface -> IO ()
extractIP interface = print $ "Network : " ++ (name interface) ++ " IP : " ++ show (ipv4 interface)