FROM haproxytech/haproxy-ubuntu:2.9
COPY haproxy.cfg /usr/local/etc/haproxy/
COPY dataplaneapi.yml /usr/local/etc/haproxy/
RUN \
    apt-get -y update &&  \
    apt-get -y install --no-install-recommends vim iproute2
