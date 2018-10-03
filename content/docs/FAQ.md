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

### What about support for other boards and RISCV processors ?

The KC705 support has not been maintained since the v0.3 release. However it is interesting because it allows for more expansion space, the possibility of dual core symmetric processing, and out-of-order cores such as BOOM (Berkeley out of order machine). Support for this board has not been merged with the refresh-v0.6, however development is ongoing on the kc705_mii branch.

The ArtyA7-A100 is a relatively recently released and very low cost board that has twice the memory of the Nexys4DDR. However it requires a separate PMOD (with reduced signal integrity), in order to support memory SD-Cards. The Ethernet PHY is a different type and development is taking place on the artya7_mii branch.

### What happened to the L2-cache ?

The L2-cache was retired with TileLink-1 when it was updated to TileLink-2. This was due to bugs in the multiprocessing support. No replacement L2-cache has been released by Berkeley Architecture Research since then.

### What is the Coremark performacne of LowRISC ?

LowRISC achieves 2.18 Coremarks/MHz, compared to 6.43 Coremarks/MHz for a core-i7-6700, and 2.32 for a Raspberry PI model B. Of course LowRISC at the moment is just an emulation, so the 50MHz clock rate is a bottleneck. Nevertheless useful work can be done, particularly in embedded and Internet-of-things type applications.


