FROM ubuntu:16.04

RUN apt-get update
RUN apt-get build-dep -y mysql-server
RUN apt-get install -y gdb pkg-config libjemalloc-dev libjemalloc1-dbg
RUN adduser --system --disabled-login --group mysql
