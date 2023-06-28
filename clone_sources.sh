#!/bin/bash

set -x

# Obtain linux

git clone --branch v6.5-rockchip-dts64-1 --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git linux

# Obtain u-boot

git clone --branch v2023.07-rc4 --depth 1 https://source.denx.de/u-boot/u-boot.git u-boot

# Obtain buildroot

git clone --branch 2023.05 --depth 1 git://git.buildroot.net/buildroot buildroot

# Obtain rkbin

git clone --depth 1 https://github.com/rockchip-linux/rkbin rkbin
