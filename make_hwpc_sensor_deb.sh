#!/bin/bash

VERSION=$(cat control | grep Version | cut -d ':' -f 2)
VERSION=`echo $VERSION | sed 's/ *$//g'`

# install build dependencies
apt update
apt install -y python3 python3-pip python3-stdeb dh-python
python3 -m pip install .

# create package skeleton
mkdir -p hwpc-sensor-$VERSION/DEBIAN
cp control hwpc-sensor-$VERSION/DEBIAN/

mkdir -p hwpc-sensor-$VERSION/usr/bin/
cp build/hwpc-sensor hwpc-sensor-$VERSION/usr/bin/hwpc-sensor-bin
cp launch_sensor.sh hwpc-sensor-$VERSION/usr/bin/hwpc-sensor

# build package
dpkg-deb --build hwpc-sensor-$VERSION
