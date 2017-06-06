import Data.String

main :: IO ()
main = do
    let addr = "[::ffff:86.243.175.105]:6350"
    putStrLn $ stripIP addr

stripIP :: String -> String
stripIP addr = do
    let elements = words (map whiteSpace addr)
    elements !! 2

whiteSpace :: Char -> Char
whiteSpace ':' = ' '
whiteSpace ']' = ' '
whiteSpace c = c