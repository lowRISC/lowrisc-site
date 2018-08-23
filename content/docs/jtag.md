+++
Description = ""
date = "2018-01-11T11:00:00+00:00"
title = "lowRISC Refresh internals"
parent = "/docs/refresh-v0.6/"
prev = "/docs/refresh-v0.6/index/"
next = "/docs/refresh-v0.6/index/"
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

    interface ftdi
    ftdi_device_desc "Digilent USB Device"
    ftdi_vid_pid 0x0403 0x6010

    ftdi_channel 0
    ftdi_layout_init 0x0088 0x008b
    ftdi_tdo_sample_edge falling

    reset_config none
    adapter_khz 10000
    transport select jtag

    jtag newtap riscv cpu -irlen 6 -expected-id 0x13631093

    target create riscv.cpu riscv -chain-position riscv.cpu

## Linux driver

The JTAG does not impact on Linux operation. Extra facilities are available if KGDB is compiled in and it is not clear what the virtual memory approach will be in GDB at the moment.

## User land operation

A complete suite of Linux user commands is available via the Debian Linux distribution for RISCV. There is not necessity for the distribution to be built from scratch.

## Remote booting

All the booting methods of the previous release are possible but for debugging most users will find it convenient to just load BBL with Linux appended inside GDB.
