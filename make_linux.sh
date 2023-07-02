#!/bin/bash

cp linux_new.config linux/.config
cd linux/
#export CFLAGS="-g0 -O2 march=armv8.2-a mtune=cortex-a55"
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
make menuconfig
make -j8
make Image.gz
mkdir -p linux/modules_build
make modules INSTALL_MOD_PATH=modules_build
make modules_install INSTALL_MOD_PATH=modules_build
make dtbs
