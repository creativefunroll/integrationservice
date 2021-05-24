#!/bin/bash

#SCRIPT_DIR=/home/bbase
SCRIPT_DIR="$HOME"

. "$SCRIPT_DIR/is-config.sh"

if [ ! -f "$APPLICATION_PATH" ];
then
    echo "Incorrect application path '$APPLICATION_PATH'."
    exit 1
fi

if lsof -t "-i:$APPLICATION_PORT" -sTCP:LISTEN &> /dev/null;
then
    echo "Port $APPLICATION_PORTis in use.";
    exit 1
fi

if [ -f "$PID_PATH" ];
then
    PROCESS_PID=`cat "$PID_PATH"`

    if [ -n "$PROCESS_PID" ];
    then
        echo "$APPLICATION_NAME start operation error!"
        echo "Wait until previous start operation will be done or remove '$PID_PATH' file manually if you are sure the application is not starting."
        exit 1
    fi
fi

#nohup "$JAVA_HOME/bin/java" -jar "$APPLICATION_PATH" "--server.port=$APPLICATION_PORT" > "$OUTPUT_PATH" 2>&1 &
nohup java -jar "$APPLICATION_PATH" > "$OUTPUT_PATH" 2>&1 &

if [ "$?" -eq 0 ];
then
    echo "$APPLICATION_NAME started!"
    echo "Monitor application output with: less +F '$OUTPUT_PATH'"
    echo "$!" > "$PID_PATH" || echo "Save PID $! in '$PID_PATH' file operation error."
    exit 0
else
    echo "$APPLICATION_NAME start operation error!"
    exit 1
fi