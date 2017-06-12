@ECHO OFF

del *.exe
ghc Master.hs -o Master.exe
ghc Messenger.hs -o Messenger.exe
del *.hi *.o