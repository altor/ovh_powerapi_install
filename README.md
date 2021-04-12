# Install PowerAPI on ubuntu 16.04

the `install.sh` script :

- configure `apt` to use bionic repository only for PowerAPI specific packages
- install linux kernel `4.18.0-25`
- install `python3.8`
- build and install `hwpc-sensor`, `powerapi` and `smartwatts` package

# launch smartwatts

```
python -m smartwatts -v -s \
    --input socket --model HWPCReport -p 8080 \
    --output influxdb --uri powerapi.lille.inria.fr --port 27017 --db ovh_power_consumption --name influx_output \
    --output prom --name power --addr ns3173903.ip-51-210-114.eu --port 9000 --metric_name powerapi_energy --metric_description toto --model PowerReport --aggregation_period 5 \
    --formula smartwatts --cpu-ratio-base $BASE_CPU_RATIO --cpu-ratio-min $MIN_CPU_RATIO --cpu-ratio-max $MAX_CPU_RATIO --cpu-error-threshold 2.0 --dram-error-threshold 2.0 --sensor-reports-frequency 500
```

# launch sensor

```
hwpc-sensor -n test_sensor_socket \
    -r "socket" -U "127.0.0.1" -P 8080 \
    -s "rapl" -o -e RAPL_ENERGY_PKG -e "RAPL_ENERGY_DRAM" \
    -s "msr" -e "TSC" -e "APERF" -e "MPERF" \
    -c "core" -e "CPU_CLK_THREAD_UNHALTED:REF_P" -e "CPU_CLK_THREAD_UNHALTED:THREAD_P" \
              -e "LLC_MISSES" -e "INSTRUCTIONS_RETIRED"
```
