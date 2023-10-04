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
    - At commit 216f0e622cd25, it works, for a short while.
- Software poweroff/reset bug: if system is on for longer than 60secs it will hang on boot. Very consistent.
- Left joystick seems inverted
- I did have rumble working but now it doesn't. Check older commits.

# Dependencies

rsync

