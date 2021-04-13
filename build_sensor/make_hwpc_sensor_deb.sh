#!/bin/bash

VERSION=$(cat control | grep Version | cut -d ':' -f 2)
VERSION=`echo $VERSION | sed 's/ *$//g'`

# build sensor
git clone https://github.com/powerapi-ng/hwpc-sensor.git /tmp/hwpc-sensor

mkdir /tmp/hwpc-sensor/build
cd /tmp/hwpc-sensor/build
GIT_TAG=$(git describe --tags --dirty 2>/dev/null || echo "unknown")
GIT_REV=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
cmake -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" -DCMAKE_C_CLANG_TIDY="clang-tidy" -DWITH_MONGODB="${MONGODB_SUPPORT}" ..
make -j $(getconf _NPROCESSORS_ONLN)

cp /tmp/hwpc-sensor/build/hwpc-sensor /tmp/build_deb/hwpc-sensor

# create package skeleton
cd /tmp/build_deb
mkdir -p hwpc-sensor-$VERSION/DEBIAN
cp /srv/control hwpc-sensor-$VERSION/DEBIAN/

mkdir -p hwpc-sensor-$VERSION/usr/bin/
cp /tmp/hwpc-sensor/build/hwpc-sensor hwpc-sensor-$VERSION/usr/bin/hwpc-sensor-bin
cp /srv/launch_sensor.sh hwpc-sensor-$VERSION/usr/bin/hwpc-sensor

# build package
dpkg-deb --build hwpc-sensor-$VERSION

mv hwpc-sensor-$VERSION.deb /srv/
