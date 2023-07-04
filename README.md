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

- The WIFI/BT (RTL8821CS) doesn't seem to be working - firmware fails to load.
- Seems like a bug? https://www.kernel.org/doc/html/v4.15/admin-guide/reporting-bugs.html
- Software shutdown doesn't seem to work sometimes

