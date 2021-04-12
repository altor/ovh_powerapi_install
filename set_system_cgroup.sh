#!/bin/bash

PID=""
SYSTEM_DIR="/sys/fs/cgroup/systemd/system.slice"
for file in $(ls $SYSTEM_DIR)
do
    if [[ -d $SYSTEM_DIR/$file ]]
    then
	PID="$PID $(cat $SYSTEM_DIR/$file/tasks)"
    fi
done

cgdelete perf_event:system_daemon
cgcreate -g perf_event:system_daemon
cgclassify -g perf_event:system_daemon $PID
