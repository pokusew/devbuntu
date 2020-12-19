# see https://www.gungorbudak.com/blog/2018/06/13/memory-leak-testing-with-valgrind-on-macos-using-docker-containers/
# https://hub.docker.com/_/ubuntu/
FROM ubuntu:rolling

ENV TERM="xterm-256color"
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=0

# TODO: improve order of commands, incorporate best prcatices for apt

RUN apt-get update
RUN bash -c "yes | unminimize"

# copy bash config and scripts
WORKDIR /root
COPY src .

# install pacakges
RUN ./setup-apt-repos.sh
# -y = assume "yes" as answer to all prompts and run non-interactively
RUN apt-get install -y \
	hstr \
	curl wget git gcc g++ clang make valgrind zip iputils-ping \
	gcc-multilib-arm-linux-gnueabihf \
	binutils-mips-elf gcc-mips-elf \
	man-db \
	cmake
RUN bash -c "update-alternatives --set cc $(which clang)"
RUN bash -c "update-alternatives --set c++ $(which clang++)"

# install nvm
WORKDIR /root
RUN git clone https://github.com/creationix/nvm.git .nvm
WORKDIR /root/.nvm
RUN git checkout v0.37.2

# install node.js
WORKDIR /root
RUN bash -c "source nvm-init.sh && nvm install 14.* && nvm alias default 14.*"
RUN bash -c "source nvm-init.sh && npm i -g yarn"

WORKDIR /
