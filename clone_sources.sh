#!/bin/bash

set -x

# Obtain linux-next

git clone --branch next-20230626 --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

# Obtain u-boot

git clone --branch v2023.07-rc5 --depth 1 git@source.denx.de:u-boot/u-boot.git

# Obtain buildroot

git clone --branch 2023.05 --depth 1 git://git.buildroot.net/buildroot

# Obtain rkbin

git clone --depth 1 https://github.com/rockchip-linux/rkbin
