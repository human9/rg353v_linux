#!/bin/bash

cp linux_new.config linux/.config
cd linux/
export CFLAGS="-g0 -O2 march=armv8.2-a mtune=cortex-a55"
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
# get patchset
mkdir -p patches
b4 am -o patches 20230426143213.4178586-1-macroalpha82@gmail.com
git am -i patches/*.mbx
# make
make menuconfig
make -j8
make Image.gz
mkdir -p linux/modules_build
make modules INSTALL_MOD_PATH=modules_build
make modules_install INSTALL_MOD_PATH=modules_build
make dtbs
