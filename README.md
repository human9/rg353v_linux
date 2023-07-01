# Booting linux from SD card on RG353V

## Debug log

- Output on UART console works
- U-Boot starts okay as long as I specify the FDT file 
  - (autoselect works but FDTDIR results in error?) (see fdtdir_issue.log)
- Linux boots fine but screen refuses to turn on (see serial_output.log)

### Stuff from dmesg that might be important

```
[    1.497534] vcc_sys: could not add device link regulator.18: -ENOENT
[    1.697557] vcc_3v3: could not add device link regulator.19: -ENOENT
````

```
[    1.710873] dwhdmi-rockchip fe0a0000.hdmi: Looking up avdd-0v9-supply from device tree
[    1.710903] dwhdmi-rockchip fe0a0000.hdmi: Looking up avdd-0v9-supply property in node /hdmi@fe0a0000 failed
[    1.710957] dwhdmi-rockchip fe0a0000.hdmi: supply avdd-0v9 not found, using dummy regulator
[    1.711942] dwhdmi-rockchip fe0a0000.hdmi: Looking up avdd-1v8-supply from device tree
[    1.711973] dwhdmi-rockchip fe0a0000.hdmi: Looking up avdd-1v8-supply property in node /hdmi@fe0a0000 failed
[    1.712020] dwhdmi-rockchip fe0a0000.hdmi: supply avdd-1v8 not found, using dummy regulator
```

(see also dmesg_output.log)

## Building

Obtain source code:

    ./clone_sources.sh

Build each subproject:

    ./make_uboot.sh
    ./make_linux.sh
    ./make_buildroot.sh

Write to SD card:

    sudo ./write_sd.sh /dev/sdX

