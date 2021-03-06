#!/bin/bash

#SCRIPT_DIR=/home/bbase
SCRIPT_DIR="$HOME"

$DEL_OPTION=${1:backup}

. "$SCRIPT_DIR/is-config.sh"

if [ -f "$PID_PATH" ];
then
    PROCESS_PID=`cat "$PID_PATH"`

    if [ -n "$PROCESS_PID" ];
    then
        if kill -9 "$PROCESS_PID" &> /dev/null;
        then
            echo "$PROCESS_PID stopped!"
            rm -f "$PID_PATH" &> /dev/null || echo "" > "$PID_PATH"
            if [ "$DEL_OPTION" = 'backup' ];
            then
           	 mv "$SCRIPT_DIR/$APPLICATION_NAME.jar" "$SCRIPT_DIR/$APPLICATION_NAME_backup_$(date +%F-%H:%M).jar"
            else
                 rm -rf "$SCRIPT_DIR/$APPLICATION_NAME.jar"
            fi
            exit 0
        else
            echo "$APPLICATION_NAME stop operation error!"
            echo "Check process with PID $PROCESS_PID or remove '$PID_PATH' file manually."
            exit 1
        fi
    fi
fi

if lsof -t "-i:$APPLICATION_PORT" -sTCP:LISTEN &> /dev/null;
then
    echo "Kill process operation failed!";
    echo "It is necessary to kill process that uses port $APPLICATION_PORT manually.";
    echo "Use following command to find PID: lsof -t -i:$APPLICATION_PORT";
    exit 1
fi
