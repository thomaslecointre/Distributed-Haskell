@ECHO OFF

del *.exe *.hi *.O
ghc Master.hs -o Master.exe
ghc Messenger.hs -o Messenger.exe