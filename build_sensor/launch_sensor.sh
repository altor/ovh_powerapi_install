#!/bin/bash

cgcreate -g perf_event:hwpc-sensor
echo $$ >/sys/fs/cgroup/perf_event/hwpc-sensor/cgroup.procs

ulimit -Sn 8192
/usr/bin/hwpc-sensor-bin $@

cgdelete perf_event:hwpc-sensor
