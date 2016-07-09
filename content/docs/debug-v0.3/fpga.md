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

## Run the pre-built FPGA demo with trace debugger

The files you may needed:

 * [nexys4ddr_fpga_debug.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_debug.bit):
   The debug enabled FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin):
   Linux, Busybox and bootloader packaged in one image.
 * [nexys4ddr_bram_boot.riscv](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_bram_boot.riscv):
   A 1st bootloader to copy a program from SD to DDR RAM.

Download and write the bitstream

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_debug.bit > nexys4ddr_fpga_debug.bit
	curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin > boot.bin
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_bram_boot.riscv > nexys4ddr_bram_boot.riscv
    vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga_debug.bit

There are two ways to boot a RISC-V Linux. For both cases, we need to open the debug daemon to load programs and connect to the UART console.

#### Directly load Linux to DDR RAM

 The pre-built FPGA bitstream has a jump program as the 1st stage bootloader (in an on-chip BRAM) which just jump to DDR RAM.
 We need to load the Linux image to the DDR RAM.

    osd-cli
    osd> reset -halt
    osd> terminal 2
    osd> mem loadelf boot.bin 3
	osd> start

The terminal should again boot Linux. To update the image simply
perform the same action again.

You can get a pre-built image of [jump](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_bram_jump.riscv).

#### Load Linux from SD card

 Other than manually loading a Linux to the DDR RAM using the debugger, we can use the pre-built `nexys4ddr_bram_boot.riscv` to load Linux from SD.
 Note: make sure the Linux image `boot.bin` is copied to SD beforehand.

    osd-cli
    osd> reset -halt
    osd> terminal 2
    osd> mem loadelf nexys4ddr_bram_boot.riscv 3
	osd> start

You should be able to see the boot program copy the boot.bin from SD to DDR RAM and then boot it.

## Run a standalone FPGA demo (no debugger support)

We still keep the option to build a fully standalone implementation that does not rely on a debugger.

You need two download two files:

 * [nexys4ddr_fpga_standalone.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit):
   FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin):
   Linux, Busybox and bootloader packaged in one image.

Download and write the bitstream:

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit > fpga.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin > boot.bin
	

Now copy both binary files to the SD card and configure the Nexys4-DDR boot option to SD card (JP1 to USB/SD). Power up the FPGA board and open a terminal:

    microcom -p /dev/ttyUSB0 -s 115200

You should be able to see the Linux boots from SD card.

A script is provided to load your SD card without manually downloading the binary files:

    $TOP/fpga/board/nexys4_ddr/preload_image.sh /PATH/TO/SD/

You can also write the bitstream to FPGA by JTAG (JP1 to JTAG)

    vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" fpga.bit


## Build your own bitstream and images

### Generate the bitstream

To generate a bitstream change to the FPGA directory and use `make` to
build it:

    cd $TOP/fpga/board/nexys4_ddr
    make bitstream

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`.
This will take some time (20-60 minutes depending on your
computer). By default a debug enabled bitstream is generated. To generate a standalone bitstream, change the `CONFIG` target in Makefile to Nexys4Config and rerun the steps:

    make cleanall
    make bitstream

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
    cd $TOP/fpga/board/nexys4_ddr
    $TOP/riscv-tools/make_root.sh

If everything runs OK, you should have a boot.bin file.

### Bootloader variants

You can regenerate the 1st bootloader and put it into the FPGA bitstream.

To generate `nexys4ddr_bram_jump.riscv`:

    make jump

The bootloader is generated as `$TOP/fpga/bare_metal/examples/jump.riscv`, and it is automatically loaded in a new bitstream at

    lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit

To have the `nexys4ddr_bram_boot.riscv`, change the make target to boot. Similarly it is automatically loaded to the "new" bitstream.


