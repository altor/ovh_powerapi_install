#!/bin/bash

cgcreate -g perf_event:hwpc-sensor
echo $$ >/sys/fs/cgroup/perf_event/hwpc-sensor/cgroup.procs

/usr/bin/hwpc-sensor $@

cgdelete perf_event:hwpc-sensor
