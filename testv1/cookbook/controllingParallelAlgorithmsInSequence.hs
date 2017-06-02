-- cabal install parallel

import Control.Parallel
import Control.Parallel.Strategies

task1 = 2^2^11 :: Integer
task2 = 2^3^10 :: Integer
task3 = 2^4^9 :: Integer
task4 = 2^5^8 :: Integer
task5 = 2^6^7 :: Integer
task6 = 2^7^6 :: Integer
task7 = 2^8^5 :: Integer

-- Evaluate two tasks in parallel, and wait for both tasks to finish before returning.
main = do
  print $ runEval $ do
    a <- rpar task1
    b <- rpar task2
    c <- rpar task3
    d <- rpar task4
    e <- rpar task5
    f <- rpar task6
    g <- rpar task7
    rseq a
    rseq b
    rseq c
    rseq d
    rseq e
    rseq f
    rseq g
    return $ maximum [(a,1), (b,2), (c,3), (d,4), (e,5), (f,6), (g,7)]

{-
Compile the code with the threaded and rtsopts flags enabled as follows:
$ ghc -O2 --make Main.hs -threaded –rtsopts

Run it by specifying the number of cores as follows:
$ ./Main +RTS -N2
-}