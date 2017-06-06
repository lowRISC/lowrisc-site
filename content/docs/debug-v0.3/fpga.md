+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Running on the FPGA"
parent = "/docs/debug-v0.3/walkthrough/"
prev = "/docs/debug-v0.3/debugsession/"
next = "/docs/debug-v0.3/soc_struct/"
showdisqus = true

+++

In this final step, we want to test the debug functionality on an FPGA board.
The debug system will use the UART connection at 12 MBaud to communicate with 
the debug system.

## Run the pre-built FPGA demo with a trace debugger

The files you may need:

 * [nexys4ddr_fpga_debug.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_debug.bit):
   The debug enabled FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin):
   Linux, Busybox and bootloader packaged in one image.
 * [nexys4ddr_bram_boot.riscv](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_bram_boot.riscv):
   A 1st stage bootloader to copy a program from SD to DDR RAM.

Download and write the bitstream

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_debug.bit > nexys4ddr_fpga_debug.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin > boot.bin
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_bram_boot.riscv > nexys4ddr_bram_boot.riscv
    vivado -mode batch -source $TOP/fpga/common/script/program.tcl -tclargs "xc7a100t_0" nexys4ddr_fpga_debug.bit

There are two ways to boot a RISC-V Linux. For both cases, we need to open the debug daemon to load programs and connect to the UART console.

    opensocdebugd uart device=/dev/ttyUSB0 speed=12000000

#### Directly load Linux to DDR RAM

The pre-built FPGA bitstream has a jump program as the 1st stage bootloader 
(in an on-chip BRAM) which just jumps to DDR RAM. We need to load the Linux 
image to the DDR RAM.

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

You need to download two files:

 * [nexys4ddr_fpga_standalone.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit):
   FPGA bitstream
 * [boot.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin):
   Linux, Busybox and bootloader packaged in one image.

Download and write the bitstream:

    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/nexys4ddr_fpga_standalone.bit > fpga.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.3/boot.bin > boot.bin
	

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

If an SD card is formated in FAT32 and inserted, it should look like:

     179        0    7707648 mmcblk0
     179        1    7706624 mmcblk0p1

To mount this card:

    mknod /dev/mmcblk0p1 b 179 1
    mkdir /mnt
    mount /dev/mmcblk0p1 /mnt

After you finished with the SD card, remember to unmount it.

    umount /mnt

## Build your own bitstream and images

### Generate the bitstream

#### FPGA demo with a trace debugger

    cd $TOP/fpga/board/nexys4_ddr
    make cleanall
    CONFIG=Nexys4DebugConfig make jump

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`.
This will take some time (20-60 minutes depending on your computer).

#### standalone FPGA demo without a trace debugger

    cd $TOP/fpga/board/nexys4_ddr
    make cleanall
    CONFIG=Nexys4Config make boot

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`.
This will take some time (20-60 minutes depending on your computer).

### Program the FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the FPGA:

    make program

### Build Linux

    cd $TOP/riscv-tools
    curl https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.6.2.tar.xz | tar -xJ
    curl -L http://busybox.net/downloads/busybox-1.21.1.tar.bz2 | tar -xj
    cd linux-4.6.2
    git init
    git remote add origin https://github.com/lowrisc/riscv-linux.git
    git fetch
    git checkout -f -t origin/debug-v0.3
    # lowRISC-specific hack for enabling power pin for SD card
    patch -p1 < spi_sd_power_hack.patch
    cd $TOP/fpga/board/nexys4_ddr
    $TOP/riscv-tools/make_root.sh

If everything runs OK, you should have a boot.bin file.

Please note that the Berkeley bootloader used by the Linux kernel relies on a header file (`dev_map.h`) generated by the Rocket chip (automatically generated by the Chisel compilation process).
Normally FPGA bitstream should be generated before building a kernel image.
If you like to generate a kernel image without a bitstream, run the following to produce the header file:

    cd $TOP/fpga/board/nexys4_ddr
    CONFIG=Nexys4Config make verilog

## Useful Makefile targets

#### `make project`
Generate a Vivado project.

#### `make verilog`
Run Chisel compiler and generate the Verilog files for Rocket chip.

#### `make vivado`
Open the Vivado GUI using the current project.

#### `make bitstream`
Generate the default bitstream according to the `CONFIG` in Makefile and the program loaded in `src/boot.mem`. The default bitstream is generated at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`

#### `make <hello|dram|sdcard|boot|jump|trace|flash>`
Generate bitstreams for bare-metal tests:

 * **hello** A hello world program.
 * **dram** A DDR RAM test.
 * **sdcard** A SD card read/write test.
 * **boot** A 1st bootloader that loads `boot.bin` from SD to DDR RAM and executes `boot.bin` afterwards.
 * **jump** A 1st stage booloader that directly jumps to DDR RAM.
 * **trace** A software trace demo.
 * **flash** Read the content of the on-board Flash.

For each bare-metal test `<test>`, the executable is generated to 
`examples/<test>.riscv`. It is also converted into a hex
file and copied to `src/boot.mem`, which then changes the default program for 
`make bitstream` and `make simulation`. The updated bitstream is generated at 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <program|program-updated>`
Download a bitstream to FPGA. Use `program` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`program-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <clean|cleanall>`
`make clean` will remove all generated code without removing the Vivado 
project files. To remove all files including the Vivado project, use `make 
cleanall`.
