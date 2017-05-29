cd Haskell

if exist Messenger.exe (
    del Messenger.exe
)

runhaskell Messenger.hs %*
::ghc --make Messenger.hs -o Messenger.exe
::del Messenger.o Messenger.hi
::call Messenger.exe %*
