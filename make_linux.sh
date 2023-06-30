#!/bin/bash

cp linux_new.config linux/.config
cd linux/
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
make menuconfig
make -j8
make dtbs

