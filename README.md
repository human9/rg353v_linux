# Booting linux from SD card on RG353V

It works!

## Building

Obtain source code:

    ./clone_sources.sh

Build each subproject:

    ./make_uboot.sh
    ./make_linux.sh
    ./make_buildroot.sh

Write to SD card:

    sudo ./write_sd.sh /dev/sdX


## Issues

- The WIFI/BT (RTL8821CS) works, but only after an rmmod rtw88_8821cs and modprobe rtw88_8821cs
- Software shutdown doesn't seem to work - sometimes. Have to hold down power to power off fully. Due to unbalanced regulator disables? https://lore.kernel.org/all/646e391f.810a0220.214ce.d680@mx.google.com/
- Maybe it's a hardware fault on my own thing? e.g. https://github.com/raspberrypi/linux/issues/2830 / https://github.com/espressif/esp-hosted/issues/93
- Keen to test with 6.5 rc1 - might buff out by then.
