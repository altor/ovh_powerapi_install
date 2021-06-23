#!/bin/bash

# clone repository
git clone https://github.com/powerapi-ng/powerapi.git /tmp/powerapi
cd /tmp/powerapi

# remove testing
rm -R ./tests
sed -i 's/setup_requires =//g' setup.cfg
sed -i 's/pytest-runner >=3.9.2//g' setup.cfg
sed -i 's/test = pytest//g' setup.cfg
sed -i 's/\[aliases\]//g' setup.cfg
sed -i 's/test_suite = tests//g' setup.cfg
sed -i 's/tests_require =//g' setup.cfg
sed -i 's/pytest >=3.9.2//g' setup.cfg
sed -i 's/pytest-asyncio >=0.14.0//g' setup.cfg
sed -i 's/mock >=2.0//g' setup.cfg
sed -i 's/requests >=2.0//g' setup.cfg

# remove type hint and change python required version to 3.7
sed -i 's/python_requires = >= 3\.[0-9]/python_requires = >= 3.6/g' setup.cfg
sed -i 's/ *-> *[[:alnum:]]*:/:/g' $(find powerapi/ -name "*.py")
sed -i 's/from __future__ import annotations//g' $(find powerapi/ -name "*.py")
sed -i 's/: *[[:alnum:]]* *=/=/g' $(find powerapi/ -name "*.py")

# install build dependencies
python3 -m pip install .
VERSION=$(python3 -c "import os, powerapi; print(powerapi.__version__)")

# create source package 
python3 setup.py --command-packages=stdeb.command sdist_dsc
sed -i '/Depends: ${misc:Depends}, ${python3:Depends}/a Suggests: python3-pymongo,python3-prometheus-client,python3-influxdb,python3-influxdb' ./deb_dist/powerapi-$VERSION/debian/control
# build binary package

cd ./deb_dist/powerapi-$VERSION
dpkg-buildpackage
mv ../python3-powerapi_$VERSION-1_all.deb /srv/

