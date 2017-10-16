+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Running the pre-built images on the FPGA"
parent = "/docs/ethernet-v0.5/"
prev = "/docs/ethernet-v0.5/walkthrough/"
showdisqus = true

+++

In this final step, we want to test the debug functionality on an FPGA board.
The debug system will use the UART connection at 12 MBaud to communicate with 
the debug system.

## Run the pre-built FPGA demo

The files you may need:

 * [chip_top.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/chip_top.bit):
   The tagpipe/minion/debug enabled FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/boot.bin):
   Linux, Busybox and Berkley bootloader (BBL) packaged in one image.

Download and write the bitstream

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/chip_top.bit > nexys4ddr_fpga.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/boot.bin > boot.bin

Optional: It is helpful to check the integrity of the kernel before we load it

    md5sum boot.bin > boot.md5
    
Convert the bitstream to quad-spi memory format

    vivado -mode batch -source $TOP/fpga/common/script/cfgmem.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga.bit

Burn the quad-spi memory (Ensure the MODE switch is set to QSPI)

    vivado -mode batch -source $TOP/fpga/common/script/program_cfgmem.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga.bit.mcs

There are three ways to boot a RISC-V Linux. For the first two cases, we need to open the debug daemon to load programs and connect to the UART console. First check the available serial ports:

    ls -l /dev/*USB*

which should result in a response similar to:

    crw-rw---- 1 root dialout 188, 1 Apr 14 16:32 /dev/ttyUSB1

In this case the device is user and group only access, so you need to be a member of the group dialout to use it.

    opensocdebugd uart device=/dev/ttyUSB1 speed=12000000 &

#### Directly load Linux to DDR RAM

The pre-built FPGA bitstream has a selftest program as the 1st stage bootloader 
(in an on-chip BRAM) which just jumps to DDR RAM if switch(0) is high (on the right). We need to load the Linux 
image to the DDR RAM.

    osd-cli
    osd> reset -halt
    osd> terminal 2
    osd> mem loadelf boot.bin 3
    osd> start

The terminal should again boot Linux. To update the image simply
perform the same action again. If you have a VGA display connected, you will see all output in both places (apart from Berkley boot loader messages).

#### Load Linux from SD card

 Other than manually loading a Linux to the DDR RAM using the debugger, we can use the selftest program to load Linux from SD, if switch(1) is high (second from right).
 
 Note: make sure the Linux image `boot.bin` and `boot.md5` is copied to SD beforehand. With most systems this may be done with the file manager or similar GUI program.

    osd-cli
    osd> terminal 2
    osd> reset

You should be able to see the boot program copy the boot.bin from SD to DDR RAM and then boot it.

#### Connect a USB-keyboard and VGA compatible LCD display

This method does not require a separate PC, once the bitstream has been burned to quad-spi flash. Note that the keyboard needs to be a PS/2 keyboard with USB interface to work with the Digilent board. For further information consult the Digilent documentation. It is advisable to power-cycle (i.e. turn it off and on again) after burning the QSPI flash and/or connecting these peripherals. After power-up, if all switches are off, you should see the following menu:

     selftest>

Available commands are a single character and the most commonly encountered ones are:

     'B' - boot the default kernel (default command is switch(0) is high)
     'P' - read and check kernel integrity but do not actually boot
     'D' - directory of available files
     'f' - display contents of a text file
     'J' - just jump to a pre-loaded Linux kernel (default command is switch(1) is high)
     'T' - test the SDRAM
     
Obscure commands, just for development are:

     'c' - display the SD-card response
     'd' - display the device memory map
     'C' - set the SD-card clock divider ratio
     'F' - boot from quad-SPI flash (not working in this release)
     'h' - display a SD-card disk sector
     'i' - send the legacy SD-card initialisation sequence
     'I' - send the linux compatible SD-card initialisation sequence
     'l' - set the LEDs to a hex pattern
     'm' - try to mount the MSDOS file system on the SD-card
     'M' - detect memory size with a walking ones pattern
     'q' - quit (as if there was anywhere to quit to)
     'r' - read an address range from Rocket memory
     'R' - read an address range from Minion memory
     's' - send a verbose command to the SD-card
     'S' - print the stack pointer location
     't' - control the SD-card timeout period
     'u' - try to unmount the MSDOS file system on the SD-card
     'W' - write an address in Minion memory

## Run a standalone FPGA demo (no debugger support)

We still keep the option to build a fully standalone implementation that does not rely on a debugger.

You need to download two files:

 * [nexys4ddr_fpga_standalone.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/nexys4ddr_fpga_standalone.bit):
   FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/boot.bin):
   Linux, Busybox and bootloader packaged in one image.

Download and write the bitstream:

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/nexys4ddr_fpga_standalone.bit > fpga.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/ethernet-v0.5-rc1/boot.bin > boot.bin
	

Now copy both binary files to the SD card and configure the Nexys4-DDR boot option to SD card (JP1 to USB/SD). Power up the FPGA board and open a terminal:

    microcom -p /dev/ttyUSB0 -s 115200

You should be able to see that Linux boots from SD card.

A script is provided to load your SD card without manually downloading the binary files:

    $TOP/fpga/board/nexys4_ddr/preload_image.sh /PATH/TO/SD/

You can also write the bitstream to FPGA by JTAG (JP1 to JTAG)

    vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" fpga.bit

## Mount an SD card inside RISC-V Linux

To discover whether an SD is recognized by the kernel:

    cat /proc/partitions

If an SD card is formated in FAT32 and inserted (hot insertion not supported in this kernel), it should look like:

     179        0    7707648 mmcblk0
     179        1    7706624 mmcblk0p1

The first two device nodes, and first mount point are pre-created for you. If you created further partitions manually, create the device node as follows:

    mkdir /mnt2
    mkdir /mnt3
    mknod /dev/mmcblk0p2 b 179 2
    mknod /dev/mmcblk0p3 b 179 3 #etc..

To mount a DOS file system from this card:

    mount /dev/mmcblk0p1 /mnt

After you finished with the SD card, remember to unmount it.

    umount /mnt

To mount a manually created ext2 chroot partition from this card:

    mount /dev/mmcblk0p2 /mnt
    mount -t proc none /mnt/proc
    chroot /mnt

After you finished with the chroot partition, remember to unmount it.

    exit
    umount /mnt/proc
    umount /mnt
