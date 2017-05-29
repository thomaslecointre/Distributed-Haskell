import Network
import Network.Info
import System.IO
import System.Environment


main = do
    interfaces <- getNetworkInterfaces
    -- mapM extractIP interfaces
    connect

connect :: IO ()
connect = withSocketsDo $ do
    let port = fromIntegral 4444
    handle <- connectTo "192.168.1.13" (PortNumber port)
    -- hPutStrLn handle $ show 123456789
    hClose handle


extractIP :: NetworkInterface -> IO ()
extractIP interface = print $ "Network : " ++ (name interface) ++ " IP : " ++ show (ipv4 interface)