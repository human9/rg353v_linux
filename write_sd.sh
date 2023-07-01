#!/bin/bash

# What am I doing wrong here?
# Guess I can try using buildroot.

DEVICE=$1

[ -z "$DEVICE" ] && echo "please specify device" && exit 1
sudo umount ${DEVICE}*

echo "Zeroing device"
dd if=/dev/zero of=$DEVICE bs=1M count=32

echo "Making GPT label"
parted -s $DEVICE mklabel gpt

echo "Creating rockchip bootloader partitions"
# Only this one seems to be required
parted -s $DEVICE unit s mkpart uboot 16384 24575

echo "Creating boot partition"
parted -s $DEVICE -a min unit s mkpart boot fat32 32768 262143
BOOT=2
parted -s $DEVICE set $BOOT boot on
mkfs.fat ${DEVICE}$BOOT

echo "Creating rootfs"
parted -s $DEVICE -a min unit s mkpart rootfs ext4 262144 100%
ROOT=3
mkfs.ext4 ${DEVICE}$ROOT

echo "Copying rootfs files"
mkdir broot
mkdir devroot
sync
mount buildroot/output/images/rootfs.ext2 broot
mount ${DEVICE}$ROOT devroot
rsync -a broot/ devroot/
sync
umount devroot
umount broot
rmdir devroot
rmdir broot

echo "Writing u-boot-rockchip.bin..."
dd if=u-boot/u-boot-rockchip.bin of=$DEVICE seek=64 status=progress

echo "Mounting boot partition"
mkdir tmp
sync
mount ${DEVICE}$BOOT tmp
echo "Copying kernel"
cp linux/arch/arm64/boot/Image tmp/Image

echo "Creating extlinux.conf"
mkdir tmp/extlinux
echo "LABEL linux" >> tmp/extlinux/extlinux.conf
echo "  LINUX /Image" >> tmp/extlinux/extlinux.conf
echo "  FDTDIR /boot/" >> tmp/extlinux/extlinux.conf
UUID=$(blkid -o value -s PARTUUID ${DEVICE}$ROOT)
echo "  APPEND earlycon=uart8250,mmio32,0xfe660000 console=tty0 console=uart8250,mmio32,0xfe660000 root=PARTUUID=$UUID rw rootwait rootfstype=ext4 init=/sbin/init video=DSI-1:640x480@60" >> tmp/extlinux/extlinux.conf

echo "Copying devicetree files"
mkdir -p tmp/boot/rockchip
cp u-boot/arch/arm/dts/rk3566-anbernic-rgxx3.dtb tmp/
cp linux/arch/arm64/boot/dts/rockchip/rk3566-anbernic*.dtb tmp/boot/rockchip/

echo "Unmounting boot partition"
sync
umount tmp
rmdir tmp

echo "Done."

