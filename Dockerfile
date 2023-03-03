# https://hub.docker.com/_/ubuntu/
FROM ubuntu:22.04

ENV TERM="xterm-256color"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=0

# TODO: improve order of commands, incorporate best prcatices for apt

RUN apt-get update
RUN bash -c "yes | unminimize"

RUN apt-get install -y \
	curl wget git gcc g++ clang make valgrind zip iputils-ping \
	man-db \
	cmake \
    openssh-server

RUN useradd --create-home --shell /bin/bash nvidia
USER nvidia
WORKDIR /home/nvidia
