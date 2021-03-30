#!/bin/bash

VERSION=$(python3 -c "import os, smartwatts; print(smartwatts.__version__)")

# install build dependencies
apt update
apt install -y python3 python3-pip python3-stdeb dh-python
python3 -m pip install .

# remove testing
rm -R ./test

# create source package 
python3 setup.py --command-packages=stdeb.command sdist_dsc
sed -i 's/Depends: ${misc:Depends}, ${python3:Depends}/Depends: python3-powerapi, ${misc:Depends}, ${python3:Depends}/g' ./deb_dist/smartwatts-$VERSION/debian/control

# build binary package
cd ./deb_dist/smartwatts-$VERSION
dpkg-buildpackage
cd ../..


