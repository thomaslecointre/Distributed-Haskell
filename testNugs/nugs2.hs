import Data.Char
-- ghci
-- :load nugs2.hs

data Liste x = Vide | Ajout x (Liste x)
    deriving (Show)

longueur Vide = 0
longueur (Ajout x l) = 1 + (longueur l)

ameliore Vide w = Vide
ameliore (Ajout x l) w = Ajout (x + w) (ameliore l w)

concatene Vide l2 = l2
concatene (Ajout x l) l2 = Ajout x (concatene l l2)

-- longueur (ameliore l w) = l
-- longueur (concatene l1 l2) = (longueur l1) + (longueur l2)
-- ameliore (concatene l1 l2) w = concatene (ameliore l1 w) (ameliore l2 w)

map' f Vide = Vide
map' f (Ajout x l) = Ajout (f x) (map' f l)

crypt l = map' (chr . (+1) . ord) l
-- crypt (Ajout 't' (Ajout 'h' Vide))




-- crypt l = map chr (map (+1) (map ord l))
-- crypt = map (chr . (+1) . ord)
-- crypt "thomas"
-- map crypt ["thomas","toto"]