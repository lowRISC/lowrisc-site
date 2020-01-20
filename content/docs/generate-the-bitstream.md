### Generate the bitstream

#### FPGA demo with Fpga (default bootloader)

Choose one of the following targets:

    make nexys4_ddr_rocket
    make nexys4_ddr_ariane
    make genesys2_ariane
    make genesys2_rocket

The generated bitstream is located at `fpga/work-fpga/nexys4_ddr_rocket/rocket_xilinx.bit` et al.
This will take some time (20-60 minutes depending on your computer).

Continue the process below:

* [Flash the SD-Card] ({{< ref "docs/flash-the-SD-Card.md">}})
