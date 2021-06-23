#!/bin/bash

# clone repository
git clone https://github.com/powerapi-ng/smartwatts-formula.git /tmp/smartwatts
cd /tmp/smartwatts

VERSION=$(python3 -c "import os, smartwatts; print(smartwatts.__version__)")

# install build dependencies
python3 -m pip install .

# remove testing
rm -R ./test

# remove type hint and change python required version to 3.7
sed -i 's/python_requires = >= 3\.[0-9]/python_requires = >= 3.6/g' setup.cfg
sed -i 's/ *-> *[[:alnum:]]*:/:/g' $(find smartwatts/ -name "*.py")
sed -i 's/from __future__ import annotations//g' $(find smartwatts/ -name "*.py")
sed -i 's/: *[[:alnum:]]* *=/=/g' $(find smartwatts/ -name "*.py")


# create source package 
python3 setup.py --command-packages=stdeb.command sdist_dsc
sed -i 's/Depends: ${misc:Depends}, ${python3:Depends}/Depends: python3-powerapi, ${misc:Depends}, ${python3:Depends}/g' ./deb_dist/smartwatts-$VERSION/debian/control

# build binary package
cd ./deb_dist/smartwatts-$VERSION
dpkg-buildpackage
mv ../python3-smartwatts_$VERSION-1_all.deb /srv/


