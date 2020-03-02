+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "Frequently asked questions"

+++

### What about binary installs ?

This release incorporates support for Nexys4-DDR boards and GenesysII boards. The latter is a paid license (though it does come with the board). It is unclear at the moment whether there is any legal distinction between non-webpack bitstreams generated using academic licenses and commercial licenses to the general public. Consequently, it is recommended that these images should only be used for research and demonstration purposes. The majority of the LowRISC release is open-source, however to take advantage of certain Xilinx features, such as DDR memory interfacing, certain distributable components can only be distributed in bitstream form for use with Xilinx parts only. There seems to be no distinction between WebPack and non-WebPack devices, from the point of view of [legal redistribution](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_2/end-user-license-agreement.pdf).


### Why are you releasing a version of Rocket that does not have the security enhancements available in the previous releases ?

The version of Rocket used as the basis of the previous releases was too old to backport any improvements, in particular it lacked the compressed instruction set (C extension), deemed essential by Debian, Fedora and OpenSuse O/S developers. Also it lacked run/step debug support, making software development tedious and error prone. Internally it only supported TileLink-1. It would be entirely possible to support a larger ecosystem with buildroot. But this would require older versions of compilers with different control and status register numbers and is outside the scope of this tutorial.

### Is it easy to upgrade the Rocket version in this new release ?

In principle yes. Rocket does not have a stable release schedule so some intelligent browsing of the commit logs is necessary to find a good point to branch off. Learning the lesson from previous experience, a minimum of changes have been made to the Chisel code, and only in areas which are not changing rapidly. The patches to the debug system are in an area that does not change frequently.

### Why is it necessary to change Rocket at all ?

The out-of-box configuration hangs on boot waiting for the debugger to connect. This is convenient for a tethered release (i.e. one that requires GDB or a separate ARM or other processor) to initialise the state of memory. In LowRISC there is no such other processor so it is more convenient to boot from specially written boot loader code. This necessitates a change of reset vector address to the start of boot ROM. It is also convenient to allow the TestHarness to set the reset address to a custom value to facilitate ISA testing.

In addition the other important change is customising the JTAG instruction register length and data capture registers to meet Xilinx FPGA restrictions (see [JTAG internals]({{< ref "docs/jtag.md" >}}) for more details).

The memory map of the default Rocket consists of a large area of RAM (in our case double data rate dynamic memory) plus an area of peripheral memory. To avoid making a lot of changes it was not though worthwhile separating out different peripherals into their own address space in Chisel, as per previous releases of LowRISC. In machine mode, this will result in a reduction of memory protection, but under Linux each peripheral space will be individually mapped in MMU space. A side effect of this approach is that it will not be possible to rely on the device tree blob built into ROM as part of the Rocket synthesis.

### What is the device tree blob and where is it ?

The device tree blob is a format for storing addresses of memory and peripherals for use in Linux and other O/S. It allows a generic kernel to be compiled and then configured for different systems later on at runtime. It also allows different FPGA boards with memory sizes to be supported from one binary. For this reason the first stage boot loader (FSBL) included with LowRISC is customised for each processor and FPGA board. The source code for the lowRISC device tree blob is in fpga/src/generic.dts. It requires pre-processing to customise it for FPGA board and CPU.

### What kernels are provided with this release ?

All kernels are based on the same linux release, a patched version of linux-5.3.18. In theory only one kernel is needed, but there are efficiency gains to be had by skipping the initial ramdisk option, if it isn't needed.

### What about support for other boards and RISCV processors ?

This release introduces a socket that can host Rocket or Ariane, analogous to the motherboards of old that allowed processors from different vendors to be used. In principle BOOM (Berkeley out-of-order machine) can fit the same template, but it would need a larger FPGA board. Because the Ariane was developed on a Genesys-2, and this has similar peripherals to a Nexys4-DDR, both FPGA boards are supported in this release. The majority of other RV64GC cores are Bluespec based. Now that Bluespec the language has become open source, I would expect research processors based on Bluespec to move to an open source model as well. The KC705 support has not been maintained. Its Ethernet PHY is incompatible with the GenesysII design, nor does it have VGA or HID capabilities. An unmaintained version is available on the kc705_mii branch. It has not been updated since the refresh-v0.6 release and does not support VGA. The HDMI connector favoured by high-end boards has a shortage of open-source specifications and drivers, largely because DCMA considerations (media copyrights and anti-circumvention measures).

### What happened to the L2-cache ?

The L2-cache was retired with TileLink-1 when it was updated to TileLink-2. This was due to bugs in the multiprocessing support. Since then multi-core support has moved to [chipyard](https://chipyard.readthedocs.io/en/latest/).
In theory two medum BOOM cores can fit in a GenesysII board. For Ariane use the [Ariane+OpenPiton project](https://openpiton-blog.princeton.edu/2018/11/announcing-openpiton-with-ariane/) using L1.5 cache is an active research activity.

### What is the Coremark performance of LowRISC ?

LowRISC achieves 2.18 Coremarks/MHz, compared to 6.43 Coremarks/MHz for a core-i7-6700, and 2.32 for a Raspberry PI model B. Of course LowRISC at the moment is just an emulation, so the 50MHz clock rate is a bottleneck. Nevertheless useful work can be done, particularly in embedded and Internet-of-things type applications.

### Why is the SD-Card reader so slow ?

The use of the hardware state machine from the OpenPiton project to drive the SD-Card boosts the performance considerably compared to previous releases and cuts the CPU overhead of disk reads and writes. However the DMA solution is not connected to the processor's slave bus to be compatible with Ariane which does not have any such bus.

### What is the Ethernet throughput ?

The Nexys4DDR has a 10/100BaseT PHY. Support for 10BaseT was not included as it is considered obsolete. The 100BaseT performance will depend on the network but with the iperf3 program sustained performance is limited to about 2MBytes/sec. The Genesys-2 has an RTL8211E Gigabit Ethernet PHY, however no offloading is done. For software downloading and extracting the performance is around 130KBytes/sec. No offloading or Jumbo packet support is included, but the latter would present few difficulties.

### What version of Linux kernel is available ?

The generic RISCV support is upstreamed as of the 5.3.18 release used in this project. LowRISC patches relative to this consist of FPGA specific device drivers and build configuration defaults amounting to 283K bytes. There are no plans to upstream the LowRISC device drivers, because there is no corresponding version of silicon to be supported. If it was decided to support these drivers long-term, it would unnecessarily hamper the process of introducing improvements such as DMA access and other goodies.

### What are the advantages and disadvantages of choosing different RISCV Linux distributions?

See the [main Linux Distribution page] ({{< ref "docs/distributions" >}}).

### What about other operating systems ?

FreeBSD was ported to the RISCV architecture by Ruslan Bukin and supports Spike and QEMU out of the box. The port to Rocket is a little more involved because originally FreeBSD assumed hardware support for Access and Dirty bits in the MMU. Rocket only supports trapping this situation and resolving in software. UART support is relatively generic but there are no plans to port the LowRISC specific device drivers from Linux to FreeBSD at the moment.

### What about X-windows, is that supported ?

The X-windows support is new for this release, it clearly requires a core pointer device. [Bluetooth HID](https://store.digilentinc.com/pmod-bt2-bluetooth-interface/) may be used (or an obsolete PS/2 mouse [Digilent PMOD PS/2 adaptor](https://store.digilentinc.com/pmod-ps2-keyboard-mouse-connector/)) The latter is deprecated because it normally requires 5V power, and the PMOD only delivers 3.3V, necessitating a hardware modification. The details are [here] ({{< ref "docs/launch-xwindows" >}}).

![screenshot](/img/screenshot3.png "ariane-0.7 release shapshot")

### What about u-boot, is that supported ?

U-boot RISCV support is upstream. LowRISC specific u-boot support (Ethernet and SD-Card support) is available on the [lowrisc branch of u-boot] (https://github.com/lowRISC/u-boot/tree/lowrisc). This version can boot from a remote tftp server. It runs in machine mode. It cannot boot vmlinux directly, only BBL+vmlinux images. If wanted, it should be launched instead of BBL+payload.
