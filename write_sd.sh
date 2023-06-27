#!/bin/bash

# What am I doing wrong here?

DEVICE=$1

[ -z "$DEVICE" ] && echo "please specify device" && exit 1
sudo umount ${DEVICE}*

echo "Zeroing device"
dd if=/dev/zero of=$DEVICE bs=1M count=256

echo "Making GPT label"
parted -s $DEVICE mklabel gpt

echo "Creating rockchip bootloader partitions"
parted -s $DEVICE unit s mkpart uboot 16384 24575
parted -s $DEVICE unit s mkpart resource 24576 32767

echo "Creating boot partition"
parted -s $DEVICE -a min unit s mkpart boot fat32 32768 262143
BOOT=3
parted -s $DEVICE set $BOOT boot on
mkfs.fat ${DEVICE}$BOOT

echo "Creating rootfs"
parted -s $DEVICE -a min unit s mkpart rootfs ext4 262144 100%
ROOT=4
mkfs.ext4 ${DEVICE}$ROOT

echo "Writing u-boot-rockchip.bin..."
dd if=u-boot/u-boot-rockchip.bin of=$DEVICE seek=64 status=progress

#echo "Creating idbloader"
#./u-boot/tools/mkimage -n rk3568 -T rksd -d rkbin/bin/rk35/rk3566_ddr_1056MHz_v1.16.bin idbloader.img
#cat rkbin/bin/rk35/rk356x_spl_v1.12.bin >> idbloader.img
#echo "Writing idbloader"
#dd if=idbloader.img of=$DEVICE seek=64 status=progress
#echo "Writing u-boot.itb"
#dd if=u-boot/u-boot.itb of=$DEVICE seek=16384

echo "Copying kernel image"
sync
UUID=$(blkid -o value -s UUID ${DEVICE}$ROOT)
mkdir tmp
mount ${DEVICE}$BOOT tmp
cp linux-next/arch/arm64/boot/Image tmp/ # Copy kernel image
echo "Creating extlinux.conf"
mkdir tmp/extlinux # Make extlinux config
echo "label nextOS" >> tmp/extlinux/extlinux.conf
echo "  kernel /Image" >> tmp/extlinux/extlinux.conf
echo "  DTB /boot/rockchip/rk3566-anbernic-rgxx3.dtb" >> tmp/extlinux/extlinux.conf
echo "  append earlyprintk root=UUID=$UUID console=tty0 rw rootwait rootfstype=ext4 init=/sbin/init" >> tmp/extlinux/extlinux.conf
echo "Copying devicetree files"
mkdir -p tmp/boot/rockchip # Copy devicetrees
cp u-boot/arch/arm/dts/rk3566-anbernic-rgxx3.dtb tmp/boot/rockchip/
cp u-boot/arch/arm/dts/rk3566-anbernic-rgxx3.dtb tmp/
cp linux-next/arch/arm64/boot/dts/rockchip/rk3566-anbernic* tmp/boot/rockchip/
umount tmp
rmdir tmp

sync
echo "Done."

