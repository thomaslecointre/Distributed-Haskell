{-
1 Des fonctions myMin et myMax qui prennent chacune deux arguments et renvoient respectivement le minimum et le maximum des deux arguments
2 À partir de ces fonctions, codez une fonction qui donne le minimum ou le maximum de 4 nombres
3 En utilisant myMin et myMax, codez une fonction bornerDans qui prend trois arguments et renvoie le troisième argument s'il est dans l'intervalle formé par les deux premiers, ou renvoie la borne de l'intervalle la plus proche.
Exemples:
bornerDans 5 7 6 = 6 -- dans l'intervalle
bornerDans 5 7 4 = 5 -- trop petit
bornerDans 5 7 9 = 7 -- trop grand

4 Codez une fonction qui prend trois arguments et dit si le troisième argument est dans l'intervalle fermé formé par les deux premiers arguments (on considèrera que le premier argument est inférieur ou égal au deuxième)
5 En n'utilisant qu'une seule comparaison, codez une fonction qui prend une paire de nombre et renvoie cette paire triée
6 Codez une fonction qui prend deux vecteurs représentés par des paires de nombres, et donne la somme de ces deux vecteurs
7 Codez une fonction qui prend un vecteur et renvoie sa norme
8 Codez une fonction qui prend un nombre et un vecteur, et renvoie le produit du vecteur par ce nombre
9 Codez une fonction qui prend deux vecteurs et renvoie le produit scalaire de ces deux vecteurs
-}

-- 1
myMin a b = if a < b then a else b
myMax a b = if a > b then a else b

-- 2
myMinimum a b c d = myMin e f
    where   e = myMin a b
            f = myMin c d

myMaximum a b c d = myMax e f
    where   e = myMax a b
            f = myMax c d

-- 3
bornerDans a b c = if c < a then a else if b < c then b else c

-- 4
bornerBool a b c = if (a <= c && c <= b) then True else False

-- 5
triPaire (a, b) = if a < b then (a, b) else (b, a)

-- 6
--sommeVecteur (a, b) (c, d) = (a + c, (sommeVecteur b d))
sommeVecteur (a, b) (c, d) = (a + c, b + d)
--sommeVecteur (a) (c) = (a + c)

-- 7
normeVecteur (a, b) = sqrt(a * a + b * b)

-- 8
produitVecteur x (a, b) = (x * a, x * b)

-- 9
produitScalaireVecteur (a, b) (x, y) = (b*x-a*y, a*y-b*x)
{-
produitScalaireVecteur v1 v2 = case v1 v2 of
    (a, b) (x, y) -> (b*x-a*y, a*y-b*x)
    (a, b, c) (x, y, z) -> (b*z-c*y, c*x-a*z, a*y-b*x)
-}






{-
let paire = (12, 'c')
:t paire
let triplet = (24, 'd', paire)
:t triplet()

construireTriplet x y z = (x, y, z)
:t construireTriplet

:t (:)
1:[]
:t (++) 
"bonjour " ++ "thomas"
:t reverse
reverse [0..5]
:t concat
concat [[0..5], [6..10]]

:t (+)

gcd 40 50
lcm 40 50

les classes :
Num : addition, soustraction, multiplication, fromInteger
Real : toRational
Integral : Int (entiers à nombre de chiffre limité), Integer (entiers sans limite), div, mod, gcd, lcm, toInteger
Fractional : division
Floating : trigonométrie, exponentielle et logarithme
RealFrac : arrondi vers le haut et vers le bas

Eq : == et /=
Ord : comparaison
Enum : notation de séquences : [1..10] et ['a'..'z']

Show : show (show 42, show [1,2,3])
Read : read (read "42" :: Int, read "[1,2,3]" :: [Int])

-}