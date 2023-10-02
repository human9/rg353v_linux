# Booting linux from SD card on RG353V

Current status: Boots OK on 6.6-rc3

## Building

Obtain source code:

    ./clone_sources.sh

Build each subproject:

    ./make_uboot.sh
    ./make_linux.sh

Write to SD card:

    sudo ./write_sd.sh /dev/sdX


## Issues

- The WIFI/BT (RTL8821CS) works, but only after an rmmod rtw88_8821cs and modprobe rtw88_8821cs
- With latest config wifi is the only issue...

# Dependencies

rsync

