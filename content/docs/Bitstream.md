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

At this point, you should check the MODE jumper is in QSPI mode and then press the PROG button.

#### FPGA demo with Fpga (alternative boot programs)

    cd $TOP/fpga/board/nexys4_ddr
    make target (where target is mmc, dram, hello etc.)

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`.
First time through, this will take some time (20-60 minutes depending on your computer).

### Program the alternative boot programs on FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the quad-SPI on the FPGA board:

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

#### `make <hello|dram|eth|mmc>`
Generate bitstreams for bare-metal tests:

 * **hello** A hello world program.
 * **dram** A DDR RAM test.
 * **mmc** A 1st bootloader that loads `boot.bin` from SD to DDR RAM and executes `boot.bin` afterwards.

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
