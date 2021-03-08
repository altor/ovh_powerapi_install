#!/bin/bash

daemon=$(pidof sshd named irqbalance mdadm polkitd atd systemd-logind cron rsyslogd dbus-daemon systemd-timesyncd systemd-udevd lvmetad systemd-journald)
cgdelete perf_event:daemon

cgcreate -g perf_event:daemon

cgclassify -g perf_event:daemon $daemon
