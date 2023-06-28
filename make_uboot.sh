#!/bin/bash

cd u-boot
export CROSS_COMPILE=aarch64-linux-gnu-
export BL31=../rkbin/bin/rk35/rk3568_bl31_v1.42.elf
export ROCKCHIP_TPL=../rkbin/bin/rk35/rk3566_ddr_1056MHz_v1.16.bin
export ARCH=arm64 # is this needed?
# get patchset
mkdir -p patches
b4 am -o patches 20230515160032.126742-1-macroalpha82@gmail.com
git am -i patches/*.mbx
make anbernic-rgxx3_defconfig
#make menuconfig
make -j8
