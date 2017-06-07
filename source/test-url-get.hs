import Network.Download


getBody :: String -> IO ()
getBody url = do
    doc <- openURIString url
    case doc :: Either String String of
        Left doc -> print doc
        Right doc -> print doc 
