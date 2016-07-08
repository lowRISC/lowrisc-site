+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Running on the FPGA"
parent = "/docs/debug-v0.3/walkthrough/"
prev = "/docs/debug-v0.3/debugsession/"
next = "/docs/debug-v0.3/soc_struct/"
showdisqus = true

+++

In this final step, we want to test the debug on the FPGA board. The
debug system will use the UART connection at 3 MBaud to communicate
with the debug system.

## Run the standalone FPGA

You need two download two files:

 * [nexys4ddr_fpga_standalone.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit):
   FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin):
   Linux, Busybox and bootloader packaged in one image.

Download and write the bitstream:

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit > nexys4ddr_fpga_standalone.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin > boot.bin
	
    vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga_standalone.bit

Now copy the binary file to the SD card. It must be a FAT32 formatted
SD card. Insert the SD card into the slot. After that connect to the
system using the debug daemon:

    opensocdebugd uart device=/dev/ttyUSB0 speed=3000000

Then connect with the CLI in another terminal and boot Linux:

    osd-cli
    osd> terminal 2
	osd> reset

Now Linux should boot and you can interact with the terminal! In case
you experience issues with the boot procedure, try to reset again or
close the debug connection and try a hard reset of the board.

## Run the FPGA with debug initialization

To save the procedure to move the SD card from board to computer for
each change, it is also possible to load the image directly to RAM
from the debug system.

For that we currently have a different bootloader, that simply jumps
to DDR. You can again download the pre-built bitstream and program the
FPGA:

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_debug.bit > nexys4ddr_fpga_debug.bit
	vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga_debug.bit

Now you can connect the daemon again and load the binary from the CLI:

    osd-cli
    osd> reset -halt
    osd> terminal 2
    osd> mem loadelf boot.bin 3
	osd> start

The terminal should again boot Linux. To update the image simply
perform the same action again.

## Build bitstream and Linux image

### Generate the bitstream

To generate a bitstream change to the FPGA directory and use `make` to
build it:

    cd $TOP/fpga/board/nexys4_ddr
    make bitstream

This will take some time (20-60 minutes depending on your
computer).

### Program the FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the FPGA:

    make program

### Build Linux

    cd $TOP/riscv-tools
    curl https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.1.25.tar.xz| tar -xJ
    curl -L http://busybox.net/downloads/busybox-1.21.1.tar.bz2| tar -xj
    cd linux-4.1.25
    git init
    git remote add origin https://github.com/lowrisc/riscv-linux.git
    git fetch
    git checkout -f -t origin/debug-v0.3

    # then actually just go to any directory
    $TOP/riscv-tools/make_root.sh
    # it will generate boot.bin and copy it there

### Bootloader variants

You can update the bootloader in the bitstream image. Simply run

    make boot

to generate
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top_new.bit` with
the bootloader that boots from SD.

If you instead want to use the debug bootloader where you initialize
the DDR via the debug system, run:

    make jump

This will generate
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top_new.bit` with
that bootloader.
