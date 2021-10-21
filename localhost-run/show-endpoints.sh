#/bin/bash

LOCALHOST_RUN_LOG_DIR=~/.localhost-run

for f in $LOCALHOST_RUN_LOG_DIR/*.log; do
    BASENAME=$(basename $f)
    KEY=${BASENAME%.log}
    PORT=$(cat $LOCALHOST_RUN_LOG_DIR/$KEY.port 2>/dev/null)
    PID=$(cat $LOCALHOST_RUN_LOG_DIR/$KEY.pid 2>/dev/null)
    ENDPOINT=$(grep -oE "https://.*.lhr.domains" $f)
    curl -s $ENDPOINT | grep "no ssh tunnel here" 2>&1 > /dev/null
    if [ $? -ne 0 ]; then
        AVAILABILITY=AVAILABLE
    else
        AVAILABILITY=NOT_AVAILABLE
    fi	
    echo "$KEY     $ENDPOINT     $PORT     $AVAILABILITY     $PID     $LOCALHOST_RUN_LOG_DIR/$KEY.log"
done
