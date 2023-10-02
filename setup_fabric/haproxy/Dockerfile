FROM haproxytech/haproxy-ubuntu:2.9
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
RUN apt-get -y update
RUN apt-get -y install vim iproute2
