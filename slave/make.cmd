@ECHO OFF

del *.exe *.o *.hi

ghc Slave.hs -o Slave.exe