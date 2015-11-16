+++
Description = ""
date = "2015-11-16T11:56:00+01:00"
title = "Bootload procedure"
parent = "/docs/untether-v0.2/overview/"
prev = "/docs/untether-v0.2/pcr/"
next = "/docs/untether-v0.2/parameter/"
showdisqus = true

+++

Here explains the procedure required to bootload a RISC-V Linux.

#### System Status after power-on

After a hard (power off/on) reset, the whole SoC, including all PCRs are reset to their intial values:

 * **Pipeline**: Flushed.
 * **L1 I$**: Invalidated, PC <= `0x00000000_00000200`.
 * **L1 D$**: Invalidated.
 * **L2**: Invalidate.
 * **PCRs**: reset and interrupt disabled.


|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x00000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x7FFFFFFF`) | Mem   |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | (`0x00000000 - 0x0000FFFF`) | Mem   |
| > *DDR3 DRAM (1 GB)*     |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x0FFFFFFF`)   | (`0x80000000 - 0x0FFFFFFF`) | I/O   |

#### Copy BBL from SD to DDR3

The actual bootloader for RISC-V Linux is a revised Berkeley bootloader (BBL). Since the size of BBL is larger than 64 KB (the size of available on-chip BRAM), it is stored on SD card and needed to be copied to DDR3 RAM. An example program named 'boot' (`$TOP/fpga/board/kc705/examples/boot.c`) is provided as the first stage bootloader. Please see [FPGA demo - Boot RISC-V Linux](../kc705#boot) for more information.

Before copying BBL to DDR3, it is neccessary to map DDR3 to I/O space and bypass L1/2 caches. Otherwise, some parts of BBL may remain in caches and become lost when the first stage bootloader 'boot' reset the SoC and tranmit control to BBL. The mapping used for BBL copying should looks like:

|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x00000000 - 0x3FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | (`0x00000000 - 0x0000FFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x0FFFFFFF`)   | (`0x80000000 - 0x0FFFFFFF`) | I/O   |
| I/O section 1            |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | I/O   |
| > *DDR3 DRAM (1 GB)*     |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | I/O   |

The BBL is then copied from SD to DDR3 DRAM starting from address `0x40000000`.

#### Soft reset

After copying BBL to DDR3, the first stage bootloader maps the DDR3 RAM to boot memory, consequently the on-chip BRAM is hidden.

|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| > *DDR3 DRAM (1 GB)*     |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x0FFFFFFF`)   | (`0x80000000 - 0x0FFFFFFF`) | I/O   |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | Hidden                      | N/A   |

Once the mapping id done, the first stage bootloader issues a soft reset:

 * **Pipeline**: Flushed.
 * **L1 I$**: Invalidated, PC <= `0x00000000_00000200`.
 * **L1 D$**: Invalidated.
 * **L2**: Invalidate.
 * **PCRs**: *Remain unchanged*.

#### BBL

BBL runs after the soft reset as DDR3 is now mapped to the boot address `0x00000200`. The major function of BBL is to initialize all peripherals, set up the page table and virtual memory, load the Linux kernel from SD to virtual memory and finally boot the kernel.

During the kernel execution, the BBL run underlying as a hypervisor, serving all peripheral requests from Linux using the actaul FPGA hardware.