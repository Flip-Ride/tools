#/bin/bash

LOCALHOST_RUN_LOG_DIR=~/.localhost-run

for key in $(./show-endpoints.sh | grep "NOT_AVAILABLE" | grep -oE "^\S+"); do
    rm $LOCALHOST_RUN_LOG_DIR/$key.log
    rm $LOCALHOST_RUN_LOG_DIR/$key.port
    rm $LOCALHOST_RUN_LOG_DIR/$key.pid
done	
