### Generate the bitstream

#### FPGA demo with Fpga (default bootloader)

    cd $TOP/fpga/board/nexys4_ddr
    make cleanall
    make bitstream

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`.
This will take some time (20-60 minutes depending on your computer).

### Program the bootloader on FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the quad-SPI on the FPGA board:

    make cfgmem
    make program-cfgmem

At this point, you should check that the FPGA board switches are initially all off (except SW2),
and the MODE jumper is in QSPI mode and then press the PROG button.

### Sample output (assuming Ethernet cable connectivity is sane)

The default bootloader assumes an Ethernet DHCP server is present, if so you should see a result similar to this:

    Calling main with MAC = eee1:4
    Selftest iteration 1, next buffer = 13, rx_start = 6800
    Selftest matches=2/2, delay = 11
    Selftest iteration 2, next buffer = 14, rx_start = 7000
    Selftest matches=4/4, delay = 11
    Selftest iteration 3, next buffer = 15, rx_start = 7800
    Selftest matches=8/8, delay = 12
    Selftest iteration 4, next buffer = 0, rx_start = 4000
    Selftest matches=16/16, delay = 22
    Selftest iteration 5, next buffer = 1, rx_start = 4800
    Selftest matches=32/32, delay = 41
    Selftest iteration 6, next buffer = 2, rx_start = 5000
    Selftest matches=64/64, delay = 80
    Selftest iteration 7, next buffer = 3, rx_start = 5800
    Selftest matches=128/128, delay = 159
    Selftest iteration 8, next buffer = 4, rx_start = 6000
    Selftest matches=187/187, delay = 231

This first bit establishes that digital loopback of the Ethernet is working. If this does not appear, search your build log for timing errors.

    0: 0
    1: 1
    2: 1
    3: 1
    800: 1e
    801: 0
    802: 0
    803: 0

This bit is just probing the platform level interrupt controller with some default values.

    lowRISC etherboot program
    =====================================
    MAC = eee1:4
    MAC address = ee:e1:e2:e3:e4:e4.
    eth0 MAC : EE:E1:E2:E3:E4:E4

This section is concerned with setting the MAC address, and reading it back. The least significant value read will depend on SW[15:12]

    Sending DHCP_DISCOVERY
    Waiting for DHCP_OFFER
    Sending DHCP_REQUEST
    DHCP ACK
    DHCP Client IP Address:  128.232.60.123
    Server IP Address:  128.232.60.8
    Router address:  128.232.60.1
    Net mask address:  255.255.252.0
    Lease time = 43200
    domain = "cl.cam.ac.uk"
    server = "lowrisc4-sm"

#### FPGA demo with Fpga (alternative boot programs)

If you already have a compiler installed, using either the quickstart process, or using this page:

* [Developing BareMetal tool chain] ({{< ref "docs/build-bare-metal-toolchain.md">}})

You can proceed to compile the alternative boot programs/bare-metal programs

Otherwise is suggested you proceed to the link below (or for development purposes, checkout the alternative targets)

* [Configure DHCP] ({{< ref "docs/dhcp-configuration.md">}})

To compile, alternative programs:

    cd $TOP/fpga/board/nexys4_ddr
    make target (where target is boot, dram, hello etc.)

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`.
First time through, this will take some time (20-60 minutes depending on your computer).

### Program the alternative boot programs on FPGA

There is a choice of programming volatile or non-volatile. Volatile programs are relatively fast
to download, but naturally are lost when powered down (or overwritten, due to a bug).

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the quad-SPI on the FPGA board:

proceed with this command, for a volatile download:

    make program-updated

or these commands for a permanent download:

    make cfgmem-updated
    make program-cfgmem-updated

## Other useful Makefile targets

#### `make project`
Generate a Vivado project.

#### `make verilog`
Run Chisel compiler and generate the Verilog files for Rocket chip.

#### `make vivado`
Open the Vivado GUI using the current project.

#### `make bitstream`
Generate the default bitstream according to the `CONFIG` in Makefile and the program loaded in `src/boot.mem`. The default bitstream is generated at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`

#### `make <hello|dram|eth|boot>`
Generate bitstreams for bare-metal tests:

 * **hello** A hello world program.
 * **dram** A DDR RAM test.
 * **boot** A 1st bootloader that loads `boot.bin` from SD to DDR RAM and executes `boot.bin` afterwards.

For each bare-metal test `<test>`, the executable is generated to 
`examples/<test>.riscv`. It is also converted into a hex
file and copied to `src/boot.mem`, which then changes the default program for 
`make bitstream` and `make simulation`. The updated bitstream is generated at 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <program|program-updated>`
Download a bitstream to FPGA. Use `program` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`program-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <cfgmem|cfgmem-updated>`
Convert a bitstream to the format suitable for quad-SPI flash on the FPGA board. Use `cfgmem` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`cfgmem-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <program-cfgmem|program-cfgmem-updated>`
Download a bitstream to quad-SPI flash on the FPGA board. Use `program-cfgmem` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`program-cfgmem-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <clean|cleanall>`
`make clean` will remove all generated code without removing the Vivado 
project files. To remove all files including the Vivado project, use `make 
cleanall`.
