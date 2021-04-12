FROM debian:buster

WORKDIR /srv

COPY . /tmp/build_deb

ARG BUILD_TYPE=Debug
ARG MONGODB_SUPPORT=OFF

RUN apt update && \
    apt install -y build-essential git devscripts debhelper dpatch python3-dev libncurses-dev swig

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN git clone -b msr-pmu-old https://github.com/gfieni/libpfm4.git /tmp/libpfm4

RUN cd /tmp/libpfm4 && \
    fakeroot debian/rules binary

RUN dpkg -i /tmp/libpfm4_10.1_amd64.deb && \
    dpkg -i /tmp/libpfm4-dev_10.1_amd64.deb && \
    rm /tmp/*.deb

RUN apt update && \
    apt install -y cmake build-essential git clang-tidy cmake pkg-config libbson-dev libczmq-dev libsystemd-dev uuid-dev && \
	echo "${MONGODB_SUPPORT}" |grep -iq "on" && apt install -y libmongoc-dev || true

RUN apt install -y  python3 python3-pip python3-stdeb dh-python
