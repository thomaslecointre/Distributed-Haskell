import qualified Data.List as L

import Data.Map (Map)
import qualified Data.Map as M

import Data.Char

import System.Random

import Control.Monad

import Data.List


anagramme xs = xs == L.reverse xs


compterLettres :: String -> Map Char Integer
compterLettres = foldr (M.alter ajouterLettre) M.empty

ajouterLettre Nothing = Just 1
ajouterLettre (Just a) = Just (a+1)

nombreLettres :: Map Char Integer -> Char -> Integer
nombreLettres m c = case M.lookup c m of
                      Nothing -> 0
                      Just a -> a



conversation nom = do
  putStrLn $ "Bonjour " ++ nom
  putStrLn "Au revoir"

lireMot = do
  putStrLn "Entrez un mot"
  x <- getLine
  putStrLn "Merci !"
  return x

echo = do
  mot <- lireMot
  putStrLn $ "Vous avez dit " ++ mot

retourner = do
  mot <- lireMot
  let envers = reverse mot
  putStrLn $ "Dites plutôt " ++ envers

motSecret x = do
  putStrLn "Entrez le mot secret"
  m <- getLine
  if x == m
    then do
        putStrLn "Vous avez trouvé !"
    else do
        putStrLn "Non, ce n'est pas le mot secret"
        motSecret x

plusOuMoins x xmin xmax ncoups = do
  putStrLn $ "Entrez un nombre entre " ++ show xmin ++ " et " ++ show xmax
  y <- readLn
  case compare x y of 
    LT -> do
      putStrLn "Plus petit !"
      plusOuMoins x xmin (y-1) (ncoups + 1)
    GT -> do
      putStrLn "Plus grand !"
      plusOuMoins x (y+1) xmax (ncoups + 1)
    EQ -> do
      putStrLn $ "Bravo, vous avez trouvé le nombre en " ++ show ncoups ++ " essais"

ouiNon :: String -> Maybe Bool
ouiNon s = if s' `elem` oui 
                then Just True 
           else if s' `elem` non 
                then Just False 
                else Nothing
    where oui = ["y","yes","oui","o"]
          non = ["n","no","non"]
          s' = map toLower s

lireValide lire = do
  s <- getLine
  case lire s of
    Nothing -> do
                putStrLn "Réponse invalide"
                lireValide lire
    Just r -> return r

lireOuiNon = lireValide ouiNon





random2 :: (RandomGen g) => g -> (Int,Int,g)
random2 gen = let (a,gen2) = random gen in
              let (b,gen3) = random gen2 in
              (a,b,gen3)

jouer xmin xmax = do
  x <- randomRIO (xmin,xmax)
  plusOuMoins x xmin xmax 0




majuscule = forever $ do
         l <- getLine
         putStrLn $ map toUpper l


nAffichePasBonjour = forever $ do
         l <- getLine
         unless ("bonjour" `isPrefixOf` l) $ putStrLn l


--compter n = sequence $ map (putStrLn . show) [1..n]
compter n = mapM (putStrLn . show) [1..n]
--compter n = mapM_ (putStrLn . show) [1...n]


allo = do
  putStr "Dites quelque chose: "
  l <- getLine
  putStr "Vous avez dit : "
  putStrLn l


import System.IO

{-
main = do
  hSetBuffering stdout NoBuffering
  hSetBuffering stdin NoBuffering
  r <- ouiNon
  putStrLn $ show r

ouiNon = do
  putStr "Oui ou non? "
  c <- getChar
  putChar '\n'
  case c of
    'y' -> return True
    'n' -> return False
    _ ->  ouiNon
-}

{-
compteCaractereLigne = do 
  l <- getContents
  mapM_ (print . length) (lines l)

compteCaractereLigne2 = interact (unlines . map (show . length) . lines)




main = do
  withFile "test" ReadMode 
       (\inp -> withFile "test.num" WriteMode 
        (\outp -> numeroter inp outp 1))


main = do
  x <- readFile "test"
  writeFile "test.num" $ unlines . zipWith (\n l -> show n ++ ": " ++ l) [1..] . lines $ x


import System.Environment
import Control.Monad

main = do
  p <- getProgName
  putStrLn $ "Nom du programme: " ++ p
  a <- getArgs
  mapM_ putStrLn a



-}












