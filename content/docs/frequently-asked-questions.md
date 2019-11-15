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

### What is the device tree blob and where is it ?

The device tree blob is a format for storing addresses of memory and peripherals for use in Linux and other O/S. It allows a generic kernel to be compiled and then configured for different systems later on at runtime. It also allows different FPGA boards with memory sizes to be supported from one binary. For this reason the first stage boot loader (FSBL) included with LowRISC is customised for each processor and FPGA board.

### What kernels are provided with this release ?

All kernels are based on the same linux release, a patched version of linux-5.1.3. In addition there is an install variant that can launch debian installer, a rescue variant that can repair the SD-Card root partition before mounting it, a visual variant that redirects the console to the frame buffer, and a plain variant that just boots via a serial port.

### What about support for other boards and RISCV processors ?

This release introduces a socket that can host Rocket or Ariane, analogous to the motherboards of old that allowed processors from different vendors to be used. In principle BOOM (Berkeley out-of-order machine) can fit the same template, but it would need a larger FPGA board. Because the Ariane was developed on a Genesys-2, and this has similar peripherals to a Nexys4-DDR, both FPGA boards are supported in this release.
The KC705 support has not been maintained since the v0.3 release. However it is interesting because it allows for more expansion space, the possibility of dual core symmetric processing, and out-of-order cores such as BOOM (Berkeley out of order machine). Support for this board has not been merged with the ariane-v0.7, however development is ongoing on the kc705_mii branch.

### What happened to the L2-cache ?

The L2-cache was retired with TileLink-1 when it was updated to TileLink-2. This was due to bugs in the multiprocessing support. No replacement L2-cache has been released by Berkeley Architecture Research since then.

### What is the Coremark performance of LowRISC ?

LowRISC achieves 2.18 Coremarks/MHz, compared to 6.43 Coremarks/MHz for a core-i7-6700, and 2.32 for a Raspberry PI model B. Of course LowRISC at the moment is just an emulation, so the 50MHz clock rate is a bottleneck. Nevertheless useful work can be done, particularly in embedded and Internet-of-things type applications.

### Why is the SD-Card reader so slow ?

The use of the hardware state machine from the OpenPiton project to drive the SD-Card boosts the performance considerably compared to previous releases and cuts the CPU overhead of disk reads and writes. However the DMA solution is not connected to the processor's slave bus to be compatible with Ariane which does not have any such bus.

### What is the Ethernet throughput ?

The Nexys4DDR has a 10/100BaseT PHY. Support for 10BaseT was not included as it is considered obsolete. The 100BaseT performance will depend on the network but with the iperf3 program sustained performance is limited to about 2MBytes/sec. The Genesys-2 has an RTL8211E Gigabit Ethernet PHY, however no offloading is done. For software downloading and extracting the performance is around 130KBytes/sec. No offloading or Jumbo packet support is included, but the latter would present few difficulties.

### What version of Linux kernel is available ?

The generic RISCV support is upstreamed as of the 5.1.3 release. LowRISC patches relative to this consist of FPGA specific device drivers amounting to 268K bytes. There are no plans to upstream the LowRISC device drivers, because there is not corresponding version of silicon to be supported. If it was decided to support these drivers long-term, it would unnecessarily hamper the process of introducing improvements such as DMA access and other goodies.

### Why was the Debian distribution chosen? Isn't it rather unstable ?

The Debian unstable distribution places a burden on maintainers to ensure that stable versions will not be impacted by changes required to support new architectures. Therefore it takes a while for support to move from unstable to a stable distribution. In addition some late changes to RISCV ABI have been made without fully appreciating the impact on O/S developers. Furthermore the list of control and status registers (CSRs) has been changing and some have been renamed or renumbered. LowRISC currently relies on several unstable packages that are not released. The Fedora picture is a little more rosy, but the use of DNF as a default package manager with its reliance on Python and friends, has too high an overhead for this hardware.

### What about other Linux distributions ?

The Debian distribution was chosen as it has the least burden on the processor. This is because its package manager is written in C++ and is streamlined. By contrast RPM based distributions such as Fedora and OpenSuse place a great deal of reliance on Python coding which is convenient but slow (especially when running a Python interpreter on an FPGA emulator). Even so the use of apt (advanced package tool) at the same time as other software should be avoided due to memory constraints.

### What about other operating systems ?

FreeBSD was ported to the RISCV architecture by Ruslan Bukin and supports Spike and QEMU out of the box. The port to Rocket is a little more involved because originally FreeBSD assumed hardware support for Access and Dirty bits in the MMU. Rocket only supports trapping this situation and resolving in software. UART support is relatively generic but there are no plans to port the LowRISC specific device drivers from Linux to FreeBSD at the moment.

### What about X-windows, is that supported ?

The X-windows support is new for this release, it requires some hardware modifications to support a PS/2 mouse. The nexys4_ddr board doesn't have a convenient way to support mouse and keyboard simultaneously. The easiest solution for testing is to use a [Digilent PMOD PS/2 adaptor](https://store.digilentinc.com/pmod-ps2-keyboard-mouse-connector/) and manually wire the 5V supply from the power connector. PS/2 mice are obsolete but are readily available second hand.

![screenshot](/img/screenshot3.png "ariane-0.7 release shapshot")
