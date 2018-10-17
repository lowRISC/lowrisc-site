+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "Frequently asked questions"

+++

### Why are you releasing a separate binary installation guide ?

The source code installation and build environment is 20GBytes for this release. The Vivado installation is 28GBytes. The quickstart binary distribution is 5GBytes, and hence is more suitable for older computers and/or users with limited internet bandwidth. Also there are a lot of technologies to understand to succeed with new development from source. We think users will want to see what can be achieved before going to the trouble of learning about everything.

### Why are you releasing a version of Rocket that does not have the security enhancements available in the previous releases ?

The version of Rocket used as the basis of the previous releases was too old to backport any improvements, in particular it lacked the compressed instruction set (C extension), deemed essential by Debian, Fedora and OpenSuse O/S developers. Also it lacked run/step debug support, making software development tedious and error prone. Internally it only supported TileLink-1.

### Is it easy to upgrade the Rocket version in this new release ?

In principle yes. Rocket does not have a stable release schedule so some intelligent browsing of the commit logs is necessary to find a good point to branch off. Learning the lesson from previous experience, a minimum of changes have been made to the Chisel code, and only in areas which are not changing rapidly.

### Why is it necessary to change Rocket at all ?

The out-of-box configuration hangs on boot waiting for the debugger to connect. This is convenient for a tethered release (i.e. one that requires GDB or a separate ARM or other processor) to initialise the state of memory. In LowRISC there is no such other processor so it is more convenient to boot from specially written boot loader code. This necessitates a change of reset vector address to the start of boot ROM. It is also convenient to allow the TestHarness to set the reset address to a custom value to facilitate ISA testing.

In addition the other important change is customising the JTAG instruction register length and data capture registers to meet Xilinx FPGA restrictions (see [JTAG internals]({{< ref "docs/jtag.md" >}}) for more details).

The memory map of the default Rocket consists of a large area of RAM (in our case double data rate dynamic memory) plus an area of peripheral memory. To avoid making a lot of changes it was not though worthwhile separating out different peripherals into their own address space in Chisel, as per previous releases of LowRISC. In machine mode, this will result in a reduction of memory protection, but under Linux each peripheral space will be individually mapped in MMU space. A side effect of this approach is that it will not be possible to rely on the device tree blob built into ROM as part of the Rocket synthesis.

### What is the device tree blob and where is it ?

The device tree blob is a format for storing addresses of memory and peripherals for use in Linux and other O/S. It allows a generic kernel to be compiled and then configured for different systems later on at runtime. It is generated from device tree source using device tree compiler. In LowRISC it is associated with the Berkeley boot loader, because it would be inconvenient to keep changing the first stage boot loader when anything changes.

### What's with the weird console support ?

The first stage boot loader (FSBL) included with LowRISC does not provide a convenient way of choosing the console device (after all the interaction at this stage is limited to a few switches). Therefore the decision was taken to assume a visual console (also known as VT mode). This provides a facility similar to a PC with a 128 x 31 VGA text display with a variety of highlight colours, and a keyboard that generates PC-compatible up and down events that are needed by the operating system in certain modes. However we also need to allow for the common case when the board is purely controlled from a serial port. This support requires translating, as well as possible, serial ASCII input to keyboard up/down event numbers, as well as interpreting the characters sent to the VGA screen to the nearest equivalent ASCII output to the serial port. No attempt is made to translate cursor movement on the VGA screen to ANSI escape sequences. Therefore some strange effects can occur if editing in vim or similar programs is attempted on the serial console. Fortunately this capability is rarely needed because ssh support via Ethernet gives all the capabilities that could be wanted in the way of remote access.

### What about support for other boards and RISCV processors ?

The KC705 support has not been maintained since the v0.3 release. However it is interesting because it allows for more expansion space, the possibility of dual core symmetric processing, and out-of-order cores such as BOOM (Berkeley out of order machine). Support for this board has not been merged with the refresh-v0.6, however development is ongoing on the kc705_mii branch.

The ArtyA7-A100 is a recently released and reduced cost board from Digilent that has the same FPGA and twice the memory of the Nexys4DDR. It uses DDR3 instead of DDR2. However it requires a separate PMOD (potentially with reduced signal integrity), in order to support SD-Cards. The Ethernet PHY is a different type and development is taking place on the artya7_mii branch.

### What happened to the L2-cache ?

The L2-cache was retired with TileLink-1 when it was updated to TileLink-2. This was due to bugs in the multiprocessing support. No replacement L2-cache has been released by Berkeley Architecture Research since then.

### What is the Coremark performance of LowRISC ?

LowRISC achieves 2.18 Coremarks/MHz, compared to 6.43 Coremarks/MHz for a core-i7-6700, and 2.32 for a Raspberry PI model B. Of course LowRISC at the moment is just an emulation, so the 50MHz clock rate is a bottleneck. Nevertheless useful work can be done, particularly in embedded and Internet-of-things type applications.

### Why is the SD-Card reader so slow ?

SD-Card architectures have gone through tremendous improvements recently to make them more suitable for digital cameras and other typical architectures. Some of these improvements are carried through to the FPGA board, and others not. Signal integrity reasons prevent the card operating at its best possible speed in these circumstances, also the on-board flash controller is optimised towards large FAT filing systems rather than the EXT4 system favoured by Linux. A further reason which needs reworking in due course is that the Rocket is interrupted at the end of every SD command and every data transfer (no offloading is done). Continuous read mode is not supported, which would reduce overheads considerably if implemented.

### What is the Ethernet throughput ?

The Nexys4DDR has a 10/100BaseT PHY. Support for 10BaseT was not included as it is considered obsolete. The 100BaseT performance will depend on the network but with the iperf3 program sustained performance is limited to about 2MBytes/sec. For software downloading and extracting the performance is around 130KBytes/sec. No offloading or Jumbo packet support is included, but the latter would present few difficulties.

### What version of Linux kernel is available ?

The majority of the RISCV support was upstreamed as of the 4.18 release. Generic RISCV patches off this release amount to 39K bytes, LowRISC specific patches (primarily device drivers) amount to 87K bytes. It is anticipated the generic patches will reduce to almost nothing by the time of the 4.19 release. There are no plans to upstream the LowRISC device drivers, because there is not corresponding version of silicon to be supported. If it was decided to support these drivers long-term, it would unnecessarily hamper the process of introducing improvements such as DMA access and other goodies.

### Why was the Debian distribution chosen? Isn't it rather unstable ?

The Debian unstable distribution places a burden on maintainers to ensure that stable versions will not be impacted by changes required to support new architectures. Therefore it takes a while for support to move from unstable to a stable distribution. In addition some late changes to RISCV ABI have been made without fully appreciating the impact on O/S developers. Furthermore the list of control and status registers (CSRs) has been changing and some have been renamed or renumbered. LowRISC currently relies on several unstable packages that are not released. The Fedora picture is a little more rosy, but the use of DNF as a default package manager with its reliance on Python and friends, has too high an overhead for this hardware.

### What about other Linux distributions ?

The Debian distribution was chosen as it has the least burden on the processor. This is because its package manager is written in C++ and is streamlined. By contrast RPM based distributions such as Fedora and OpenSuse place a great deal of reliance on Python coding which is convenient but slow (especially when running a Python interpreter on an FPGA emulator).

### What about other operating systems ?

FreeBSD was ported to the RISCV architecture by Ruslan Bukin and supports Spike and QEMU out of the box. The port to Rocket is a little more involved because the current version of FreeBSD assumes hardware support for Access and Dirty bits in the MMU. Rocket only supports trapping this situation and resolving in software. This problem is currently being investigated and this site will be updated as and when FreeBSD is supported.

### What about u-boot, is that supported ?

The u-boot system has a number of powerful facilities, for example being able to store boot parameters in non-volatile memory, and enabling booting via TFTP or NFS. It can also read kernels from FAT partitions and carry out various self-tests. Unfortunately it is also rather large, and it was felt that an embedded environment should not have a large ROM on board. However, there is nothing to stop u-boot from being attached as an option instead of BBL, when launched from the first stage boot loader. In fact the MMC/SD-Card support routines in the latest release are based on a cut-down version of u-boot FSBL. The out-of-the-box FSBL support in u-boot needs modifying in order to eventually replace our own boot loader entirely.


