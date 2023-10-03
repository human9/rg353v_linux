#!/bin/bash

cp linux_new.config linux/.config
cd linux/
export CFLAGS="-g0 -O2 march=armv8.2-a mtune=cortex-a55"
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
git checkout v6.6-rc4
git apply ../reverse_leftstick.patch
# get patchset
#mkdir -p patches
# this is needed for v2 displays
#b4 am -o patches 20230426143213.4178586-1-macroalpha82@gmail.com
# not actually needed, but this is the patch to add wifi support
#b4 am -o patches 20230405200729.632435-10-martin.blumenstingl@googlemail.com
#git am -i patches/*.mbx
# make
make menuconfig
make -j8
make Image.zst
mkdir -p linux/modules_build
make modules INSTALL_MOD_PATH=modules_build
make modules_install INSTALL_MOD_PATH=modules_build
make dtbs
