factoriel 1 = 1
factoriel n = n * factoriel (n-1)

pgcd 0 k = k
pgcd k 0 = k
pgcd a b = pgcd c (mod d c)
    where   c = min a b
            d = max a b

plusPetitDiviseur n = plusGrandDiviseur n 2

plusGrandDiviseur x y
    | mod x y == 0 = y
    | otherwise = plusGrandDiviseur x (y+1)

longueur [] = 0
longueur (x:l) = 1 + longueur l

somme [] = 0
somme (x:l) = x + somme l

produit [] = 0
produit (x:[]) = x
produit (x:l) = x * produit l

myMinimum [x] = x
myMinimum (x:l) = min x (myMinimum l)

{-
myMinimum2 [] = Nothing
myMinimum2 [x] = Just x
myMinimum2 (x:l) = Just (min x (myMinimum2 l))
-}

compter a b
    | a > b = []
    | otherwise = a : (compter (a+1) b)

ajouter1 [] = []
ajouter1 (x:l) = (x+1):(ajouter1 l)

produit2 [] = []
produit2 (x:l) = (x*2) : (produit2 l)

supprimer v [] = []
supprimer v (x:l)
    | x == v = supprimer v l
    | otherwise = x : (supprimer v l)

append [] l2 = l2
append (x:l) l2 = x : (append l l2)

renverser l = renverser' l []
renverser' [] suite = suite
renverser' (x:l) suite = renverser' l (x:suite)



insertion v [] = [v]
insertion v (x:l)
    | v < x = v : x : l
    |otherwise = x : (insertion v l)

triInsertion [] = []
triInsertion (x:l) = insertion x (triInsertion l)



fusion [] l = l
fusion l [] = l
fusion (x:l) (y:l2)
    | x < y = x : (fusion l (y:l2))
    | otherwise = y : (fusion (x:l) l2)

couper [] = ([], [])
couper [x] = ([x], [])
couper (x:y:l) = let (l1, l2) = couper l in (x:l1, y:l2)

triFusion [] = []
triFusion [x] = [x]
triFusion l = let (l1,l2) = couper l in fusion (triFusion l1) (triFusion l2)