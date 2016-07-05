+++
Description = ""
date = "2015-04-12T15:52:33+01:00"
title = "Running tests on the Zedboard FPGA"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/verilog-fpga-sim/"
next = "/docs/tagged-memory-v0.1/future/"
aliases = "/docs/tutorial/fpga/"
showdisqus = true

+++


## Introduction

The Berkeley Rocket Chip can be run on various Zynq FPGA
boards. Details of how to do this can be found [here][fpga-zynq]. For
convenience, we step through a very similar process and describe
how to run simple tagged memory tests.

The [ZedBoard][ZedBoard] is a low-cost (~$300-$400) development board
built around the Xilinx Zynq-7000. The Zynq-7000 architecture consists
of a dual-core ARM Cortex-A9 based "processing system" (PS) and
programmable logic (PL), i.e. ARM cores, I/O, caches, memory
controllers etc. integrated with and interconnected to an FPGA. 512MB
of DDR3 memory and 256MB Quad-SPI flash is also provided.

The ARM side of the system provides a way to bootstrap the RISC-V
cores and, when running, services I/O related system calls via the
Host-Target Interface Bus (HTIF). 

<img src="../figures/zynq_struct.png" alt="Drawing" style="width: 500px;"/>

Main memory is shared between the ARM and RISC-V cores. The lower
256MB is allocated to the ARM side and the upper 256MB to the RISC-V
side. The top 16MB of the RISC-V memory is reserved for storing tags.

<img src="../figures/mem_map.png" alt="Drawing" style="width: 500px;"/>

Note: It is possible to change the amount of memory available to the
RISC-V system by modifying the `htif_zedbaord_t::mem_mb()` function
defined in `riscv-tools/riscv-fesvr/fesvr/htif_zedboard.h`.

FPGA bitstreams are loaded via the SD card. The ARM side of the board
can also be accessed via the board's ethernet interface using an SSH
connection.

## The prebuilt boot image

A prebuilt FPGA image is provided at
`lowrisc-chip/fpga-zynq/zedboard/fpga-images-zedboard`. 

The contents of this SD card are described [here][fpga-zynq-sdcard]
and below. We add some additional scripts and the preloaded tagged
memory test cases.

 * `boot.bin`: [boot image][xilinx-boot] for the Zynq
 * `boot_image/`: These files are used to generate `boot.bin`. They are not
   used directly by the FPGA. 
   * `system.bit`: FPGA bitstream
   * `u-boot.elf`: The ARM u-boot bootloader
   * `zynq_fsbl.elf`: [First Stage Boot Loader (FSBL)][xilinx-ug-boot]
 * `uImage`: ARM Linux
 * `uramdisk.image.gz`: the RAMDisk containing the root filesystem
 * `devicetree.dtb`: Device map for the ARM's peripherals
 * `riscv/`: RISC-V Linux
   * `vmlimux`: The RISC-V Linux kernel
   * `root.bin`: the RAMDisk containing the root filesystem for RISC-V Linux
 * `script/`: Various scripts to help run our tagged memory tests 
 * `tests/`: The preloaded tagged memory tests

## Booting the Zedboard

Format a SD card to FAT32. 

To use the prebuilt image simply copy the files to the SD card:

    cd $TOP/fpga-zynq/zedboard
    # in case the pre-compiled image is not downloaded
    git submodule update --init fpga-images-zedboard
    sudo cp -r fpga-images-zedboard/* /PATH/TO/SD

Note: It is safe to ignore the two warnings about symbolic links

To boot the FPGA demo simply:

 * Turn off the board's power (`SW8`)
 * Insert the SD card (`J12`) 
 * Set jumpers `M02-M06` to `5'b00110`
 * Connect power (`J20`)
 * Turn the board on (`SW8`)
 * If all goes well and the image loads, the blue LED (`LD12`) should light

<img src="../figures/zedboard.jpg" alt="Drawing" style="width: 500px;"/>

## Communication with ARM Linux via SSH 

The Zedboard is configured to use the IP address `192.168.1.5`.
[Manually configure][zedboard-ug-ethernet] your host PC with an IP
address on the `192.168.1.x` subnet (e.g. `192.168.1.1`).

After setting the IPv4 address, the host PC can access the ZedBoard via SSH (assuming that the ARM Linux has booted successfully):

      ssh root@192.168.1.5

SSH is setup on the ramdisk to use `root` as the user and `root` as
the password.

Once your have logged in you should see a shell provided by the ARM
Linux. It is also possible to use `scp` to copy files between the host
PC and ARM Linux filesystem. 

## "Hello World"

The initial shell you have logged in runs on the ARM Linux rather than
the RISC-V Linux. In this environment you can launch bare metal
programs and those that run with the help of the proxy kernel. Three
executables are pre-loaded in the root home directory (`/home/root`)
to make this possible:

 * `fesvr-zynq`: The front-end server which runs on the ARM core and 
   interfaces to the rocket chip
 * `pk`: The [RISC-V proxy kernel][riscv-pk]
 * `hello`: A hello world test program that uses the newlib library

To run the test program type:

    ./fesvr-zynq pk hello

If you see

    hello!

Great! The Rocket core is running. 

## Running more tests

To run more tests the content on the SD card must be mounted into the
ARM Linux. A script is provided for this job:

    ~/setup_env.sh

This script mounts the SD card and copies additional scripts to the
root home directory (see script for details). 

The bare metal test programs in `lowrisc-chip/riscv-tools/riscv-tests`
and the proxy kernel test programs in
`lowrisc-chip/riscv-tools/lowrisc-tag-tests` (used for testing the tag
cache) are pre-loaded to the `tests/` directory in the SD card. After
running the setup_env.sh, it is also linked to `/home/root/tests`. 

The tests are stored in four subdirectories, where `benchmark`, `isa`, and
`mt` are the original test cases from `riscv-tools/riscv-tests` and `tag`
holds the new tagged memory tests (`riscv-tools/lowrisc-tag-tests`).

A script (`test.sh`) is provided to run all tests in a particular
directory. This script is copied from `/sdcard/scripts` to
`/home/root/` after running `setup_env.sh`. 

e.g. to run all tagged memory tests: 

     cd ~/tests/tag
     ~/test.sh

## Running tests under RISC-V Linux

To run and test the RISC-V Linux on the Rocket core: 

    ~/boot_linux.sh

RISC-V Linux should boot in around 5 seconds, a shell should then be
provided on the host PC. 

Three test programs are pre-loaded in `/tests`:

 * `hello`: Hello World test
 * `parity.linux`: tag cache test
 * `tag_ld_st.linux`: tag cache test

These binaries can be run directly, e.g. 

      /tests/tag_ld_st.linux

## Going further

 * [Rebuilding the boot image]({{< ref "docs/tagged-memory-v0.1/fpga-bootimage.md" >}})
 * [Modifying the contents of the RAMDisk]({{< ref "docs/tagged-memory-v0.1/fpga-ramdisk.md" >}})
 * [Building the front-end server]({{< ref "docs/tagged-memory-v0.1/fpga-fesvr.md" >}})
 * [Building the ARM Linux kernel](https://github.com/ucb-bar/fpga-zynq#36--building-linux-for-the-arm-ps)

<!-- Links -->
[ZedBoard]: http://zedboard.org/product/zedboard
[fpga-zynq]: https://github.com/ucb-bar/fpga-zynq
[fpga-zynq-sdcard]: https://github.com/ucb-bar/fpga-zynq#e--contents-of-the-sd-card
[xilinx-boot]: http://www.wiki.xilinx.com/Prepare+boot+image
[xilinx-ug-boot]: http://www.xilinx.com/support/documentation/user_guides/ug821-zynq-7000-swdev.pdf#M5.9.23265.ChapterTitle.Boot.and.Configuration
[zedboard-ug-ethernet]: http://zedboard.org/sites/default/files/GS-AES-Z7EV-7Z020-G-14.1-V1.pdf#23
[riscv-pk]: https://github.com/riscv/riscv-pk

