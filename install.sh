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

# build packages
docker build . --tag=package_builder:latest

docker run -v $(pwd)/build_sensor:/srv --rm --name builder package_builder:latest /srv/make_hwpc_sensor_deb.sh
docker run -v $(pwd):/srv --rm --name builder package_builder:latest /srv/make_powerapi_deb.sh
docker run -v $(pwd):/srv --rm --name builder package_builder:latest /srv/make_smartwatts_deb.sh

mv ./*.deb $WORK_DIR/
mv build_sensor/*.deb $WORK_DIR/

# install dependencies

## sensor dependencies
apt install -y libczmq4 libbson-1.0

## python3.7 & utils
apt install -y zlib1g-dev
wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tgz -O $WORK_DIR/Python-3.7.10.tgz
cd $WORK_DIR
tar -xvf Python-3.7.10.tgz
cd Python-3.7.10
./configure
make -j 40
make install

## powerapi dependencies
apt install -y python3-numpy python3-setproctitle python3-zmq python3-pymongo python3-prometheus-client python3-influxdb

## smartwatts dependencies
apt install -y python3-scipy python3-sklearn

# install package
for package in $(ls $WORK_DIR/*.deb)
do
    dpkg -i $package
done

# install tools
apt install cgroup-tools
