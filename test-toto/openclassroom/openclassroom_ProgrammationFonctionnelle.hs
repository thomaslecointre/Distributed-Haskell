transformerElements f [] = []
transformerElements f (x:l) = f x:transformerElements f l

plus1 x = x + 1
fois2 x = x * 2

ajoute1 l = transformerElements plus1 l
multiplie2 l = transformerElements fois2 l

fonctionLouche liste = map (\x y -> x*y + 2*x + 2*y) liste

ajouter n liste = map (\x -> x+n) liste

ajouter1 liste = map (+1) liste
multiplierPar2 liste = map (*2) liste
inverser liste = map (1/) liste

d `divise` n = n `mod` d == 0
diviseurs n = filter (`divise` n) [1..n]

chiffres = ['0'..'9']
lettres = ['a'..'z'] ++ ['A'..'Z']
isChiffre l = l `elem` chiffres
isLettre l = l `elem` lettres
lireNombre :: String -> (Integer,String)
lireNombre xs = let (nombre, suite) = span isChiffre xs in -- vaut ("47"," pommes") si l'entrée est "47 pommes"
                let (_,unite) = break isLettre suite in    -- unite vaut "pommes"
                (read nombre, unite)                       -- (47,"pommes")

prendre5PremiersCaracteres l = take 5 l
-- prendre5PremiersCaracteres "azerty" -> "azert"
prendreAPartirDu6emeCaractere l = drop 5 l
-- prendreAPartirDu6emeCaractere "azertyu" -> "yu"
prendreTantQueE l = takeWhile (\x -> x == 'e') l
-- prendreTantQueE "eeeeeeeazerty" -> "eeeeeee"
prendreApresPremierE l = dropWhile (\x -> x == 'e') l
-- prendreApresPremierE "eeeeeazerty" -> "azerty"



reduire _ n [] = n
reduire f n (x:l) = f x (reduire f n l)

somme l = reduire (+) 0 l
-- somme l = foldr (+) 0 l
produit l = reduire (*) 1 l
-- produit l = foldr (*) 1 l


liste l = foldr (:) [] l
longueur l = foldr (\ _ taille -> 1 + taille) 0 l


-- map2 f (x:l) = foldr (:) [] (f x:l)
-- filter2 f (x:l) = foldr (:) [] (f x:l)



renverser l = foldl (\x y -> y:x) [] l
somme2 l = foldl (+) 0 l
produit2 l = foldl (*) 1 l


myMinimum l = foldr1 min l
myMaximum l = foldr1 max l

myMinimum2 l = foldl1 min l
myMaximum2 l = foldl1 max l




foisDeux l = map (*2) l
plusUn l =  map (+1) l

mapF f = (\l -> map f l)
foisDeux' = mapF (*2)
plusUn' = mapF (+1)


-- foldrF f n = (\l -> foldr f n l)
-- somme3 = foldrF (+) 0
filterF f = (\l -> filter f l)
pairs = filterF even -- renvoie les nombres pairs

f x n = concat (replicate n x)
impairs l = filter odd l
listesFoisDeux l = map (\l -> map (*2) l) l



{-
f $ x = f x

plusMaybe a b = Just (a+b)
plusMaybe a b = Just $ a + b

fonctions = [(+1),(*2),(3-),(2/),abs]
resultats = map (\f -> f 5) fonctions
resultats = map ($ 5) fonctions



reverse = foldl (flip (:)) []

flipFilter = flip filter
selectEntiers = flipFilter [0..]
selectEntiers = flip filter [0..]

flip' f a b = f b a



maFonction = (+1) . (*2)

sommeCarresPairs l = sum . map (^2) . filter even $ l
sommeCarresPairs' = sum . map (^2) . filter even

mem x l = any (== x) l
mem' x = any (==x)
mem'' = any . (==)


owl = ((.)$(.))
dot = ((.).(.))
swing =  flip . (. flip id)


-}