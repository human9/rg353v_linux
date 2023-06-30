# Booting linux from SD card on RG353V

- I have a V1 panel
- It seems like u-boot starts
- But there's just a blank screen after a vibration
- Unsure of how to debug

## Building

Obtain source code:

    ./clone_sources.sh

Build each subproject:

    ./make_uboot.sh
    ./make_linux.sh
    ./make_buildroot.sh

Write to SD card:

    sudo ./write_sd.sh /dev/sdX

## Debug

Found the UART - it's at the top right of the front of the board. TODO: pictures, documentation.
U-Boot log uploaded, linux not printing anything yet.

I did actually manage to boot with the Anbernic and JELOS kernels - at least to the point of it printing messages.
So must be an issue with kernel.
