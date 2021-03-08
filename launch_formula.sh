#!/bin/bash

cgcreate -g perf_event:formula
echo $$ >/sys/fs/cgroup/perf_event/formula/cgroup.procs

python3.8 -m smartwatts $@

cgdelete perf_event:formula
