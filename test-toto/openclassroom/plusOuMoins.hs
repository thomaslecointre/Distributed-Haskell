import System.Random

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
      putStrLn $ "Bravo, vous avez trouvé le nombre en " ++ show (ncoups + 1) ++ " essais"
      return (ncoups + 1)

jouer :: Int -> Int -> IO Int
jouer xmin xmax = do
  x <- randomRIO (xmin,xmax)
  plusOuMoins x xmin xmax 0

main = jouer 1 100
