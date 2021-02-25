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

# build and install a patched version of `libpfm`
apt install -y build-essential git devscripts debhelper dpatch python3-dev libncurses-dev swig
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
git clone -b msr-pmu-old https://github.com/gfieni/libpfm4.git $WORK_DIR/libpfm4
cd $WORK_DIR/libpfm4
fakeroot debian/rules binary
dpkg -i ../libpfm4_10.1_amd64.deb
dpkg -i ../libpfm4-dev_10.1_amd64.deb

# build and install `hwpc-sensor`
git clone https://github.com/powerapi-ng/hwpc-sensor.git $WORK_DIR/hwpc-sensor
apt install -y clang-tidy cmake pkg-config libczmq4 libczmq-dev libsystemd-dev uuid-dev libbson-1.0 libbson-dev
cd $WORK_DIR/hwpc-sensor
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE="${Release}" -DWITH_MONGODB="OFF" ..
make -j $(getconf _NPROCESSORS_ONLN)
mv hwpc-sensor /usr/bin/

# install python3.8
wget https://www.python.org/ftp/python/3.8.7/Python-3.8.7.tgz -O $WORK_DIR/Python-3.8.7.tgz
cd $WORK_DIR
tar -xvf Python-3.8.7.tgz
cd Python-3.8.7
./configure
make -j 40
make install

apt install python3-pip

python3.8 -m pip install --upgrade pip
python3.8 -m pip install --upgrade setuptools

# install smartwatts
apt install -y libblas-dev liblapack-dev libatlas-base-dev gfortran
git clone https://github.com/powerapi-ng/powerapi $WORK_DIR/powerapi
python3.8 -m pip install $WORK_DIR/powerapi

git clone https://github.com/powerapi-ng/smartwatts-formula $WORK_DIR/smartwatts-formula
python3.8 -m pip install $WORK_DIR/smartwatts-formula

# install tools
apt install cgroups-tools
