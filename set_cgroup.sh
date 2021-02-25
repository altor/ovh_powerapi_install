#!/bin/bash

smartwats_main_pid=$(ps ax | grep smartwatts | grep -v grep | cut -d ' ' -f 1)
child_pid=$(pgrep -P $smartwats_main_pid)
formula_pid=""

for pid in $child_pid
do
    formula_pid="$formula_pid $(pgrep -P $pid)"
done

smartwatts_actors="$smartwats_main_pid $child_pid $formula_pid"

sensor_actors=$(pidof hwpc-sensor) $(pgrep -P $(pidof hwpc-sensor))
daemon=$(pidof sshd named irqbalance mdadm polkitd atd systemd-logind cron rsyslogd dbus-daemon systemd-timesyncd systemd-udevd lvmetad systemd-journald)

cgdelete perf_event:sensor
cgdelete perf_event:formula
cgdelete perf_event:daemon

cgcreate -g perf_event:sensor
cgcreate -g perf_event:formula
cgcreate -g perf_event:daemon

cgclassify -g perf_event:sensor $sensor_actors
cgclassify -g perf_event:formula $smartwatts_actors
cgclassify -g perf_event:daemon $daemon
