#!/usr/bin/env bash

set -e # exit immediatelly if any command exits with a non-zero code

# hstr repo
# see https://github.com/dvorka/hstr/blob/master/INSTALLATION.md#ubuntu
# -y = assume "yes" as answer to all prompts and run non-interactively
apt-get install software-properties-common -y
add-apt-repository ppa:ultradvorka/ppa

# CVUT rtime repo for gcc MIPS cross-build toolchain
# mips-elf-* commands (apt-get install binutils-mips-elf gcc-mips-elf)
# TODO: use rather custom build
echo "Adding ftp://rtime.felk.cvut.cz/debian ..."
echo "Dir::Bin::Methods::ftp \"ftp\";" > /etc/apt/apt.conf.d/rtime-ftp
echo "deb [trusted=yes] ftp://rtime.felk.cvut.cz/debian unstable main" > /etc/apt/sources.list.d/rtime-debs.list

apt-get update
