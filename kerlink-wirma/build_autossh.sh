#!/bin/bash

# install ARM GNU toolchain
sudo apt install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi

#VERSION=1.4e
VERSION=1.4f
wget http://www.harding.motd.ca/autossh/autossh-${VERSION}.tgz
wget http://www.harding.motd.ca/autossh/autossh-${VERSION}.cksums
sha256sum -c autossh-${VERSION}.cksums

tar xf autossh-${VERSION}.tgz

cd autossh-${VERSION}

export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes
./configure --host=arm-linux-gnueabi -prefix=/linux_arm_tool
make
file autossh
