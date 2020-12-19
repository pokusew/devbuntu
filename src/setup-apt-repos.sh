#!/usr/bin/env bash

set -e # exit immediately if any command exits with a non-zero code

# hstr repo
# see https://github.com/dvorka/hstr/blob/master/INSTALLATION.md#ubuntu
# -y = assume "yes" as answer to all prompts and run non-interactively
apt-get install software-properties-common wget -y
add-apt-repository ppa:ultradvorka/ppa

# CVUT rtime repo for gcc MIPS cross-build toolchain
# mips-elf-* commands (apt-get install binutils-mips-elf gcc-mips-elf)
# TODO: use rather custom build
# 1. add key
# see https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key
wget -qO - https://rtime.felk.cvut.cz/debian/archive-key.asc > /tmp/rtime-archive.key
rtime_archive_key_type=$(file /tmp/rtime-archive.key)
if [[ $rtime_archive_key_type != "/tmp/rtime-archive.key: PGP public key block Public-Key (old)" ]]; then
	echo "invalid type of rtime-archive.key"
	exit 1
fi
gpg --no-default-keyring --keyring /tmp/rtime-keyring.gpg --import /tmp/rtime-archive.key
gpg --no-default-keyring --keyring /tmp/rtime-keyring.gpg --export > /tmp/rtime-archive-key.gpg
mv /tmp/rtime-archive-key.gpg /etc/apt/trusted.gpg.d/
rm /tmp/rtime-keyring.gpg /tmp/rtime-archive.key
# 2. add repo
echo "Adding ftp://rtime.felk.cvut.cz/debian ..."
echo "Dir::Bin::Methods::ftp \"ftp\";" > /etc/apt/apt.conf.d/rtime-ftp
echo "deb [trusted=yes] ftp://rtime.felk.cvut.cz/debian unstable main" > /etc/apt/sources.list.d/rtime-debs.list

apt-get update
