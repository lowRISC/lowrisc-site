+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "Getting started with binaries"

+++

## License

The Xilinx license agreement permits the redistribution of bitstream under certain restrictions, the main one being that the sole use should be for programming the appropriate Xilinx device. See the FAQ below. It doesn't appear to make a distinction between WebPack and non-WebPack devices.

* [Frequently asked questions for this release]  ({{< ref "docs/frequently-asked-questions.md">}})

## Getting Started with the ariane-v0.7 prebuilt binaries

This guide will walk you through downloading the binaries of the latest lowRISC release and booting it
on a Nexys4DDR FPGA and/or a GenesysII.

*    You will require:
*    A Linux PC with sudo access with two readily accessible USB ports
*      (these instructions apply to Ubuntu 18.04.4 LTS)
*    A Nexys4DDR FPGA board from Digilent with combined power and USB cable or GenesysII with separate power, USB and UART cable.
*    A micro-SD card (minimum 16GBytes capacity). For example Samsung PRO Endurance 32GB, or Sandisk Ultra 16GB.
*    A PC-compatible SD-card reader

### Hardware requirements

LowRISC always operates autonomously from external control. However to cut down on the number of different boot options and kernels needed, it is assumed that an external PC or other serial terminal will be connected during booting. If the PS/2 keyboard is not used (because of serial console or Bluetooth keyboard option being chosen) FPGA configuration can come from a USB memory stick, so the large (up to 28GBytes) Vivado installation is not required. However for robustness and repeatability the Quad-SPI flash memory is recommended.

*   A USB memory stick if you don't want to use Vivado and Quad-SPI.
*   Install microcom or your favourite terminal emulator program (remote keyboard option only will be available)
*    You will need to use the following command to allow microcom to run as the non-superuser:
*    sudo usermod -a -G dialout $USER
*   A VGA compatible LCD monitor (optional)
*   A PS/2 style PC-AT keyboard with USB connector (optional)
*   A PMOD-BT Bluetooth PMOD (optional), together with a compatible Bluetooth mouse and/or keyboard.
*   A copy of Vivado 2018.2 webpack edition (with SDK if you plan to do development) to program the Quad-SPI

#### For both options a 100Base-T Ethernet cable to a home hub or corporate LAN is recommended (1000BaseT for GenesysII).

The quickstart Makefile should be installed as follows:

    git clone -b ariane-v0.7 https://github.com/lowRISC/lowrisc-quickstart.git
    cd lowrisc-quickstart
    make getrelease BOARD=nexys4_ddr CPU=rocket

board may be nexys4_ddr or genesys2, CPU may be rocket or ariane in any combination.

Three files will be downloaded as follows:

*   boot.bin - The Linux kernel and Berkeley boot loader
*   nexys4_ddr_rocket_xilinx.new.bit - The FPGA bitstream containing the RISCV processor and peripherals and the first-stage booter
*   rootfs.tar.zstd - The compressed tape archive containing the buildroot filing system for RISCV

### Programming the SD-Card

In theory the root filing system could be completely initialised on board the FPGA. In practice performance limitations make this impractical. Using the workstation we will format and initialise the card using BTRFS (a filing system with some tolerance of power fails and errors).

Type lsblk before and after inserting the SD-card and its adapter into the computer. You should see new devices added, similar to the following:

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

If you use a fresh card, only sdc1 will typically be present. If you use the recommended operating system Ubuntu 18.04.4 LTS, any known partitions may be mounted and automatically shown in file manager windows. Either way proceed with:

    make install USB=sdc

Unmounting the disk at the end of this process can take a while due to buffering. Do not attempt to remove the card reader until the umount completes. This SD-card is ready to be inserted in the slot underneath the Digilent board near to the USB connector. On Nexys4-DDR it inserts upside-down, on GenesysII is inserts label upwards.

## USB bitstream installation

The USB keyboard master function is optional and for this reason a USB memory stick may be substituted and used to contain the required bitstream. Vivado is not needed which is an advantage since it is a multi-gigabyte download. You can use the following command (all the same caveats about being very careful to choose the correct disk apply as above)

    make memstick USB=sdc

To use this method JP1 must be in the USB/SD position and JP2 should be in the USB position. Once configured, the USB stick is inaccessible to Linux and cannot be used to store other files. After pressing the PROG button with the USB memory stick inserted the BUSY light should glow amber steadily for 30 seconds or so, then the green DONE light will come on. In the event of failure, the amber BUSY light will flash slowly, in this case it is worth trying a different memory stick.

Configuration from SD-Card is not supported in this release (because the onboard PIC places the SD-Card in 1-bit SPI mode, and we need it in 4-bit SD mode). If a method is found to return to 4-bit SD-mode, then this mode can be supported in a future release.

## JTAG download

For JTAG download Vivado is required and the bitstream will be executed immediately. If using the Nexys4-DDR board it need only be plugged in and powered up, and the Digilent drivers should have been installed as per the manufacturer's recommendations. If you have the GenesysII board, life is more complicated because there are multiple ports on the USB converter. You should explicitly select a target using the Vivado GUI to ensure reliable operation.

    make program

If the SD-Card (preprogrammed as above) is already inserted, execution will begin immediately. If not, press the reset button after inserting the card.

## Switch settings

   In addition to setting JP1 and JP2, the DIP-SW 4 should be off, DIP-SW 3-0 should be used to set a unique MAC address.
   DIP-SW 7-5 should be set according to the boot mode. All zeros represents an SD-Boot.
   
## Root login

root login is disabled by default via Ethernet without a secret key. Root login on the console is permitted with the password 'LowRISC'.

