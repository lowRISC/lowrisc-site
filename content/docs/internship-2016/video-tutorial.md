+++
Description = ""
date = "2016-09-22T13:26:41+01:00"
title = "End-to-end video decoding tutorial"
+++


## Introduction
The purpose of this tutorial is to give a simple list of steps to decode a single video on a Nexys4 DDR FPGA using lowRISC.

The extension describes how to use the accelerators.

## Step 1: The Generic lowRISC setup

Start by cloning our version of the lowRISC repository and running the typical set up commands:

```
git clone https://github.com/nbdd0121/lowrisc-chip.git
cd lowrisc-chip
git checkout vga
./setup_env.sh
git submodule update --init --recursive....
```

This tutorial relies heavily on two tools (Vivado and the RISC-V cross compiler) and requires a host of other packages. Wei Song has provided a [tutorial](https://www.lowrisc.org/docs/debug-v0.3/environment/) for setting up the environment. Install the packages on the linked page, then go to the next page ('[Generic lowRISC setup](https://www.lowrisc.org/docs/debug-v0.3/lowriscsetup/)') and follow the tutorials for [Vivado](https://www.lowrisc.org/docs/untether-v0.2/xilinx/) and the [cross-compiler](https://www.lowrisc.org/docs/untether-v0.2/riscv_compile/).

## Step 2: Building the MPEG-2 Codec
We're using a modified version of a reference MPEG-2 implementation. Start by pulling that and cross compiling it for RISC-V.

```bash
git clone https://github.com/ndavison21/lowrisc-mpeg2decode.git
cd lowrisc-mpeg2decode
make mpeg2decode-riscv
```

This results in an executable, located in src/mpeg2decode, called mpeg2decode. We will be using this later on.
The Makefile uses the gcc RISC-V cross compiler, if you get an error message such as:

```bash
riscv64-unknown-linux-gnu-gcc: Command not found
```

ensure that:

* The RISC-V cross compiler has been built
* The RISCV environment variable has been set and points to $TOP/tools/riscv/debug-v0.3
* The cross compiler has been added to the PATH environment variable: if in doubt, run:
```
export PATH=$PATH:$RISCV/bin
```

## Step 3: Setting up the Vivado project

The next steps use Vivado, which requires a few more environment variables. Customise the instructions below for your setup, and then run it.

```bash
export FPGA_BOARD=nexys4_ddr
export XILINXD_LICENSE_FILE=PATH/TO/LICENSE/FILE
source [path to vivado]/xilinx/Vivado/2015.4/settings64.sh
export XILINX_VIVADO
```

Switch to the fpga directory in the lowRISC repository to set up the Vivado project and generate the boot program:

```bash
cd $TOP/fpga/board/nexys4ddr
make project
make boot
```
NOTE: The first time you run `make boot`, it will take a while time to run, and will use a large amount of memory. It may be necessary to close other programs while this is running.

## Step 4: Building the boot image

The decoder runs on Linux, so it's necessary to download and compile the Linux kernel (we're using version 4.6.2) as well as BusyBox.

First move the cross compiled MPEG-2 decoder built in Step 2 to the directory $TOP/riscv-tools/ramfs-merge, along with the .mpg file you wish to play on the FPGA. The video MUST be less than 10 MB in size.
The decoder relies on several library files, for ease of use these are already present in the ramfs-merge directory in this branch.

Once this is done, run the below script.

```bash
cd $TOP/riscv-tools
curl https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.6.2.tar.xz \
  | tar -xJ
cd linux-4.6.2
git init
git remote add origin https://github.com/lowrisc/riscv-linux.git
git fetch
git checkout -f -t origin/debug-v0.3
cd $TOP/riscv-tools
curl -L http://busybox.net/downloads/busybox-1.21.1.tar.bz2 | tar -xj
cd busybox-1.21.1
cp $TOP/riscv-tools/busybox_config .config
make -j$(nproc)
cd $TOP/riscv-tools
./make_root.sh
```

`make_root.sh` builds both BusyBox and Linux. Due to an issue with Vivado, the build of Linux may fail with an error message that looks something like this:

```bash
awk: symbol lookup error: awk: undefined symbol: mpfr_z_sub
```

This occurs because of a conflict between Vivado and awk, detailed [here](http://www.xilinx.com/support/answers/66998.html). Since Vivado is not needed for these steps, an easy solution is starting a fresh terminal and only repeating the following steps before reattempting the above script:
* ./setup_env.sh, this script is located in the top level directory
* Setting up RISCV and PATH as discussed at the end of Step 2.

Once this has successfully completed, a file called `boot.bin` appears in the current directory ($TOP/riscv-tools). This must be copied onto the sd card, which is then to be placed into the FPGA.

## Step 5: Programming the FPGA

Now, it's finally time to program the FPGA. First, a hardware server needs to be started, TODO (source xilinx\_env, run hw\_server)

You can interact with the FPGA using microcom, as shown below:
```bash
microcom -p /dev/ttyUSB1 -s 115200
```

Switch to the nexys4_ddr directory, plug in the FPGA and run `make program-updated`.
```
cd $TOP/fpga/board/nexys4ddr
make program-updated
```

The following should appear, if nothing appears, press the `CPU Reset` button on the FPGA. :
```
Load boot.bin into memory
```

This will take a while as the boot program is copied to memory and linux boots up. The end of the process is not obvious - it's finished when the following output appears:

```
[    0.410000] mmcblk0: p1
```

Now, a somewhat barebones terminal is available (familiar shortcuts such as tab-completion and usage of the arrow keys aren't present). Connect the FPGA to a VGA monitor and run:

```bash
./mpeg2decode -f -b video.mpg -o6
```

Where video.mpg is the video file loaded earlier. The video should now play on the monitor from the FPGA.


## Extension: Using accelerators

It is possible to use the accelerators we have created with a slight 
alteration to **Step 1** described above. In order to include the accelerators 
in the synthesis, replace `git checkout vga` with `git checkout acc`, and the 
run the other instructions as before.

When it comes to running the codec, a final option specifying the accelerator to use is needed. To run all the accelerators the command is 
```bash 
./mpeg2decode -f -b video.mpg -o6 -a15
```
To run individual accelerators, replace `15` with the following values

| Accelerator     | Binary | Decimal |
|-----------------|--------|----------|
| Y'UV 422 to 444 | 0001   | 1        |
| Y'UV 444 to RGB | 0010   | 2        |
| RGB 32 to 16    | 0100   | 4        |
| IDCT            | 1000   | 8        |
| ALL             | 1111   | 15       |

(each bit indicates the presence or absence of a specific accelerator, as indicated above)
