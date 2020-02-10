+++
Description = ""
date = "2018-01-12T13:00:00+00:00"
title = "Program the FPGA"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Program the bootloader on FPGA

Next, connect the USB cable, and turn on the FPGA board. Now you
can download the appropriate bitstream to the quad-SPI on the appropriate FPGA board, using one of the following:

    make nexys4_ddr_rocket_program
    make nexys4_ddr_ariane_program
    make genesys2_ariane_program
    make genesys2_rocket_program

The GenesysII board has two channels, only one of which connects to the JTAG. You may find that Vivado gets confused and tries
to connect to the wrong channel. If this happens open the Vivado GUI, and manually connect to the correct channel. This complexity
is generally not necessary with the Nexys4-DDR that has a simpler USB converter.

alternatively the QSPI memory may be directly targetted:

    make nexys4_ddr_rocket_cfgmem
    make nexys4_ddr_ariane_cfgmem
    make genesys2_ariane_cfgmem
    make genesys2_rocket_cfgmem

The QSPI memory has room for a Linux kernel and mini-root filing system as well as the bitstream.
This procedure is generally rather slow, so it should only be used once testing as shown above has established that the bitstream is usable.

At this point, you should check that the FPGA board switches are correct,

SW[3:0] controls the least-significant nibble of the Ethernet MAC address on Nexys4-DDR (on Genesys2 this value comes from OEM area)
SW[4] is reserved for Bluetooth loopback testing
SW[7:5] controls the boot mode according to the following:

    000: SD boot - the kernel comes from SD-Card memory
    001: QSPI boot - the kernel comes from QSPI memory
    010: DRAM test - the DRAM is tested and no booting occurs
    100: TFTP boot - the FPGA acts as a TFTP server and receives the kernel remotely
    110: Cache test - the cache test program runs and no booting occurs

The MODE jumper should always be in QSPI mode regardless, then press the PROG button.
