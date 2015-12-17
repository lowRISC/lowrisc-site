+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Bootload procedure"
parent = "/docs/untether-v0.2/overview/"
prev = "/docs/untether-v0.2/pcr/"
next = "/docs/untether-v0.2/parameter/"
showdisqus = true

+++

**Note: the content of this section is subject to change as the specification develops.**

This document explains the procedure required to boot the RISC-V Linux port.

#### System status after power-on

After a hard (power off/on) reset, the whole SoC, including all PCRs are reset 
to their initial values:

 * **Pipeline**: Flushed.
 * **L1 I$**: Invalidated, PC <= `0x00000000_00000200`.
 * **L1 D$**: Invalidated.
 * **L2**: Invalidated.
 * **PCRs**: reset and interrupt disabled.


|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x00000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x7FFFFFFF`) | Mem   |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | (`0x00000000 - 0x0000FFFF`) | Mem   |
| > *DDR DRAM*             |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x8FFFFFFF`)   | (`0x80000000 - 0x8FFFFFFF`) | I/O   |
| > *UART & SD*            |  (`0x80000000 - 0x8001FFFF`)   | (`0x80000000 - 0x8001FFFF`) | I/O   |

#### Copy BBL from SD to DDR RAM

The actual bootloader for RISC-V Linux is a revised Berkeley bootloader (BBL)
located at `$TOP/fpga/board/$FPGA_BOARD/bbl/`.
The original BBL can be found at `$TOP/riscv-tools/riscv-pk/pk/`, which is still needed for running Spike simulations.
 
Since the size of BBL is larger than 64 KB (the size of the on-chip boot RAM), 
it is stored on an SD card and copied to DDR RAM during boot. An example 
program named 'boot' (`$TOP/fpga/board/$FPGA_BOARD/examples/boot.c`) is 
provided as the first stage bootloader. Please see [FPGA demo - Boot RISC-V 
Linux](../fpga-demo#boot) for more information.

Before copying the BBL to DRAM, it is necessary to map the DRAM to I/O space 
in order to bypass L1/2 caches. Otherwise, some parts of BBL may remain in 
caches and become lost when the first stage bootloader 'boot' resets the SoC 
to transfer control to the BBL. The mapping used for BBL copying should look 
like:

|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x00000000 - 0x3FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | (`0x00000000 - 0x0000FFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x0FFFFFFF`)   | (`0x80000000 - 0x0FFFFFFF`) | I/O   |
| > *UART & SD*            |  (`0x80000000 - 0x8001FFFF`)   | (`0x80000000 - 0x8001FFFF`) | I/O   |
| I/O section 1            |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | I/O   |
| > *DDR DRAM*             |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x40000000 - 0x7FFFFFFF`) | I/O   |

The BBL is then copied from SD to DDR DRAM starting from address `0x40000000`.

#### Soft reset

After copying the BBL to DDR, the first-stage bootloader maps the DDR RAM to 
boot memory. Consequently the on-chip BRAM is hidden.

|                          |  actual address spaces         | mapped address spaces       | Type  |
| ----------------------   | ------------------------------ | --------------------------- | ----- |
| Memory section 0         |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| > *DDR DRAM*             |  (`0x40000000 - 0x7FFFFFFF`)   | (`0x00000000 - 0x3FFFFFFF`) | Mem   |
| I/O section 0            |  (`0x80000000 - 0x0FFFFFFF`)   | (`0x80000000 - 0x0FFFFFFF`) | I/O   |
| > *UART & SD*            |  (`0x80000000 - 0x8001FFFF`)   | (`0x80000000 - 0x8001FFFF`) | I/O   |
| Other                    |                                |                             |       |
| > *On-chip BRAM (64 KB)* |  (`0x00000000 - 0x0000FFFF`)   | Hidden                      | N/A   |

Once the mapping is done, the first stage bootloader issues a soft reset:

 * **Pipeline**: Flushed.
 * **L1 I$**: Invalidated, PC <= `0x00000000_00000200`.
 * **L1 D$**: Invalidated.
 * **L2**: Invalidated.
 * **PCRs**: *Remain unchanged*.

#### BBL

BBL runs after the soft reset as DDR is now mapped to the boot address 
`0x00000200`. The major function of the BBL is to initialize all peripherals, 
set up the page table and virtual memory, load the Linux kernel from SD to 
virtual memory, and finally boot the kernel.

During the kernel execution, BBL continues running underneath the kernel as a 
hypervisor, serving all peripheral requests from Linux using the actual FPGA 
hardware.
