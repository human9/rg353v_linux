#!/bin/bash

set -x

# Obtain linux

git clone --branch v6.5-rc5 --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux

# Obtain u-boot

git clone  --branch v2023.10-rc2 --depth 1 https://source.denx.de/u-boot/u-boot.git u-boot

# Obtain buildroot

git clone --branch 2023.05 --depth 1 git://git.buildroot.net/buildroot buildroot

# Obtain rkbin

git clone --depth 1 https://github.com/rockchip-linux/rkbin rkbin
