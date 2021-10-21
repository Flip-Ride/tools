#/bin/bash

usage() { echo "Usage: $0 -k <key> -p <port>" 1>&2; exit 1; }

LOCALHOST_RUN_LOG_DIR=~/.localhost-run

while getopts ":k:p:" o; do
    case "${o}" in
        k)
            KEY=${OPTARG}
            ;;
        p)
            PORT=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${PORT}" ] || [ -z "${KEY}" ]; then
    usage
fi

[[ ! -d $LOCALHOST_RUN_LOG_DIR ]] && mkdir $LOCALHOST_RUN_LOG_DIR

nohup ssh -R 80:localhost:$PORT nokey@localhost.run > $LOCALHOST_RUN_LOG_DIR/$KEY.log 2>&1 &

echo $! > $LOCALHOST_RUN_LOG_DIR/$KEY.pid

echo $LOCALHOST_RUN_LOG_DIR/$KEY.log

echo "$PORT" > $LOCALHOST_RUN_LOG_DIR/$KEY.port


