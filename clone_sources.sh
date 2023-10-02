#!/bin/bash

set -x

# Obtain linux

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux

# Obtain u-boot

git clone https://source.denx.de/u-boot/u-boot.git u-boot

# Obtain rkbin

git clone https://github.com/rockchip-linux/rkbin rkbin
