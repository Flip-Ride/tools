#/bin/bash

LOCALHOST_RUN_LOG_DIR=~/.localhost-run

for key in "$@"
do
    PID=$(cat $LOCALHOST_RUN_LOG_DIR/$key.pid 2>/dev/null)
    echo Killing $PID...
    kill -9 $PID 2>/dev/null
done
