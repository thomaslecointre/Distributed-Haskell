import Data.List
import Data.Char

factorial :: Integer -> Integer
factorial 1 = 1
factorial n = n * factorial (n - 1)

-- Transfers list items from first list to the second
transferListItems :: [Int] -> [Int] -> [Int]
transferListItems [] v = v
transferListItems u v = transferListItems (tail u) (v ++ [(head u)])

-- Removes any multiple occurences of a in a list
compress :: (Eq a) => [a] -> [a]
compress [] = []
compress t = concat (map nub (group t))

-- Maps occurence of each character resulting in a list of tuples
encode :: (Eq a) => [a] -> [(Int, a)]
encode l = zip (map length $ group l) (compress l)

data ListItem a = Single a | Multiple Int a
	deriving (Show)

encodeModified :: (Eq a) => [a] -> [ListItem a]
encodeModified = map encodeHelper . encode
  where
	encodeHelper (1,x) = Single x
	encodeHelper (n,x) = Multiple n x

decodeModified :: [ListItem a] -> [a]
decodeModified = concatMap decode
  where
    decode (Single a) = [a]
    decode (Multiple n a) = replicate n a
	
pertinence :: [Char] -> [Char] -> Int
pertinence m [] = 0
pertinence m l = do
			let table = words l
			if tail m == "s" 
			then do
				if (length (filter (== m) table)) == 0
				then length (filter (== m) table)
				else do
					let m' = init m
					length (filter (== m') (words l))
			else length (filter (== m) (words l))

crypt s = 
        if elem ' ' s 
        then unwords ( map crypt (words s) )
        else map (chr . (+1) . ord) s