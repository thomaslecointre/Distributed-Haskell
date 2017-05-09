import Data.List

anagramme xs = xs == reverse xs



import Data.Map

compterLettres :: String -> Map Char Integer
compterLettres = foldr (alter ajouterLettre) empty

ajouterLettre Nothing = Just 1
ajouterLettre (Just a) = Just (a+1)

nombreLettres :: Map Char Integer -> Char -> Integer
nombreLettres m c = case lookup c m of
                      Nothing -> 0
                      Just a -> a










