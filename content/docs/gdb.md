+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC GDB usage"
parent = "/docs/"
prev = "/docs/_index"
next = "/docs/_index"
showdisqus = true

+++

This lowRISC release supports Rocket and Ariane CPUs with both support RV64GC API, allowing upstream Debian Linux distribution to be used. If using buildroot, everything is built from source so it can be customised for any API, for example a no-FPU API.

## RTL changes

Consult the JTAG page for the latest information. Rocket operation on Nexys4-DDR requires modification to the scan chain to avoid external hardware being required. GenesysII operation is possible without CPU modification using the second channel of the USB to JTAG/UART converter. Regardless of the method the openocd configuration file will require modification depending on the solution chosen. This page refers to Rocket debugging on the NExys4-DDR.

## Linux driver

The JTAG does not impact on Linux operation. Extra facilities are available if KGDB is compiled in and at the moment openocd requires different settings in order to behave correctly if the MMU is on.

## Remote debugging

For bare-metal debugging most users will find it convenient to just load the software inside GDB. The latest release of openocd does not listen to remote machines by default, so the machine that gdb executes should be the same as the openocd machine. A sample session may be launched with the command:

    make debug

The linked gdb session needs to be launched in a separate window, which should preferably be much larger than usual to provide room to conveniently display source code, register window and command prompt. The session might look like this:

    Licensed under GNU GPL v2
    For bug reports, read
            http://openocd.org/doc/doxygen/bugs.html
    Info : ftdi: if you experience problems at higher adapter clocks, try the command "ftdi_tdo_sample_edge falling"
    Info : clock speed 10000 kHz
    Info : JTAG tap: riscv.cpu tap/device found: 0x13631093 (mfg: 0x049 (Xilinx), part: 0x3631, ver: 0x1)
    Info : datacount=2 progbufsize=16
    Info : Disabling abstract command reads from CSRs.
    Info : Examined RISC-V core; found 1 harts
    Info :  hart 0: XLEN=64, misa=0x800000000014112d
    Info : Listening on port 3333 for gdb connections
    Info : Listening on port 6666 for tcl connections
    Info : Listening on port 4444 for telnet connections
    Info : accepting 'gdb' connection on tcp/3333
    Info : Disabling abstract command writes to CSRs.

## Target gdb support

RISCV support for gdb is managed by buildroot. If you want to use the tui mode that splits the screen between source and register windows (for example), buildroot does not build in support for xterm-256color. Use the command:

    export TERM=vt100

(which is a subset of xterm 256 colour support) to enable the tui support. Then use the command:

    make gdb

to launch a sample gdb session.

When the gdb prompt appears, use the command:

    target remote :3333

to connect to the remote openocd session that was launched in the previous paragraph above. Your session should look similar to the following:

    GNU gdb (GDB) 8.3.0.20190516-git
    Copyright (C) 2019 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "--host=x86_64-pc-linux-gnu --target=riscv64-buildroot-linux-gnu".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <http://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.

    For help, type "help".
    Type "apropos word" to search for commands related to "word"...
    Reading symbols from fpga/src/etherboot/nexys4_ddr_rocket.elf...
    (gdb) tar rem :3333
    Remote debugging using :3333
    main () at src/main.c:154
    154	  uint32_t sw = gpio_sw();
    (gdb) load
    Loading section .text.init, size 0x13d lma 0x87fe0000
    Loading section .text, size 0x5e38 lma 0x87fe0200
    Loading section .text.startup, size 0xba lma 0x87fe6038
    Loading section .rodata, size 0x1b18 lma 0x87fe6100
    Loading section .srodata, size 0x58 lma 0x87fe7c18
    Loading section .srodata.cst8, size 0x20 lma 0x87fe7c70
    Loading section .data, size 0x5 lma 0x87fe7d00
    Start address 0x87fe0000, load size 31684
    Transfer rate: 210 KB/sec, 3960 bytes/write.
    (gdb) break main
    Breakpoint 1 at 0x87fe6038: file src/main.c, line 154.
    (gdb) cont
    Continuing.

    Breakpoint 1, main () at src/main.c:154
    154	  uint32_t sw = gpio_sw();
