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
