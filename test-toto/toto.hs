-- ghci
-- :load nugs.hs
-- :t Z
-- :t Main.True
-- :r

data Bool' = True | False

data N = Z | S N
    deriving (Show)

plus :: N -> N -> N
plus Z x = x
plus (S x) y = S (plus x y)

data Liste = Vide | Ajout Int Liste
    deriving (Show)

longueur :: Liste -> Int
longueur Vide = 0
longueur (Ajout x l) = 1 + longueur l

ameliore :: Liste -> Int -> Liste
ameliore Vide x = Vide
ameliore l 0 = l
ameliore (Ajout x l) w = Ajout (x + w) (ameliore l w)

concatene :: Liste -> Liste -> Liste
concatene Vide w = w
concatene (Ajout x l) w = Ajout x (concatene l w)


prop1 = \l -> \w -> longueur (ameliore l w) == longueur l
-- prop1 (Ajout 1 Vide) 12
-- prop1 [1..10] 2


prop2 = \l1 -> \l2 -> longueur (concatene l1 l2) == (longueur l1) + (longueur l2)
-- prop2 (Ajout 1 (Ajout 2 Vide)) (Ajout 3 Vide)

-- prop3 = \l1 -> \l2 -> \w -> ameliore (concatene l1 l2) w == concatene (ameliore l1 w) (ameliore l2 w)
-- prop4 = \l -> \w -> ameliore (ameliore l w) (-w) == l
-- prop5 = \l1 -> \l2 -> \l3 -> concatene (concatene l1 l2) l3 == concatene l1 (concatene l2 l3)

data Liste2 = Int Liste
   deriving (Show)

-- Vide2 = 0 Vide
-- Ajout2 x (n l) = (n+1) (Ajout x l)
longueur2 0 Vide = 0
longueur2 n (Ajout x l) = n

map' f Vide = Vide
map' f (Ajout x l) = Ajout (f x) (map' f l)
-- map' (+5) (Ajout 1 (Ajout 2 Vide))





