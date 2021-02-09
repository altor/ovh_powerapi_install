#!/bin/bash

WORK_DIR=/root

apt update
apt upgrade

# install linux-kernel
apt install -y linux-image-4.18.0-25-generic linux-modules-4.18.0-25-generic

# patched LibPFM build
apt install -y build-essential git devscripts debhelper dpatch python3-dev libncurses-dev swig
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
git clone -b msr-pmu-old https://github.com/gfieni/libpfm4.git $WORK_DIR/libpfm4
cd $WORK_DIR/libpfm4
fakeroot debian/rules binary
dpkg -i ../libpfm4_10.1_amd64.deb
dpkg -i ../libpfm4-dev_10.1_amd64.deb

# sensor build
git clone https://github.com/powerapi-ng/hwpc-sensor.git $WORK_DIR/hwpc-sensor
apt install -y clang-tidy cmake pkg-config libczmq4 libczmq-dev libsystemd-dev uuid-dev libmongoc-1.0-0
cd $WORK_DIR/hwpc-sensor
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE="${Release}" -DWITH_MONGODB="${ON}" ..
make -j $(getconf _NPROCESSORS_ONLN)

