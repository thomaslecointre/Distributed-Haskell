# Kill node process if running
PID_NODE=`ps -ef | grep "node server.js" | head -1 | awk '{print $2}'`

if [ ! -z $PID_NODE ]; 
    then kill $PID_NODE
fi

# kill master process if running

PID_MASTER=`ps -ef | grep "./master.exe" | head -1 | awk '{print $2}'`

if [ ! -z $PID_MASTER ]; 
    then kill $PID_MASTER
fi

# recompile master, messenger

rm *.exe

ghc Distributed-Haskell/web/haskell/master.hs -o Distributed/web/haskell/master.exe
ghc Distributed-Haskell/web/haskell/messenger.hs -o Distributed/web/haskell/messenger.exe

rm *.o *.hi

node Distributed-Haskell/web/server.js &
./Distributed-Haskell/web/haskell/master.exe > master_log &
