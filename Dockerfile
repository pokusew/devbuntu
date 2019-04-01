# see https://www.gungorbudak.com/blog/2018/06/13/memory-leak-testing-with-valgrind-on-macos-using-docker-containers/
# https://hub.docker.com/_/ubuntu/
FROM ubuntu:18.10

ENV TERM="xterm-256color"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=0

# TODO: incorporate best pratcies for using apt-get in Docker
# https://github.com/dvorka/hstr/blob/master/INSTALLATION.md#ubuntu
RUN apt-get update
RUN apt-get upgrade -y
# RUN apt-get install software-properties-common -y
# RUN add-apt-repository ppa:ultradvorka/ppa
# RUN apt-get update
# RUN apt-get install hstr -y
RUN apt-get install curl wget git gcc clang make valgrind zip iputils-ping -y
RUN bash -c "update-alternatives --set cc $(which clang)"

# install nvm
WORKDIR /root
RUN git clone https://github.com/creationix/nvm.git .nvm
WORKDIR /root/.nvm
RUN git checkout v0.34.0

# configure bash
WORKDIR /root
COPY src .
COPY src .
COPY src .
COPY src .

# install node.js
RUN bash -c "source nvm-init.sh && nvm install 10.* && nvm alias default 10.*"
RUN bash -c "source nvm-init.sh && npm i -g yarn"

WORKDIR /
