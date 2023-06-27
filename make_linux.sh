#!/bin/bash


#cp next.config linux-next/.config 
cd linux-next/
export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
make menuconfig ARCH=arm64
make -j8
make dtbs ARCH=arm64

