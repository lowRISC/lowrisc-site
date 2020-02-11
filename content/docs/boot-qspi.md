+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Boot QSPI instructions"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Boot Linux using QSPI on FPGA

| SW[7:5]             | boot mode                  |
| --------------      | :----------:               |
| 001                 | boot from Quad-SPI memory  |

The QSPI memory is the fastest and most convenient memory fot bitstream loading. However it is relatively slow for programming so the TFTP method is more suitable for development. A limited space beyond the end of the bitstream is just enough to fit a kernel and basic ram-disk.
The functionality of this ram-disk is up to the user to customise but typically it would contain commands to check the SD-Card root filing system (btrfs check) or use a network such as aoe (ATA over Ethernet), nbd (network block device) or NFS-root on a previously allocated server. On Genesys2 systems an OEM (original equipment manufacturer) area also allows the allocated Ethernet MAC (media access controller) address of the board to be read. The SW[3:0] will not be used in this case. Nexys4DDR does not have this OEM area, by default a locally administered MAC address will be used. If the local site requires a specific range of MAC addresses, this can be customised in the source code of the boot loader. In many cases the configuration will be loaded at power up, if not press the appropriate reconfig button for your board. The switch settings above will take effect after bitstream configuration and before the Linux kernel is loaded.

    Hello from Ariane! Please wait a moment...
    Relocating to DDR memory
    Hello World!
    ...
    QSPI boot
    load QSPI to DDR memory
    load ELF to DDR memory
    00000000 7F 45 4C 46 02 01 01 00 00 00 00 00 00 00 00 00 
    ...
    Section[0]: elfn(80000000,0x1000,0x70c8);
    00000078 01 00 00 00 06 00 00 00 00 90 00 00 00 00 00 00 
    ...
    Section[1]: elfn(80008000,0x9000,0x1061);
    memset(80009061,0,0xa027);
    000000B0 01 00 00 00 04 00 00 00 00 00 20 00 00 00 00 00 
    ...
    Section[2]: elfn(80200000,0x200000,0x842f2c);
    Boot the loaded program at address 80000000...

culminating after numerous messages with:

    Debian GNU/Linux 10 lowrisc5.sm hvc0

    lowrisc5 login: 

This QSPI bootloader does not support random access. Furthermore it always reads single 64-bit words at a time, using a simplified version of the spi_mem_programmer Verilog RTL from Ilia Sergachev.

* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})

