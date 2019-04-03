#!/usr/bin/env bash

# see https://cw.fel.cvut.cz/wiki/courses/b35apo/documentation/mips-elf-gnu/start
# see [trusted=yes] https://askubuntu.com/questions/732985/force-update-from-unsigned-repository-ubuntu-16-04
echo "deb [trusted=yes] ftp://rtime.felk.cvut.cz/debian unstable main" > /etc/apt/sources.list.d/rtime-debs.list
apt-get update
apt-get install binutils-mips-elf gcc-mips-elf -y
