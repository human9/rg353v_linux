#!/bin/bash

# What am I doing wrong here?
# Seemingly this bootloops repeatedly.

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

echo "Writing u-boot-rockchip.bin..."
dd if=u-boot/u-boot-rockchip.bin of=$DEVICE seek=64 status=progress

echo "Mounting boot partition"
mkdir tmp
sync
mount ${DEVICE}$BOOT tmp
echo "Running mkimage and copying kernel"
#mkimage -A arm64 -O linux -T kernel -C none -a 0x80008000 -e 0x80008000 -n "Linux kernel" -d linux-next/arch/arm64/boot/Image tmp/Image
# if I do the above, it bootloops... not sure if below is valid
cp linux-next/arch/arm64/boot/Image tmp/Image

echo "Creating extlinux.conf"
mkdir tmp/extlinux
echo "LABEL linux" >> tmp/extlinux/extlinux.conf
echo "  LINUX /Image" >> tmp/extlinux/extlinux.conf
echo "  FDT /boot/rockchip/rk3566-anbernic-rg353v.dtb" >> tmp/extlinux/extlinux.conf
UUID=$(blkid -o value -s UUID ${DEVICE}$ROOT)
echo "  APPEND earlyprintk root=UUID=$UUID console=tty0 rw rootwait rootfstype=ext4 init=/sbin/init" >> tmp/extlinux/extlinux.conf

echo "Copying devicetree files"
mkdir -p tmp/boot/rockchip
cp u-boot/arch/arm/dts/rk3566-anbernic-rgxx3.dtb tmp/boot/rockchip/
cp linux-next/arch/arm64/boot/dts/rockchip/rk3566-anbernic*.dtb tmp/boot/rockchip/

echo "Unmounting boot partition"
sync
umount tmp
rmdir tmp

echo "Done."

