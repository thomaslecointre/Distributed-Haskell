@ECHO OFF
::cd Web/Haskell/
cd Web
runhaskell Haskell\main.hs %*
::ghc --make ./main.hs -o main.exe
::del *.o *.hi
::call main.exe %*