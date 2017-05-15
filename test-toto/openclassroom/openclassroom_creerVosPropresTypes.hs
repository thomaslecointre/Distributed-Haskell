-- type String = [Char]

type Couleur = (Double, Double, Double)

palette :: [Couleur]
palette = [(1,0,0), (0,1,1), (0,1,0)]

inverser :: Couleur -> Couleur
inverser (r,g,b) = (1-r,1-g,1-b)



data Parfum = 
    Chocolat 
    | Vanille 
    | Framboise
    deriving Show

prixParfum :: Parfum -> Double
prixParfum Chocolat = 1.5
prixParfum Vanille = 1.2
prixParfum Framboise = 1.4

data Booleen = Vrai | Faux

data Glace = UneBoule Parfum
    | DeuxBoules Parfum Parfum
    deriving Show

prixGlace (UneBoule a) = 0.10 + prixParfum a
prixGlace (DeuxBoules a b) = 0.15 + prixParfum a + prixParfum b



type Point = (Float,Float)
-- newtype Point = Point (Float,Float)

data Forme = Cercle Point Float | Rectangle Point Point

aire :: Forme -> Float
aire (Rectangle (a,b) (c,d)) = abs (a-c) * abs (b-d)
aire (Cercle _ r) = pi * r^2

perimetre :: Forme -> Float
perimetre (Rectangle (a,b) (c,d)) = 2 * ( abs (a-c) + abs (b-d) )
perimetre (Cercle _ r) = 2 * pi * r


{-
data Date = Date Int Int Int

data Client = Client String String String Date Date Float

nouveauClient :: String -> String -> String -> Client
nouveauClient nom prenom mail = Client nom prenom mail (Date 0 0 0) (Date 0 0 0) 0

actualiserClient :: Date -> Float -> Client -> Client
actualiserClient date somme (Client nom prenom mail premiereCommande _ sommeCommandes) =
    Client nom prenom mail premiereCommande date (sommeCommandes + somme)

mailClient :: Client -> String
mailClient (Client _ _ mail _ _ _) = mail
-}
data Date = Date Int Int Int
    deriving Show

data Client = Client {
      nom :: String,
      prenom :: String,
      mail :: String,
      premiereCommande :: Date,
      derniereCommande :: Date,
      sommeCommandes :: Float
    } deriving Show

unClient = Client { nom = "Dupont",
                    prenom = "Hubert",
                    mail = "hubert.dupont@example.com",
                    premiereCommande = Date 1 2 2003,
                    derniereCommande = Date 9 9 2009,
                    sommeCommandes = 13.3
                  }

autreClient = Client "Dupont" "Robert" "rdupont@example.com" (Date 29 2 2003) (Date 1 10 2009) 42

nomPrenom (Client {nom = nom, prenom = prenom}) = nom ++ " " ++ prenom
nomPrenom' client = nom client ++ " " ++ prenom client

actualiserClient :: Date -> Float -> Client -> Client
actualiserClient date somme client = client {
                                       derniereCommande = date, 
                                       sommeCommandes = sommeCommandes client + somme
                                     }




data SomeInt = SomeInt Int [Int]

someIntToList :: SomeInt -> [Int]
someIntToList (SomeInt x xs) = x:xs

addInt :: Int -> SomeInt -> SomeInt
addInt i s = SomeInt i (someIntToList s)


data Some a = Some a [a]

someToList :: Some a -> [a]
someToList (Some x xs) = x:xs

add :: a -> Some a -> Some a
add i s = Some i (someToList s)


type Assoc a b = [(a,b)]


data MyList a = Nil | Cons a (MyList a)


liste = Cons 1 (Cons 2 (Cons 3 Nil))


data Arbre a = Branche a (Arbre a) (Arbre a)
             | Feuille 
               deriving Show

arbreExemple = Branche 1 
                (Branche 2 
                  (Branche 4 Feuille Feuille) 
                  (Branche 5 
                   (Branche 7 Feuille Feuille) 
                   (Branche 8 Feuille Feuille)))
                (Branche 3 
                  Feuille
                  (Branche 6
                    (Branche 9 Feuille Feuille)
                    Feuille))

profondeur Feuille = 0
profondeur (Branche _ gauche droite) = 1 + max (profondeur gauche) (profondeur droite)

feuilles Feuille = 1
feuilles (Branche _ gauche droite) = feuilles gauche + feuilles droite

branches Feuille = 0
branches (Branche _ gauche droite) = 1 + branches gauche + branches droite

somme Feuille = 0
somme (Branche el gauche droite) = el + somme gauche + somme droite

foldArbre f n Feuille = n
foldArbre f n (Branche e d g) = f e (foldArbre f n d) (foldArbre f n g)

profondeur' = foldArbre (\ _ d g -> 1 + max d g) 0
feuilles' = foldArbre (\ _ d g -> d + g) 1
branches' = foldArbre (\ _ d g -> 1 + d + g) 0
somme' = foldArbre (\ e d g -> e + d + g) 0

retourner = foldArbre (\ e d g -> Branche e g d) Feuille




allArbre _ Feuille = True
allArbre p (Branche e g d) = p e && allArbre p g && allArbre p d

abrValide Feuille = True
abrValide (Branche e g d) = allArbre (< e) g && allArbre (> e) d && abrValide g && abrValide d

abr = Branche 10 
      (Branche 5 Feuille (Branche 8 (Branche 7 Feuille Feuille) (Branche 9 Feuille Feuille)))
      (Branche 20 
       (Branche 15 (Branche 12 Feuille Feuille) (Branche 17 Feuille Feuille))
       (Branche 25 Feuille Feuille))

invalide = Branche 10 Feuille (Branche 3 Feuille Feuille)

rechercher _ Feuille = False
rechercher e (Branche f g d) | e == f = True
                             | e < f = rechercher e g
                             | e > f = rechercher e d

inserer e Feuille = Branche e Feuille Feuille
inserer e (Branche f g d) | e == f = Branche f g d
                          | e < f = Branche f (inserer e g) d
                          | e > f = Branche f g (inserer e d)

construireArbre :: (Ord a) => [a] -> Arbre a
construireArbre = foldr inserer Feuille

aplatir :: Arbre a -> [a]
aplatir = foldArbre (\e g d -> g ++ [e] ++ d) []

aplatir' Feuille = []
aplatir' (Branche e g d) = aplatir' g ++ [e] ++ aplatir' d

triABR :: (Ord a) => [a] -> [a]
triABR = aplatir . construireArbre

supprimerPlusGrand (Branche e g Feuille) = (g,e)
supprimerPlusGrand (Branche e g d) = let (d',grand) = supprimerPlusGrand d in 
                                     (Branche e g d', grand) 

supprimerRacine (Branche _ Feuille Feuille) = Feuille
supprimerRacine (Branche _ g Feuille) = g
supprimerRacine (Branche _ Feuille d) = d
supprimerRacine (Branche _ g d) = Branche e' g' d
    where (g',e') = supprimerPlusGrand g

supprimer _ Feuille = Feuille
supprimer e (Branche f g d) | e == f = supprimerRacine (Branche f g d)
                            | e < f = Branche f (supprimer e g) d
                            | e > f = Branche f g (supprimer e d)



data Expr =
            Litt Integer
          | Var String
          | Add Expr Expr
          | Mul Expr Expr
        deriving (Eq)
--            deriving (Eq, Show)

expressionExemple = Add (Mul (Var "x") (Var "x")) (Add (Mul (Litt 7) (Var "x")) (Litt 1))

valeur ctx var = snd $ head $ filter (\(nom,_) -> nom == var) ctx

eval ctx (Add a b) = eval ctx a + eval ctx b
eval ctx (Mul a b) = eval ctx a * eval ctx b
eval ctx (Litt a) = a
eval ctx (Var s) = valeur ctx s 

-- On évalue l'expression test pour x=5
valTest = eval [("x",5)] expressionExemple

developper (Add x y) = Add (developper x) (developper y)
developper (Mul x y) = case (developper x, developper y) of
                          (Add a b,y') -> developper (Add (Mul a y') (Mul b y'))
                          (x', Add a b) -> developper (Add (Mul x' a) (Mul x' b))
                          (x',y') -> Mul x' y'
developper e = e



{-
data Parfum2 = Chocolat2
    | Vanille2
    | Framboise2
    deriving (Eq, Show, Read)

*Main> show Framboise2
"Framboise2"
*Main> read "Framboise2" :: Parfum2
Framboise2
*Main> Framboise2 == Chocolat2
False
*Main> Vanille2 == Vanille2
True
-}

instance Eq Parfum where
    Chocolat == Chocolat = True
    Vanille == Vanille = True
    Framboise == Framboise = True
    _ == _ = False

instance Ord Parfum where
    _ <= Framboise = True
    Chocolat <= Chocolat = True
    Vanille <= Vanille = True
    Vanille <= Chocolat = True
    _ <= _ = False




instance (Eq a) =>  Eq (Arbre a) where
    a == b = aplatir a == aplatir b



{-
instance Show Expr where
    show (Litt a) | a < 0 = "("++ show a ++ ")"
                  | otherwise = show a
    show (Var s) = s
    show (Add a b) = "(" ++ show a ++ "+" ++ show b ++ ")"
    show (Mul a b) = "(" ++ show a ++ "*" ++ show b ++ ")"

expr1 = Add (Add (Mul (Var "x") (Var "x")) (Mul (Litt 3) (Var "x"))) (Litt 7)
expr2 = Add (Add (Mul (Var "x") (Var "x")) (Mul (Litt 3) (Mul (Var "y") (Var "y")))) (Litt 2)
-}
addPar k n s | k <= n = s
             | otherwise = "(" ++ s ++ ")"

showExpr k (Add a b) = addPar k 0 (showExpr 0 a ++ "+" ++ showExpr 0 b)
showExpr k (Mul a b) = addPar k 1 (showExpr 1 a ++ "*" ++ showExpr 1 b)
showExpr _ (Var s) = s
showExpr _ (Litt a) | a < 0 = "("++ show a ++ ")"
                    | otherwise = show a 

instance Show Expr where
    show e = showExpr 0 e

instance Num Expr where
    (+) = Add
    (*) = Mul
    negate = Mul (Litt (-1))
    fromInteger = Litt

x = Var "x"
y = Var "y"

exprTest = 3*x^5 + 7*x + 9 + 12 * x * y
{-
*Main> eval [("x",5),("y",12)] exprTest
10139
*Main>  eval [("x",5),("y",12)] (exprTest ^ 2)
102799321
-}




class OuiNon a where
    toBool :: a -> Bool

instance OuiNon Bool where
    toBool = id

instance OuiNon Int where
    toBool 0 = False
    toBool _ = True

instance OuiNon Integer where
    toBool 0 = False
    toBool _ = True

instance OuiNon [a] where
    toBool [] = False
    toBool _ = True

instance OuiNon (Arbre a) where
    toBool Feuille = False
    toBool _ = True

instance OuiNon (Maybe a) where
    toBool Nothing = False
    toBool _ = True



{-
class  (Eq a) => Ord a  where
    compare              :: a -> a -> Ordering
    (<), (<=), (>), (>=) :: a -> a -> Bool
    max, min             :: a -> a -> a

    compare x y = if x == y then EQ
                  else if x <= y then LT
                  else GT

    x <  y = case compare x y of { LT -> True;  _ -> False }
    x <= y = case compare x y of { GT -> False; _ -> True }
    x >  y = case compare x y of { GT -> True;  _ -> False }
    x >= y = case compare x y of { LT -> False; _ -> True }

    max x y = if x <= y then y else x
    min x y = if x <= y then x else y
-}