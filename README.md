# Booting linux from SD card on RG353V

Current status: Boots OK on 6.6-rc4

## Building

Obtain source code:

    ./clone_sources.sh

Build each subproject:

    ./make_uboot.sh
    ./make_linux.sh

Write to SD card:

    sudo ./write_sd.sh /dev/sdX


## Issues

- The WIFI/BT (RTL8821CS) works as of the current commit, but..
    - There may be some issues, specifically with changing power states? It seems very stable if I add rtw88_core.disable_lps_deep=1 to kernel parameters.
    - If there are issues as before rmmod rtw88_8821cs and modprobe rtw88_8821csshould fix it temporarily.
- Software poweroff/reset bug: This is actually due to incorrect firmware loading.
    - uboot on the internal eMMC is always loaded if present, so to boot from SD currently without bugs at time of writing you have to zero out the eMMC.
- Rumble is working with the current devmerge script, although I need to submit some questions / patches upstream about apparent bugs..

# TODO

- Provide build scripts for my rootfs. It's just an archlinux arm rootfs, but buildroot will also work.
- Cleanup.

# Dependencies

rsync

todo: what else?
