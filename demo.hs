import Data.List

-- ghc --make demo.hs -o demo.exe
main = do
 f <- readFile "demo.txt"
 let ws = cut f
 let ds = nub ws
 let rs = map (\d -> (d,length (filter (\w -> d==w) ws))) ds
 let ts = map (\(m,c) -> "<tr><td>"++m++"</td><td>"++(show c)++"</td></tr>") rs
 let hs = "<html><body><table>"++(concat ts)++"</table></body></html>"
 writeFile "demo.html" hs

separators = " ',.\n"

cut :: String -> [String]
cut "" = []
cut t = 
 let w = takeWhile (\x -> notElem x separators) t
     r = dropWhile (\x -> elem x separators) (dropWhile (\x -> notElem x separators) t)
 in w:(cut r)