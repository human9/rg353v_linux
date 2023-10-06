#!/bin/bash

# What am I doing wrong here?
# Guess I can try using buildroot.

DEVICE=$1

[ -z "$DEVICE" ] && echo "please specify device" && exit 1
sudo umount ${DEVICE}*

DEVP=""
if [[ "$DEVICE" == *"loop"* ]]; then
  echo "Loop device detected."
  DEVP="p"
fi

BOOT=2

ROOT=3

echo "Copying rootfs files"
mkdir devroot
sync
mount ${DEVICE}$DEVP$ROOT devroot
echo "Copying Arch rootfs"
ROOTFS=../archroot/rootfs/
echo "Copying kernel modules"
rsync -a linux/modules_build/ devroot/usr/
sync
umount devroot
sync
rmdir devroot

echo "Writing u-boot-rockchip.bin..."
dd if=u-boot/u-boot-rockchip.bin of=$DEVICE seek=64 status=progress

echo "Mounting boot partition"
mkdir tmp
sync
mount ${DEVICE}$DEVP$BOOT tmp
echo "Copying kernel"
cp linux/arch/arm64/boot/Image tmp/Image
zstd -c10 tmp/Image > tmp/Image.zst

# TODO: uboot set reset gpio?

echo "Creating extlinux.conf"
mkdir -p tmp/extlinux
echo "LABEL linux" > tmp/extlinux/extlinux.conf
echo "  LINUX /Image.zst" >> tmp/extlinux/extlinux.conf
echo "  FDTDIR /boot/" >> tmp/extlinux/extlinux.conf
UUID=$(blkid -o value -s PARTUUID ${DEVICE}$DEVP$ROOT)
echo "  APPEND console=uart8250,mmio32,0xfe660000 console=tty0 root=PARTUUID=$UUID rw rootwait rootfstype=ext4 init=/sbin/init video=DSI-1:640x480@60" >> tmp/extlinux/extlinux.conf

echo "Copying devicetree files"
mkdir -p tmp/boot/rockchip
cp u-boot/arch/arm/dts/rk3566-anbernic-rgxx3.dtb tmp/
cp linux/arch/arm64/boot/dts/rockchip/rk3566-anbernic*.dtb tmp/boot/rockchip/

echo "Unmounting boot partition"
sync
umount tmp
rmdir tmp

echo "Done."

