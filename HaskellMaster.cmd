cd Web\Haskell\

if exist Master.exe (
    del Master.exe
)

runhaskell Master.hs 4444
::ghc --make Master.hs -o Master.exe
::del Master.o Master.hi
::call Master.exe 4444