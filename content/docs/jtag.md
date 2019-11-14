+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC JTAG internals"
parent = "/docs/"
prev = "/docs/_index"
next = "/docs/_index"
showdisqus = true

+++

This lowRISC release introduces refresh debugging and compressed instructions, allowing upstream debian Linux distribution to be used.

## RTL changes

The JTAG uses Xilinx built-in instruction register of 6 bits and available user data registers.
These data register numbers deviate from the RISC-V specification but otherwise conforms to the Berkeley Rocket standard.
This deviation eliminates the requirement for separate hardware to implement the debug interface and keeps costs low,
allowing the same board (Nexys4DDR) as previously to be used.
The impact on the Chisel is restricted to a small part which invokes BSCANE2 as a primitive.

| Function              | _Berkeley Rocket_ | _LowRISC Rocket_ |
| --------------        | :----------:      | :--------------: |
| Manufacturer code     |       all         |       0x49       |
| IR length             |         5         |          6       |
| IDCODE                |      0x01         |       0x09       |
| DTM_CONTROL           |      0x10         |       0x22       |
| DTM_DMI               |      0x11         |       0x23       |

This functionality needs to be supported with appropriate TCL which, in the case of Nexys4DDR will be:

    adapter_khz     10000
    interface ftdi
    transport select jtag
    ftdi_device_desc "Digilent USB Device"
    ftdi_vid_pid 0x0403 0x6010
    ftdi_channel 0
    ftdi_layout_init 0x0088 0x008b
    set _CHIPNAME riscv
    jtag newtap $_CHIPNAME cpu -irlen 6 -expected-id 0x13631093
    set _TARGETNAME $_CHIPNAME.cpu
    target create $_TARGETNAME riscv -chain-position $_TARGETNAME -rtos riscv
    riscv set_ir idcode 0x09
    riscv set_ir dtmcs 0x22
    riscv set_ir dmi 0x23

    $_TARGETNAME configure -work-area-phys 0x80000000 -work-area-size 10000 -work-area-backup 1

    init 
    halt

## Linux driver

The JTAG does not impact on Linux operation. Extra facilities are available if KGDB is compiled in and at the moment GDB still does not behave correctly if the MMU is on.

## User land operation

A complete suite of Linux user commands is available via the Debian Linux distribution for RISCV. There is no necessity for the distribution to be built from scratch.

## Remote debugging

For bare-metal debugging most users will find it convenient to just load the software inside GDB. The latest release of openocd does not listen to remote machines by default, so the machine that gdb executes should be the same as the openocd machine.
