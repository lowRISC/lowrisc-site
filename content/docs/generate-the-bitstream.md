### Generate the bitstream

#### FPGA demo with Fpga (default bootloader)

Choose one of the following targets:

    make nexys4_ddr_rocket
    make nexys4_ddr_ariane
    make genesys2_ariane
    make genesys2_rocket

The generated bitstream is located at `fpga/work-fpga/nexys4_ddr_rocket/rocket_xilinx.bit` et al.
This will take some time (20-60 minutes depending on your computer).

### Program the bootloader on FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
can download the bitstream to the quad-SPI on the FPGA board:

    make nexys4_ddr_rocket_program
    make nexys4_ddr_ariane_program
    make genesys2_ariane_program
    make genesys2_rocket_program

alternatively the QSPI memory may be directly targetted:

    make nexys4_ddr_rocket_cfgmem
    make nexys4_ddr_ariane_cfgmem
    make genesys2_ariane_cfgmem
    make genesys2_rocket_cfgmem

The QSPI memory has room for a Linux kernel and mini-root filing system as well as the bitstream.

At this point, you should check that the FPGA board switches are correct,

SW[3:0] controls the least-significant nibble of the Ethernet MAC address on Nexys4-DDR (on Genesys2 this value comes from ROM)
SW[4] is reserved
SW[7:5] controls the boot mode according to the following:

000: SD boot - the kernel comes from SD-Card memory
001: QSPI boot - the kernel comes from QSPI memory
010: DRAM test - the DRAM is tested and no booting occurs
100: TFTP boot - the FPGA acts as a TFTP server and receives the kernel remotely
110: Cache test - the cache test program runs and no booting occurs

The MODE jumper should always be in QSPI mode regardless, then press the PROG button.

