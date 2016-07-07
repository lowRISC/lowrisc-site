+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "FPGA Demo"
parent = "/docs/untether-v0.2/simulation/"
prev = "/docs/untether-v0.2/vsim/"
next = "/docs/untether-v0.2/fpga-sim/"
showdisqus = true

+++

A comprehensive FPGA demo of the untethered lowRISC SoC is provided using either the Xilinx KC705 kit or the NEXYS4-DDR board.

Depending on the board, please set variable $FPGA_BOARD to the board name. It is set to kc705 in `lowrisc-chip/set_riscv_env.sh`. 

### File structure of the FPGA demo

 * `constraint`: The constraint files used for the FPGA demo
 * `driver`: Bare metal driver programs used by bootloaders.
 * `examples`: Some bare metal test programs for FPGA peripherals.
  * `boot`: Bootloader test, also serves as the on-chip boot program used by the FPGA demo.
  * `dram`: Test program for the DDR RAM interface.
  * `hello`: A simple hello world program using the UART interface.
  * `reset`: A simulation-only test for the soft-reset process.
  * `sdcard`: Test the SD (SPI mode) interface and the [FatFS](http://elm-chan.org/fsw/ff/00index_e.html) (Fat 32) support.
 * `bbl`: A revised Berkeley bootloader (BBL).
 * `generated-src`: Generated Verilog of the Chisel Rocket chip.
 * `lowrisc-chip-imp`: lowRISC SoC FPGA project directory.
 * `Makefile`: The root Makefile.
 * `script`: Some Vivado helper scripts.
 * `softfloat`: A soft implementation of single/double precision floating point library.
 * `src`: Source files needed by the FPGA demo
  * `boot.mem`: The initial memory image of the on-chip booting BRAM.
  * `boot.bmm`: A memory structure file needed for reload memory image in bitstreams.

### Compile the FPGA project

To generate a bitstream:

    cd $TOP/fpga/board/$FPGA_BOARD
    make bitstream

This make target automatically processes all compiling process from Chisel compilation to bitstream generation. The final bit stream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`. However, in most cases, this bitstream may NOT be the one downloaded to the FPGA. Users can freely change the boot BRAM image after a bitstream is generated.

For installing the USB-JTAG and USB-UART bridge, please see [[Install Xilinx Vivado]] ({{<ref "docs/untether-v0.2/xilinx.md">}}).

#### Compile and run bare metal examples

Four runnable bare-metal examples are provided for users to run on FPGA. To compile an example and replace the bitstream with a new boot image, just use the example name as the make target.

    cd $TOP/fpga/board/$FPGA_BOARD
    # compile and load the "hello" example
    make hello

If any of the examples have been compiled after an initial bitstream is generated, a NEW bitstream is generated as `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit` and this new bitstream should be used for configuring FPGA.

#### Hello world

This is a simple example testing the UART interface.

By default, the UART interface is configured to 115200Hz, 8-bit data and 1 bit odd parity check.

Currently we recommend to use `microcom` (available in `apt-get`) to connect UART.

    microcom -p /dev/ttyUSB0 -s 115200

After downloading the bitstream, the UART interface should print:

    Hello World!

#### DRAM self-test

This example executes a read/write check of the DDR RAM. The check results are constantly printed to UART.

Below is the result from the UART:

    DRAM test program.
    Write block @0 using key 0
    Write block @4000 using key 6f0f0ff0ff0fffff
    Write block @8000 using key acff906f00ffff00
    Write block @c000 using key ecd95a6095a65969
    Write block @10000 using key 5cf06fffc300acff
    Write block @14000 using key ef83f98ae4fbad3
    Write block @18000 using key 4a0f9ca55caacaf6
    Write block @1c000 using key 2c8ae174c8b13510
    Write block @20000 using key 3af96f0083266fff
    Write block @24000 using key 6d788d0089c15a13
    Write block @28000 using key bf2e925022d01819
    Write block @2c000 using key e5e31b4b77965fa5
    Write block @30000 using key cf85bf001a4f1c85
    Write block @34000 using key 182c99425f8cbd83
    Write block @38000 using key 95447d5e25bcede0
    Write block @3c000 using key 24def12a6b72afcf
    Check block @0 using key 0
    Write block @40000 using key bbc564a55a2f0000
    Check block @4000 using key 6f0f0ff0ff0fffff
    Write block @44000 using key 83e338f02c13ba40
    Check block @8000 using key acff906f00ffff00
    Write block @48000 using key 884576c23f9c42d9
    Check block @c000 using key ecd95a6095a65969
    Write block @4c000 using key af8184510747721f
    Check block @10000 using key 5cf06fffc300acff
    Write block @50000 using key c4b4d72cc1683166
    Check block @14000 using key ef83f98ae4fbad3
    Write block @54000 using key 8e92787d607a7aa6
    Check block @18000 using key 4a0f9ca55caacaf6
    ......

#### SD card read test

This example reads a file named `test.txt` stored on a SD card (formatted in 
FAT32) and then prints the content of this file to UART.

Following is the result from UART:

    test.txt opened
    Test SD file read.
    Hello!?

    file size 28
    test.txt closed.


#### Boot test

This example copies the content of a executable named "`boot`" from a SD card to DDR RAM and then boots it from DDR RAM.

This example also served as the initial bootloader for the RISC-V Linux FPGA demo. It copies the revised BBL from SD to DDR RAM.

Here is the UART output if we store a hello world executable to SD as the 
`boot` program.

    lowRISC boot program
    =====================================
    Load boot into memory
    Load 1b418 bytes to memory.
    Read boot and load elf to DDR memory
    Boot the loaded program...
    Hello World!

<a name="boot"></a>
### Boot RISC-V Linux

For first time users, please try the pre-compiled RISC-V and ramdisk images.

    cd $TOP/fpga/board/$FPGA_BOARD
    # insert and mount a SD card
    # Ensure the SD card is formatted in FAT32

    # download and copy the pre-compiled image
    . preload_image.sh /PATH/TO/SD/

    # umount the SD card
    # insert the SD card to KC705 or NEXYS4-DDR

    # compile and load the on-chip boot
    make boot

    # open a UART terminal
    # set it to 115200 8bit data 1bit odd parity

    # open Vivado and download bit file:
    # lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit

Here is the output from the UART for a successful boot:

    lowRISC boot program
    =====================================
    Load boot into memory
    Load 12660 bytes to memory.
    Read boot and load elf to DDR memory
    Boot the loaded program...
    [    0.000000] Linux version 3.14.41-g886e5f9 (ws327@valencia.cl.cam.ac.uk) (gcc version 5.2.0 (GCC) ) #12 Mon Nov 9 14:45:45 GMT 2015
    [    0.000000] Available physical memory: 1022MB
    [    0.000000] Zone ranges:
    [    0.000000]   Normal   [mem 0x00200000-0x3fffffff]
    [    0.000000] Movable zone start for each node
    [    0.000000] Early memory node ranges
    [    0.000000]   node   0: [mem 0x00200000-0x3fffffff]
    [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258055
    [    0.000000] Kernel command line: root=/dev/htifblk0
    [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
    [    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
    [    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
    [    0.000000] Sorting __ex_table...
    [    0.000000] Memory: 1028060K/1046528K available (1725K kernel code, 120K rwdata, 356K rodata, 68K init, 211K bss, 18468K reserved)
    [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
    [    0.000000] NR_IRQS:2
    [    0.150000] Calibrating delay using timer specific routine.. 20.01 BogoMIPS (lpj=100098)
    [    0.150000] pid_max: default: 32768 minimum: 301
    [    0.150000] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
    [    0.150000] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
    [    0.150000] devtmpfs: initialized
    [    0.150000] NET: Registered protocol family 16
    [    0.150000] bio: create slab <bio-0> at 0
    [    0.150000] Switched to clocksource riscv_clocksource
    [    0.150000] NET: Registered protocol family 2
    [    0.150000] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
    [    0.150000] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
    [    0.150000] TCP: Hash tables configured (established 8192 bind 8192)
    [    0.150000] TCP: reno registered
    [    0.150000] UDP hash table entries: 512 (order: 2, 16384 bytes)
    [    0.150000] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
    [    0.150000] NET: Registered protocol family 1
    [    0.150000] futex hash table entries: 256 (order: 0, 6144 bytes)
    [    0.150000] io scheduler noop registered
    [    0.150000] io scheduler cfq registered (default)
    [    0.180000] htifcon htif0: detected console
    [    0.190000] console [htifcon0] enabled
    [    0.190000] htifblk htif1: detected disk
    [    0.190000] htifblk htif1: added htifblk0
    [    0.200000] TCP: cubic registered
    [    0.200000] VFS: Mounted root (ext2 filesystem) readonly on device 254:0.
    [    0.200000] devtmpfs: mounted
    [    0.200000] Freeing unused kernel memory: 68K (ffffffff80000000 - ffffffff80011000)
    [    0.440000] EXT2-fs (htifblk0): warning: mounting unchecked fs, running e2fsck is recommended
    # 

#### Prepare your own images

Three files are needed on SD for booting RISC-V Linux:

 * `boot`: The bootloader (a revised Berkeley bootloader, BBL) for loading Linux kernel.
 * `vmlinux`: The RISC-V Linux kernel.
 * `root.bin`: The ramdisk image.

For generating your own `vmlinux` and `root.bin`, please see [[Compiling 
RISC-V Linux and the ramdisk `root.bin`]] ({{<ref "docs/untether-v0.2/linux_compile.md">}}).

After compilation, load the kernel and ramdisk to SD:

    cd $TOP/riscv-tools
    cp linux-3.14.41/vmlinux /PATH/TO/SD/vmlinux
    cp busybox-1.21.1/root.bin /PATH/TO/SD/root.bin

For generating BBL:

    cd $TOP/fpga/board/$FPGA_BOARD
    make bbl
    cp bbl/bbl /PATH/TO/SD/boot

### Other useful Makefile targets

    # generate a Vivado project
    make project

    # generate Verilog source files
    make verilog

    # generate and open a Vivado project in GUI
    make vivado

    # generate the BRAM structure file `src/boot.bmm`
    make search-ramb

    # replace the BRAM image in bitstream with `src/boot.mem`
    make bit-update

    # clean log files
    make clean

    # clean the whole project
    make cleanall

## FPGA resource utilization

#### KC705

Core clock rate: 50 MHz

Overall resource utilization: LUT 27%, Register 8%, BRAM 17% DSP 3%

|                    |LUT     |Register      |BRAM      |DSP    |
|--------------------|--------|--------------|----------|-------|
|Overall             |54783   |32200         |74        |24     |
|* DDR3 Controller   |15389   |12258         |1         |0      |
|* NASTI Crossbar    |2254    |288           |0         |0      |
|* Rocket chip       |35421   |17343         |57        |24     |
|*** Rocket Tile     |23272   |11911         |21        |24     |
|***** Core          |4228    |1598          |0         |4      |
|***** FPU           |12626   |4150          |0         |20     |
|***** L1 D$         |2705    |2402          |11        |0      |
|***** L1 I$         |3477    |3545          |10        |0      |
|*** L2$             |9086    |3264          |36        |0      |

#### NEXYS4-DDR

Core clock rate: 25 MHz

Overall resource utilization: LUT 69%, Register 19%, BRAM 54% DSP 10%

|                    |LUT     |Register      |BRAM      |DSP    |
|--------------------|--------|--------------|----------|-------|
|Overall             |43716   |23489         |73        |24     |
|* DDR2 Controller   |4433    |3574          |0         |0      |
|* NASTI Crossbar    |2235    |288           |0         |0      |
|* Rocket chip       |35330   |17343         |57        |24     |
|*** Rocket Tile     |23188   |11911         |21        |24     |
|***** Core          |4228    |1598          |0         |4      |
|***** FPU           |12566   |4150          |0         |20     |
|***** L1 D$         |2686    |2402          |11        |0      |
|***** L1 I$         |3473    |3545          |10        |0      |
|*** L2$             |9079    |3264          |36        |0      |

