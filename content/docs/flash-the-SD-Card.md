+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "Flash the SD-Card"

+++

Type lsblk before and after inserting the SD-card and its adaptor into the computer. You should see new devices added, similar to the following:

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part /media/jrrk2/2BBB-DCFE
    ├─sdc2   8:34   1     2G  0 part /media/jrrk2/c7370d8e-67dd-405f-abe5-0a6d40fef98d
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part /media/jrrk2/578a1c8d-92c9-48cb-9fdc-c593d5c68107

## READ THIS WARNING (!)

The procedure below erases all data on the disk, so do not mistakenly specify your hard drive or external mass storage. Some checks will be carried out, such as skipping UUIDs found in /etc/fstab.
If your USB disk shows up as something other than sdc, you need to run the following commands with the parameter

    USB=whatever, where whatever is whatever your removable disk is called

#### IF YOU DO NOT UNDERSTAND THIS, DO NOT PROCEED, GET SOME HELP !!!

If you use a fresh card, only sdc1 will typically be present. If you use the recommended operating system Ubuntu 16.04.5 LTS, any known partitions will be mounted and automatically shown in windows. In this case do

    make sdcard-install USB=sdc

## Remote console bitstream installation

For remote installation the USB master function is not needed and may be used to contain the required bitstream. Vivado is not needed which is an advantage since it is a multi-gigabyte download. You can use the following command (all the same caveats about being very careful to choose the correct disk apply as above)

    make memstick USB=sdc

To use this method JP1 must be in the USB/SD position and JP2 should be in the USB position. Once configured, the USB stick is inaccessible to Linux and cannot be used to store other files. After pressing the PROG button with the USB memory stick inserted the BUSY light should glow amber steadily for 30 seconds or so, then the green DONE light will come on. In the event of failure, the amber BUSY light will flash slowly, in this case it is worth trying a different memory stick.

Configuration from SD-Card is not supported in this release (because the onboard PIC places the SD-Card in 1-bit SPI mode, and we need it in 4-bit SD mode). If a method is found to return to 4-bit SD-mode, then this mode can be supported in a future release.

Continue the process below:

* [Program the FPGA] ({{< ref "docs/program-the-FPGA.md">}})
