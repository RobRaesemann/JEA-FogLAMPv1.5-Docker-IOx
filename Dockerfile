FROM ubuntu
#
# FogLAMP 1.5.0 on IOx
# 

# Set Timezone information or install will ask and hang up docker build
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install packages required for FogLAMP
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \ 
    automake \
    avahi-daemon \
    build-essential \
    cmake \
    curl \
    g++ \
    git \
    libboost-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libz-dev \
    make \
    postgresql \
    python3-dev \
    python3-pip \
    python3-dbus \
    python3-setuptools \
    rsyslog \
    sqlite3 \
    uuid-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /foglamp
RUN mkdir -p /foglamp \
&& git config --global http.sslVerify false \
&& git config --global http.postBuffer 1048576000 \
&& git -c http.sslVerify=false clone https://github.com/foglamp/FogLAMP.git /foglamp \
&& git checkout v1.5.0 \
&& make \
&& make install

ENV FOGLAMP_ROOT=/usr/local/foglamp

RUN mkdir -p /usr/local/foglamp/python/foglamp/plugins/north/http_north
COPY http_north /usr/local/foglamp/python/foglamp/plugins/north/http_north

RUN mkdir -p /usr/local/foglamp/python/foglamp/plugins/south/b100
COPY b100_south /usr/local/foglamp/python/foglamp/plugins/south/b100

RUN mkdir -p /usr/local/foglamp/python/foglamp/plugins/south/random
COPY random_south /usr/local/foglamp/python/foglamp/plugins/south/random

WORKDIR /usr/local/foglamp
COPY foglamp.sh foglamp.sh

VOLUME /usr/local/foglamp/data

# FogLAMP API port
EXPOSE 8081

# start rsyslog, FogLAMP, and tail syslog
CMD ["bash", "usr/local/foglamp/foglamp.sh"]

LABEL maintainer="rob@raesemann.com" \
      author="Raesemann" \
      target="Raspberry PI" \
      version="1.5.0" \