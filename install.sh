#!/bin/bash

WORK_DIR=/root

# configure `apt` to use bionic repository only for PowerAPI specific packages
cp bionic.list /etc/apt/sources.list.d/
cp powerapi.pref /etc/apt/preferences.d/

apt update
apt upgrade -y

# install linux kernel `4.18.0-25`
apt install -y linux-image-4.18.0-25-generic linux-modules-4.18.0-25-generic linux-modules-extra-4.18.0-25-generic
modprobe intel_rapl

# build and install `hwpc-sensor`
apt install -y libczmq4 libbson-1.0
dpkg -i deb/hwpc-sensor-1.0.deb

# install python3.8
wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tgz -O $WORK_DIR/Python-3.7.10.tgz
cd $WORK_DIR
tar -xvf Python-3.7.10.tgz
cd Python-3.7.10
./configure
make -j 40
make install

apt install python3-pip

python3.7 -m pip install --upgrade pip
python3.7 -m pip install --upgrade setuptools

# install powerAPI
apt install -y python3-numpy python3-setproctitle python3-zmq python3-pymongo python3-prometheus-client python3-influxdb
dpkg -i deb/python3-powerapi_0.9.2-1_all.deb

# install smartwatts
apt install -y python3-scipy python3-sklearn
dpkg -i python3-smartwatts_0.6.0-1_all.deb

# install tools
apt install cgroups-tools
