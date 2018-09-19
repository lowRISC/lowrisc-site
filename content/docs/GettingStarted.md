+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "GettingStarted"

+++

## Getting Started

    You will need:
    A Nexys4-ddr FPGA board from Digilent with combined power and USB cable (required)
    A micro-SD card (minimum 4GBytes capacity, required)
    A PC-compatible SD-card reader (required)
    A 100Base-T Ethernet cable to a home hub or corporate LAN (optional)
    A VGA compatible LCD monitor (optional)
    A PS/2 style PC-AT keyboard with USB connector (optional)
    A copy of Vivado 2018.1 webpack edition with SDK (optional)

If you don't have Vivado installed a USB memory stick will be required, in this case the keyboard option will be unavailable.

If you don't have the VGA monitor a terminal program should be used such as microcom. You will need to use the following command to allow microcom to run as the non-superuser:

    sudo usermod -a -G dialout $USER

The quickstart Makefile should be installed as follows:

    git clone https://github.com/lowRISC/lowrisc-quickstart.git
    cd lowrisc-quickstart
    
If you don't have git installed the following workaround may be used:

    wget https://github.com/lowRISC/lowrisc-quickstart/archive/master.zip
    unzip master
    cd lowrisc-quickstart-master

However the Makefile was obtained, proceed as follows to obtain the release files:

    make getrelease

Three files will be downloaded as follows:

    boot.bin - The Linux kernel, Berkeley boot loader, and initial cpio (ramdisk)
    chip_top.bit - The FPGA bitstream containing the RISCV processor and peripherals and the first-stage booter
    rootfs.tar.xz - The compressed tape archive containing the Debian root filing system for RISCV

## GNU license.

Warning, boot.bin and Debian contain copylefted software. Source for the Debian system is available upstream in

    http://www.debianmirror.de/debian-ports/pool-riscv64

Source for boot.bin is available on kernel.org and patches are automatically applied by typing:

    make all

Source for the first stage bootloader is available by typing:

    make lowrisc-fpga/STAMP.fpga

It is then available in the lowrisc-fpga/bare_metal directory

Type lsblk before and after inserting the SD-card and its adaptor into the computer. You should see new devices added, similar to the following:

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part /media/jrrk2/2BBB-DCFE
    ├─sdc2   8:34   1     2G  0 part /media/jrrk2/c7370d8e-67dd-405f-abe5-0a6d40fef98d
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part /media/jrrk2/578a1c8d-92c9-48cb-9fdc-c593d5c68107

### IMPORTANT:

If your USB disk shows up as something other than sdc, you need to run the following commands with the parameter

    USB=whatever, where whatever is whatever your removable disk is called

### IF YOU DO NOT UNDERSTAND THIS, DO NOT PROCEED, GET SOME HELP !!!

If you use a fresh card, only sdc1 will typically be present. If you use the recommended operating system Ubuntu 16.04.5 LTS, any known partitions will be mounted and automatically shown in windows. In this case do

    make umount USB=sdc

otherwise, continue with

    make USB=sdc cleandisk partition

You may get an error, Re-reading the partition table failed.: Device or resource busy, in this case remove the card reader and reinsert it. do another make umount if necessary, and run lsblk again, You should see:

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part 
    ├─sdc2   8:34   1     2G  0 part 
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part 

The new partition table defaults to: 32Mbytes for DOS partition, 2G for the root, 512M for swap, and the rest for /home. If you don't like these numbers they can be edited in the file cardmem.sh

The next few steps can all be executed in one go:

    make USB=sdc mkfs fatdisk extdisk

You will be asked to confirm if the card previously had readable data on it. The first step makes the new filing systems, the second step writes the kernel+BBL to the DOS partition, and the third step extracts the root filing system. Unmounting the disk at the end of this process can take a while due to buffering. Do not attempt to remove the card reader until the umount completes. This SD-card is ready to be inserted in the slot underneath the Digilent board near to the USB connector.

