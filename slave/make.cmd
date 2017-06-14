@ECHO OFF

del *.exe

ghc Slave.hs -o Slave.exe

del *.o *.hi