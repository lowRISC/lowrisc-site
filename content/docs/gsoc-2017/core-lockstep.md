+++
Description = ""
date = "2017-10-05T19:30:00+00:00"
title = "GSoC 2017 student report: Core lockstep for minion cores"
+++

*Nikitas Chronas*

## Introduction

The upgraded role of [CubeSats](https://en.wikipedia.org/wiki/CubeSat), fueled 
by technological advances and lowered launch costs in the aerospace industry, 
has opened access to space for a wider audience. Space is a harsh environment 
for microelectronics - radiation induced Single Event Upsets can trigger bit 
flips in memory that could have catastrophic consequences, rendering a CubeSat 
useless. The two main options for fault tolerance are to either select from a 
limited range of expensive Rad-Hard electronics or to use Commercial 
Off-The-Shelf electronics that offer little protection. This project modifies 
the minion core subsystem lowRISC SoC, employing the
[Core Lock Step](https://en.wikipedia.org/wiki/Lockstep_(computing)) (CLS) 
fault tolerant technique by integrating a CLS assist unit in order to be 
suitable for use in a CubeSat mission.

## Work summary

Here is a short summary of the work that was completed during the [Google 
Summer of Code](https://developers.google.com/open-source/gsoc/) (GSoC) 2017,
along with the repository branches.

I ported the minion subsystem to work with the 
[Verilator](https://www.veripool.org/wiki/verilator) simulator, and with 
Digilent's inexpensive 
[Arty](https://reference.digilentinc.com/reference/programmable-logic/arty/start) 
FPGA board, then created a simple C program that would run in the above. The 
[minion_minimal](https://github.com/nchronas/minion_subsystem/tree/minion_minimal) 
has the C example. These ports are available in the 
[arty](https://github.com/nchronas/minion_subsystem/tree/arty_2) and
[verilator](https://github.com/nchronas/minion_subsystem/tree/verilator) 
branches, and have been submitted for merging in to the master branch. The 
[jinja_generation](https://github.com/nchronas/minion_subsystem/tree/jinja_gen) 
branch contains the code generation project described later in this document.

During the Core Lock Step implementation, I identified and made some 
improvements in the SoC codebase. The 
[coremem_cleanup](https://github.com/nchronas/minion_subsystem/tree/coremem_cleanup) 
branch was merged upstream, and improves the coremem module by removing 
unreached states in the code and removing duplicate code. The 
[minion_peripherals](https://github.com/nchronas/minion_subsystem/tree/minion_peripherals) 
branch is an attempt to clean up and improve clarity for the SoC's custom bus, 
but has yet to be merged.

The 
[core-lockstep-codegen](https://github.com/lowRISC/minion_subsystem/tree/core-lockstep-codegen) 
branch contains the majority of the work from over the summer in a form 
readyto be used. It includes the `minion_minimal`, arty, verilator, core lock 
step and code generation work. Different variations of the SoC can be 
generated based on included configs.

The 
[core-lockstep](https://github.com/lowRISC/minion_subsystem/tree/core-lockstep) 
branch contains a core lock step configuration that could be used with an 
otherwise unmodified version of the minion core subsystem. It was primary 
developed as a showcase for the code.

The following repositories contain early versions of the previous designs and 
are only included for reference.
[minion_verilator](https://github.com/nchronas/minion_subsystem/tree/minion_verilator) 
contains the first versions for the Arty and Verilator ports as well as
assembly and C example programs. Forked from the minion verilator branch, the 
[minion_CLS](https://github.com/nchronas/minion_subsystem/tree/minion_CLS) has 
the first prototypes of the CLS configuration.

## Setting up the environment

All the work was done in a virtual machine based on ubuntu 16.04 LTS and a 
Vivado 2015.4 64bit install with Free webPACK licence. The project uses the 
programs reccomended by other lowRISC documentation. I had some issues while 
installing all programs but it wasn’t anything that wasn't easily resolved.
More information can be found 
[here](https://www.lowrisc.org/docs/minion-v0.4/environment/).

### Verilator

Verilator was installed based on these 
[instructions](https://www.veripool.org/projects/verilator/wiki/Installing), 
as recommended by the lowRISC 
[documentation](https://www.lowrisc.org/docs/untether-v0.2/verilator/). I used
GTKWave for viewing the waveforms generated from verilator, installed using 
`apt-get`. Verilator needed the following environment variables in order to 
run:

    export PATH=$PATH:$VERILATOR_ROOT/bin
    export VERILATOR_ROOT=/path_to_folder/verilator

### Vivado

A guide about installing Vivado can be found in lowRISC documentation. One 
difference from that guide is that in my installation that I used the 
following command `source 
/local/tool/Xilinx/Vivado/2015.4/.settings64-Vivado.sh`. It's generally a 
pretty straightforward installation but took a while to finish.

### Arty

While this is not needed in order to run the project, I think it might be 
helpful. In order to use the Arty board in Vivado for a new project, this 
[guide](https://reference.digilentinc.com/learn/software/tutorials/vivado-board-files/start) 
should be followed.

### Compiler

The PULPino-derived minion core uses a patched GCC compiler, found 
[here](https://github.com/pulp-platform/ri5cy_gnu_toolchain). The repository 
has sufficient instructions. You could either create a symlink in `/usr/bin` 
or add an appropriate directoy to your `$PATH`.

### Minion SoC

The code for the minion SoC can be found in the lowRISC minion subsystem 
[repository](https://github.com/lowRISC/minion_subsystem). The branch that all 
my work is derived from is the minion-v0.4. Clone either the lowRISC 
repository or my [fork](https://github.com/nchronas/minion_subsystem). For 
cloning the repository, git should be installed.

In order to compile software for the minion SoC, the romgen program must be 
compiled. romgen uses OCaml, so it has to be installed in the system in order 
to compile it (install using `apt-get install ocaml`).

### Code generation

The code generation project uses python 2.7 and the jinja2 templating engine.
Jinja is installed by simply running (sudo) `pip install jinja2`.

## Running the examples

<iframe src="https://giphy.com/embed/l378u8meC0uNts7HG" width="480" height="334" frameBorder="0" class="giphy-embed" allowFullScreen></iframe>

*Arty example program*

After preparing the environment, the following steps are required to run the 
examples:

1. First we must select the correct code. Go the `minion_subsystem` folder and 
switch to the core-lockstep-codegen branch using `git checkout 
core-lockstep-codegen`
2. The generator will produce the files needed depending on the config used.
Go to the `socgen` folder and run `python generator.py config`. In the place 
of config select the predefined configs found in the conf folder or make a 
custom. Note that the argument in the generator should have the conf folder as 
well. E.g. `python generator.py conf/cls_config.json`. There are 4 
configuration files found in the folder, please select the one you like.
    1. The `minion_config` file has the parameters for generating the 
    equivalent of the minion-v0.4. This config can’' be used with verilator.
    2. At the moment the verilator can only be used with the GPIO and UART 
    peripherals. This `verilator_config` file generates a minion SoC for use 
    in verilator.
    3. The `cls_config` generates the SoC with core lock step and identical 
    configuration with the minion-v0.4. Again this config can't be used with 
    verilator.
    4. The `cls_finj_config` file generates the SoC with fault injection 
    functionality, used in testing.
3. We now compile the examples running in the minion SoC. The examples are in 
the `software/minimal` and `software/minimal_cls`  folder. Compile the minimal 
C and minimal C CLS examples by running make inside each folder. If everything 
works ok, the `code.v` and `data.v` files should have been created.
4. For running verilator, the following steps are required.
    1. This step is not necessary but it will make simulation a lot quicker by 
    shortening the delay time. Replace `REAL_DELAY` with `SIM_DELAY` found in 
    the delay function in the minion.c file and recompile the software.
    2. Next the verilator simulator is compiled. Go to the vsim folder and run 
    `make` to simulate the minion SoC without CLS. Running `make cls` will 
    produce the simulation for the CLS configuration and finally `make finj`
    will be used for CLS with fault injection. Note that the configuration has 
    to match the `make` command used. e.g. configuring the SoC without CLS 
    while compiling verilator with cLS will result in an error.
    3. Start the simulation by running `./run_sim.sh.` If the configuration is 
    "finj" the simulation will provide a simple menu for triggering the fault 
    injection. Stop the simulation by using ctrl+c.
    4. You can view the waveforms generated from the simulation by running 
    `gtkwave obj_dir/verilated.vcd`
5. For uploading the program to the FPGA, follow these steps:
    1. Start vivado and select the project found in 
    `vivado/minion_top_arty.xpr`.
    2. Some Xilinx IPs are not included in repository and the user would have 
    to create them.
        1. If the minion SoC configuration has the SD peripheral, you will 
        need to create the clock wizard. The necessary information for 
        generating the IP are found in the port section.
        2. If fault injection with the vio parameter is used, the VIO module 
        should be created with the following parameters: `name: vio0` and one 
        output port with 1 bit width.
    3. Select the software (`minimal` vs `minimal_cls` you want to run on the 
    SoC by changing the `code.v` and `data.v` files.
    4. Select the Generate bitstream command in Vivado. Note that this process 
    might take a while (~10 minutes in my computer).
    5. For uploading the bitstream to the Arty you have 2 options: either 
    upload it through JTAG or store it in the onboard flash memory. For 
    details on how to do this, see the guide from Digilent 
    [guide](https://reference.digilentinc.com/learn/programmable-logic/tutorials/arty-programming-guide/start) 
    (after step 2.8).
6. Enjoy!

A note for Vivado and Arty: programming the FPGA in the virtual machine was 
sometimes unstable. When there was an issue I simply restarted the virtual 
machine.

<iframe src="https://giphy.com/embed/26vIg6cZFMWvi6AbS" width="480" height="401" frameBorder="0" class="giphy-embed" allowFullScreen></iframe>

## Minion SoC

This section contains information for understanding the minion SoC. An 
[overview](https://www.lowrisc.org/docs/minion-v0.4/overview/) on how the
minion connects with the rocket core and some complementary 
[information](https://www.lowrisc.org/docs/minion-v0.4/minion/) about the SoC
can be found in the lowRISC documentation.

### Project structure

The `minion_subsystem` has the following directory structure: `software` holds 
the software for the minion. The `pulpino` folder has all the HDL files for 
the PULPino core. The `verilog` folder contains additional verilog code used 
from the minion subsystem. The `vivado` has all the related files that are 
used from the Vivado suite. The `romgen` folder has the code for the rom 
generation software. The project uses OCaml and takes the binaries generated 
from the C compiler then incorporates them in to verilog files in a form that 
can be used from the tools.

In the `software` folder, the `hello` project will output a message through 
the UART but unfortunately currently doesn’t generate the `code.v` and 
`data.v` files for use in a FPGA. The bootstrap project has all the 
functionality, used from the Rocket core and the lowRISC SoC.

One of the most important files is `minion_soc.sv`. It has all the code for 
integrating the core with the RAM/ROM and the peripherals, thus creating the 
SoC.

The CLS code generation branch has some extra folders. The `socgen` folder is 
for the code generation project. The software has the `minimal` C and 
`minimal_cls` C projects and finally the vsim folder has the all the files for 
the verilator.

### Core

The core is a modified PULPino core, which might be compared to the ARM 
Cortex-M4. The upstream PULPino uses an AXI bus to communicate with the 
memories and peripherals as opposed to the minion SoC has a custom tightly 
coupled bus. Moreover the minion doesn't support yet a debug interface. For 
more information about the core you can check the 
[PULP-platform](http://pulp-platform.org/) site.

The core has a separate instruction and data bus, with the only difference 
being that the data bus has write functionality. The protocol is very simple.
The bus has the standard clock, address, the incoming read data and the 
outgoing write data. The core starts a transaction by setting the appropriate 
values in the bus and issues a request. The peripheral responds with a grant 
signal when it has accepted the values. When the grant signal is set, the core 
can change the signals for the next transaction. When the peripheral has 
finished processing the transaction it issues the data valid flag.

<img src="pulp.png" style="width: 600px"/>
*PULPino data bus transaction (image taken by the PULPino user manual)*

### Coremem

The coremem module is used to for handing all interactions between the core 
and memories. Since PULPino has 2 buses, the module is used twice, one for the 
ROM and one for the RAM and peripherals. The coremem essentially generates the 
CE and the WE signal if it is a write operation, when there is a request from 
the core and waits for one cycle until it sets the grant and valid signal.

The coremem design assumes that all peripherals are able to write the data in 
one cycle. If a new peripheral needs more cycles to finish the operation, the 
coremem should be modified, to introduce the extra cycles.

### Bus

The minion SoC uses a custom tightly coupled bus for communication of the core 
with the peripherals and the memories. For the core's instruction bus, the ROM 
is directly connected with the `coremem_i` module that handles the protocol 
handshakes.

The bus addresses are taken from the 4 MSBs of the data bus addresses in one 
hot configuration, creating 16 distinct memory regions. Each of the 16 memory 
regions are mapped to each peripheral and memories.

The peripherals and memories use the `one_hot_rdata[15:0]` array where each 
position is related with the equivalent address, to store the preselected 
information. That way the peripheral's SFRs (special function registers) are 
created. The read operation and bus address creation happens in a 
`always_comb` block  The 16 loops in the for loop correspond to the 16 bus 
addresses. The address is created when `core_lsu_addr[23:20]` is equal to the 
address number. Finally the correct read data is stored in `core_lsu_rdata`, 
selecting the `one_hot_data_addr` array element that is equal to the bus 
address.

Writing operations are triggered when the `we_d` signal is set, along with the 
corresponding `one_hot_data_addr`. The peripheral write operations happens in 
the following always block that is triggered in a reset or a positive cycle 
edge. If a reset is set, the SFRs take a default value.

<center>
<table>
  <tr>
    <td>Type</td>
    <td>Memory region</td>
    <td>Bus address</td>
  </tr>
  <tr>
    <td>ROM</td>
    <td>0x000000</td>
    <td>0</td>
  </tr>
  <tr>
    <td>RAM</td>
    <td>0x100000</td>
    <td>1</td>
  </tr>
  <tr>
    <td>UART</td>
    <td>0x200000</td>
    <td>2</td>
  </tr>
  <tr>
    <td>SD</td>
    <td>0x400000</td>
    <td>4</td>
  </tr>
  <tr>
    <td>GPIO (LED, DIP)</td>
    <td>0x700000</td>
    <td>7</td>
  </tr>
  <tr>
    <td>PS2</td>
    <td>0x900000</td>
    <td>9</td>
  </tr>
  <tr>
    <td>VGA</td>
    <td>0xA00000</td>
    <td>10</td>
  </tr>
</table>
</center>

In order to modify the bus and add more memory regions, the user should change 
the width of the `one_hot_data_addr` keeping it equal to `one_hot_rdata`, 
adding more MSBs of `core_lsu_addr` to the `one_hot_data_addr` address 
generation, and modify the for loop generation. All changes should happen in 
multiples of 2. Since the RAM and ROM locations are hardwired to the C linker 
scripts, extra care should be taken that the RAM and ROM hold the same memory 
region. Of course any modification in the memory locations should be reflected 
in the software and the SFRs addresses.

### Memories

The SoC uses one RAM to hold variables and a ROM to hold the program running.
The implementation lies in `code.v` and `data.v` and it's generated by the 
compiled program, using the romgen software. The implementation is based on 
Xilinx block ram specific modules.

### Peripherals

The minion SoC has the following peripherals integrated:

1. UART.
2. PS2.
3. SD card controller.
4. VGA.
5. GPIO (LED, DIP switches).

All the peripherals are used from the rocket core. In my project there wasn't 
a need to use the peripherals besides the UART and LEDs.

The GPIO operation is pretty straightforward. There is a SFR that you can 
write the LED values and there is a SFR that reads the DIP values.

There are 3 SFRs for the UART.

1. A status SFR that has information about the state of the UART, plus the 
value of an incoming byte.
2. A SFR that holds the value for baud rate generation.
3. The Tx byte SFR.

A Tx operation happens when the Tx value is sent to Tx SFR and if the UART is 
not currently transmitting. For a Rx operation, the UART has a FIFO connected 
to the Rx line. The read operation is triggered by making a write operation in 
the status SFR. When that happens the FIFO stores the value in the 8 LSBs of 
the status SFR.

The baud rate calculation uses the following equation: `SFR value = clock 
frequency/ (baud rate * 4)`. For the arty project there is a 25MHz frequency 
and a 9600 baud rate, so the equation is `SFR value = 25.000.000 / (9600 * 4) 
= 651`.

## Modifications

During the designing phase of the CLS configuration, I identified some 
improvements that could be made to minion SoC.

### Coremem

While examining the coremem module, I saw that the code had unreached states 
(`WRITE_DATA`, `WRITE_ADDR`) because of constant assignment of the 
`aw_ready_i`, `ar_ready_i`, and `w_ready_i` signals. The states could be 
further reduced from the `READ_WAIT` and `WRITE_WAIT` states to just `WAIT` 
but I left it that way because I think code is more readable. Removing the 
unnecessary code simplified the module, which was then reduced to a simple one 
cycle delay.

Moreover it was found in multiple places in the `minion_soc`, that the 
`core_lsu_req` and `core_lsu_we` signals were used to access a peripheral in 
the case of a data bus write. That functionality was identical with the use of 
the `coremem_d`'s signal `we_d`. So all the signals were replaced with the 
`we_d` signal. That modification gives a clearer code, with the write of 
peripherals trigged only from one place.

### UART status

The UART status SFR (memory location 0x300000) has a lot of information about 
the state of the UART. This included the `uart_wrcount` variable that shows 
the number of the incoming bytes stored in FIFO. In my opinion the number of 
available bytes in the FIFO is much more important information. The 
`uart_rdcount` shows the number of bytes that are read from the software. I 
replaced `uart_wrcount` with `uart_rdata_avail` which holds the available 
bytes in the FIFO. The information is taken by subtracting `uart_wrcount` and 
`uart_rdcount`.

### Peripheral modularisation.

The SoC uses a custom tightly coupled bus for the connection not based on AXI.
`minion_soc.sv` holds the bus implementation and code to connect the core with 
the RAM, ROM and the peripherals used. This makes the code less clear and more 
difficult add new peripherals. I made an attempt to separate the bus logic and 
the peripherals from the minion SoC, so the code is more clear and for me to 
better understand the bus logic. This attempt provided useful information that 
was eventually used in the code generation. In my opinion this approach lead 
to more clear and concise code.

The peripheral bus has the bus address, `bus_write` and `bus_read` array, 
which have the same functionality as the original bus signals. The extra 
`bus_we` and `bus_ce` arrays are added. The variables are used to signal a 
read or write operation in the bus. Each peripheral must access the 
corresponding `bus_we` and `bus_ce` by selecting the correct array member. The 
peripherals are then responsible for reading or writing the correct SFR based 
on the bus address.

The memconfig module (the naming could had been better) has all the bus 
functionality and is responsible for the core and peripheral interaction. The 
module generates the `bus_we` and `bus_ce` signals. The module also integrates 
`coremem_d`, the module that handles the core's data bus operations. The 
signals are generated in a similar way to the data read signals in the core's 
data bus.

Note that this code was left unfinished so it is possible that it contains 
bugs. In the future this work could be merged with the code generation in the 
form of templates.

## Software

This section describes the software developed to run on the minion SoC.

### Minimal assembly

For the first experiments with the platform, I created an assembly program.
The reasons behind using assembly:

1. Learning assembly gives you a better understanding of the architecture.
2. For easy programs, such as the one I created, the manually written assembly 
code is significant less complex than the equivalent produced from a compiler.
3. The lack of a JTAG module lead to most of the debugging happening through 
the studying of waveforms and hex values.  Being familiar with the assembly 
program and the assembly structure made debugging a lot easier.
4. It was a lot easier to setup the environment for the assembler than the 
compiler.

The first experiment was to examine the inner workings of the SoC and if 
everything was ok. For that reason a very simple program was loaded in the 
simulator. The program binary was loaded by hand, using the initial function 
of verilog, in the `mem_tb` module. The program did a continuous increment on 
the values of the `x1` register. Using the signals generated from the 
simulation, I was able to verify correct operation by looking into the 
instruction and data bus signals.

    _start:
      nop
      addi x1, x1, 1
      nop
      nop
      j _start

Finally I wanted to see if my understanding of the core and peripherals 
connection was correct. For that reason I made a simple program that transmits 
a "Hello minion" message through the UART and then blinks the LEDs. The 
program is very simple, it first loads SFR and RAM variables memory addresses 
into registers. Those registers will be used later to access the contents of 
the SFR's through indirect memory addressing. The `_print_str` loop transmits 
the message, the `_loop` blinks the LEDs and after that `_delay` loops for 
~100ms. You can find the code 
[here](https://github.com/nchronas/minion_subsystem/blob/01475229ce16e7232b76e183a83fb275c206d63a/software/asm_test/test.asm).

One of the most confusing issues that I had to face was to get used to how the 
memory locations were calculated in progmem. The instruction bus address to 
progmem ignores the 2 LSB bits (i.e. uses `core_instr_addr[15:2]`). So any 
memory inside the progmem would be stored in an address shifted by 2 in order 
to correspond to the address request from the core e.g. The core's boot 
address is 0x80 memory location, the instruction hex value had to be stored in 
the 0x20 memory location inside the progmem.

### Minimal C

In v0.4 of the minion subsystem there isn't a minimal C program for the users 
to base and build their own program. In my case I needed a minimal C program 
to use in testing and verification for the changes that I made in the minion 
SoC, both in simulation and in the actual hardware. For those reasons I 
created a minimal C program. Also the program was designed with the intention 
to be easily understood and used from beginners. The bootstrap and hello 
software couldn't be used for that purpose because a) bootstrap has a lot of 
functionality used from the rocket core b) the hello example doesn't produce 
the code and data verilog files that are needed to run the software in the 
minion SoC. Also the project contains a lot of files that are not necessary 
used from the program and that could be confusing to a beginner.

The program blinks the Arty LEDs, outputs the "hello minion" string in the 
UART after the reset, echoes a received character in the UART and sends a 
message if a button is pressed through the UART. In the Verilator simulation, 
a UART test bed was used and the minion SoC module was modified so that it 
would output the actions in the simulation terminal.

The necessary files to compile, link and use the software in the minion SoC 
were copied from the `hello` software. The `bootstrap` makefile was used as a 
template for the project and modified for use with the minimal C files.

The `minimal.c` file of the minimal program is very simple. It calls functions 
defined in the minion library. The minion library is a very primitive HAL for 
the minion SoC. The functions for the LED and the UART operation, were taken 
from the `minion_lib` library, found in the `hello` program. The functions 
were slightly modified by adding a preprocessor definition for the 
peripheral's SFRs addresses, so the code is more clear to the user. The 
functions are pretty self explanatory: The `to_led()` function outputs the 
data value to the LEDS and `from_dip` returns the switches value. The blocking 
functions `uart_recv()` and `uart_send()` receives/sends a byte to the UART.
`uart_send_buf` outputs the contents of a buffer. The `uart_bytes_available()` 
function returns the available bytes in the Rx FIFO. This function is used in 
conjunction with `uart_recv` only when there is available bytes in the Rx FIFO 
so it won't block the main routine waiting for an incoming byte. `uart_init()` 
calls `uart_set_baud` which sets the UART baud rate to 9600.  In this version 
the value 651 for setting the baud rate is calculated by hand. Finally
`uart_tx_status` returns the Tx status of UART. A delay function was added 
with a approximate delay of 200ms. The delay is used from the example in order 
to make the change in the LEDs visible to the human eye. The `utilities.c` 
file holds empty functions, needed from the linker script.

A future expansion of the example could use the rest of the available 
peripherals in the minion SoC.

### Minimal C CLS version

The minimal C CLS version has the same functionality with the minimal C but 
with a few modifications for the CLS configuration. The `i` variable is used 
for keeping the LED value even after a CLS triggered reset. During a reset all 
variables are initialized to zero. This operation is overridden by defining 
the `i` variable as a pointer and selecting the memory address by hand. The 
chosen memory location must be far away from the rest of the variables so it's 
not overridden by accident. In a normal reset the variable should be 
initialized to 0. The `reset_source` function returns if the reset triggered 
from a CLS fault or from the general reset so it would initialize the 
variable. This solution is a bit hacky and in the future the linker script 
should be modified in order to incorporate this functionality.

## Ports

The minion subsystem in the minion-v0.4 version didn't supported the Arty FPGA 
board or any support for a simulator. In order to run the code I needed to 
port them myself.

### Verilator

There were 2 main options for a simulator, the integrated simulator in the 
Vivado suite and verilator. While the Vivado simulator would have been the 
easier choice to use, the Vivado suite itself requires many CPU resources that 
made the use in a virtual machine difficult. The other reason to use verilator 
is for consistency with Rocket, which also uses verilator for simulation. The 
use of verilator could enable a future integration of the minion SoC in the 
rocket core simulation. In v0.4 of the lowRISC SoC, the minion SoC behaviour 
in the simulation is emulated by test bed files. Also verilator uses C++ that 
I'm familiar with.

The rocket core verilator project was used as a template for porting into the 
minion SoC. The `Makefile` was modified in order to select the verilog files 
used from the minion SoC. Most of the work was to identify which files were 
actually used in the pulpino core.

The minion SoC uses some modules that are Xilinx specific. The `FIFO18E1.v` 
file had the simulation implementation of the FIFO modules used. The file was 
taken from the Vivado installation. The `progmem` and `datamem` modules were 
using Xilinx modules that I couldn't locate. The modules functionality were 
identical, also they were simply enough to recreate in a testbed module.
Moreover using Verilog's `$readmemh()` function I was able to easily load the 
minimal C example running in the minion core. For the rest of the modules, 
dummy testbed modules were added in to `xilinx_tb.v`.

Again the rocket core simulation module was used as a template for the 
`veri_top.cc`. The original file was stripped away so it would have the 
minimal needed functionality for the minion SoC. Also the `top` signals were 
modified to reflect the signals used in the minion SoC. The global library 
files were directly copied into the project.

Running `make` in the `vsim` folder triggers the verilator program 
compilation. If everything is ok, the required files are stored in the 
`obj_dir` folder.

The `run_sim` script is used to start a simulation. Every signal is saved in a 
VCD file during the simulation. After the simulation is finished, the minion 
SoC's behaviour can be studied by viewing the generated waveforms, running
`gtkwave obj_dir/verilated.vcd`. Moreover the verilog `$display()` function 
was used to display debug messages during the simulation.

### Arty

The `nexys4ddr` project was used as a template for the arty port. A new vivado 
project was created for the Arty port of the minion SoC. During The board 
files needed for vivado to support Arty, were imported by following the 
digilents guide found here. Again as in the verilator port, the most difficult 
task was to find which files were actually used from the minion SoC. That 
process was found through trial and error.

The Xilinx clock IP (`clk_wiz_arty_0`) was added in the design, the wizard 
creates the clocks needed for the minion SoC, based on the parameters taken 
from `nexys4ddr`. The `pin_plan_arty` constraint file was based on one from 
Digilent's github and modified so that it has all the information needed to 
map the I/O pins of the FPGA to the minion SoC design. Finally The 
`top_arty.sv` file connects the minion SoC with the clocking wizard and only 
the I/O pins used from the arty. Using the top arty file enables different 
configurations for each board port, without needing to modify the `minion_soc` 
file, thus keeping it identical for all boards.

The Arty and the Nexys boards have different resources available, so the 
mapping is slight different. The 8 LEDs of the Nexys were mapped to the RGB 
LEDs of the Arty. The reset is mapped to the reset button of the Arty. The 
UART Rx and Tx was mapped to the onboard FTDI USB to serial converter. The 
Arty doesn't include onboard a SD card, VGA and PS2 peripheral so the pins are 
not mapped in the arty port. Digilent offers those peripherals in the form of 
PMOD extension boards, that can be used with the arty. In the future the port 
could be easily expanded to include the rest of the peripherals with the 
PMODs. The only reason that the PMODS weren't included in the design from the 
beginning was that board wouldn't have arrived on time for me to use them.

The project uses the `code.v` and `data.v` files from the minimal C example.
The files are not included in the repository so the user would have to either 
compile the project or his own project.

The SD peripherals clock wizard (`clk_wiz_1` `sd_clk_div`) is not included in 
the repository, so the user would have to either add it themselves or if the 
SD peripheral is not used, remove the IP's code in the minion SoC and directly 
assign the minion SoC clock to the SD clock: `assign msoc_clock = sd_clk_o`.
A slightly more difficult solution, if the user doesn't want to use the SD 
peripheral, is to remove all SD functionality in the minion SoC.

<center>
<table>
  <tr>
    <td align="left">Component name</td>
    <td>`clk_wiz_1`</td>
  </tr>
  <tr>
    <td align="left">Input clock frequency</td>
    <td>25 MHz</td>
  </tr>
  <tr>
    <td align="left">Output clock frequency </td>
    <td>5MHz</td>
  </tr>
  <tr>
    <td align="left">Output clock `clk_out1` name</td>
    <td>`clk_sdclk`</td>
  </tr>
  <tr>
    <td align="left">Dynamic reconfig</td>
    <td>enabled</td>
  </tr>
  <tr>
    <td align="left">Dynamic reconfig interface options</td>
    <td>DRP</td>
  </tr>
</table>
</center>

## Core Lock Step

In core lock step we use redundant CPU cores, running with the same inputs and 
comparing each core output. In case there is a single event upset (SEU) during 
operation, its effect would be shown in the affected core's output.

### Issues

The CLS configuration offers protection from SEUs by continuously comparing 
the output of each CPU based on common inputs. An SEU could effect a part in 
the CPU that doesn't have immediate effect on the output and could manifest 
later. For instance:

1. The design of the CPU.
2. PULPino Performance counters.
3. Operations that store values in PULPino registers.

The lowRISC minion subsystem is still under development and the CPU core could 
change in the future, for that reasons the design of the CPU would not be 
investigated.

Since operations that store the result on the CPU registers don't generate an 
immediate output, a fault won't be immediately detected. A solution could be 
that the registers are exposed and compared by the CLS unit. Another solution 
would be to protect the registers by using techniques like TMR and ECC. Both 
of that solutions would require modifying the CPU, which is avoided for this 
project.

Registers are often spilled (i.e. written to or read from the stack), meaning 
an SEU effect could be seen in relatively few cycles.

### Assumptions

1. The CLS configuration is focused only in the protection from SEUs and from 
permanent faults.
2. The protection of the peripherals, memories and the CLS assist unit itself 
won't be examined during this phase.
3. The debug unit is not used during the CLS configuration.

### Fault detection behaviour

The first and easiest fault handling is that the CLS unit resets the CPU 
cores. Since it doesn't reset the RAM or other peripherals, the program could 
be written in a way that assumes operation as quickly as possible.

Another solution could be that the CLS unit generates an exception, either by 
modifying the CPU core in order to add the exception or by assigning an 
interrupt. I preferred the interrupt approach because it's simpler and doesn't 
need any CPU modification.

Finally, checkpoints could be used to restore the faulty CPU in the last know 
healthy state. The checkpoints could be either introduced automatically or 
manually from the developer. The checkpoint functionality should be achieved 
with the support of software and hardware:

1. Hardware: Adding the mechanism in the CLS unit that stores the state in the 
form of the instruction address. This could be done with: a) extending the 
instruction set including the checkpoint instruction or b) having a memory 
addressable register that stores that state with ordinary store instructions.
2. Software: Since it's not easy to store the exact state of the CPU 
(registers) the program execution should be altered so when a checkpoint is 
used, it is ensured that no previous values in registers are used.

One of the advantages of triple core lock step is that by having 3 cores using 
voting, the core that suffered the fault the issue can be identified. Using a 
restore mechanism like checkpoints or exceptions, the faulty core could be 
re-synced in a few cycles, thus removing the need to restart the program.

### Implementation

The core lock step implementation was pretty straightforward after a better 
understanding of the minion SoC and the pulpino core was achieved.

The CLS configuration was placed in the `minion_cls.sv` module. The module has 
identical I/O with the pulpino core and is meant to replace the pulpino core 
in `minion_soc.sv`. The only modification required in order to use the CLS 
configuration is to add the `_cls` extension in the `riscv_core` from
`minion_soc.sv`. That way only minimal modification of `minion_soc` is 
required. The module has 3 pulpino core instances, the `cls_cmp_unit` that 
compares the core's output and signals a fault and the `cls_handler_unit` that 
implements the fault recovery.

The cores are configured with 1 master and 2 slaves. The inputs are connected 
directly from the module top. The 3 core's output are connected to the CLS 
compare unit but only the master core is connected to the module's output 
ports. Extra wires are only required by the slave cores and the naming is 
differentiated using the cls1 and cls2 extensions. The cores are separated 
into 1 master and 2 slaves by connecting the master’s outputs directly to the 
modules output port and not by another module, which leads to less and more 
clear code.

The `cls_cmp_unit` compares the outputs of all cores and issues a fault when 
an issue is detected. The implementation was straightforward, the only 
difficulty was in the code design in the comparison of that many signals. The 
comparison starts only when a core issues a request signal for the instruction 
or data bus. If there is a request in the instruction bus the unit then checks 
for the addresses. For the data address there is an extra check in the write 
data when a write is performed. It should be noted that the comparison unit 
doesn't check for inconsistencies in the signals when a request is not issued 
For more concise code the data and instruction request signals from all the 
cores were concatenated into a single signal. A single fault signal is used 
but if the recovery strategy requires it, the fault signal could be extended 
in order to show what triggered the error.

The `cls_handler_unit` handles any faults detected from the compare unit.
Since the recovery strategy is to reset all cores, the unit intercepts the 
reset signal from the top module to the cores. The unit has 2 tasks: a) to 
monitor the top module's reset signal and forward a reset to the cores when 
issued from the top module. b) Issue a reset to the cores for 1 clock cycle 
when a fault is detected. The functionality of the module could have been 
placed in the comparison unit but in my opinion the separation lead to a 
better design.

Besides the `minion_cls`, the coremem module was modified in order to ensure 
fault containment. In the case that a fault happens during a data write 
operation, there is a chance that the erroneous operation happens before the 
handler unit issues a reset. For that reason the `coremem` module is modified 
in order to introduce one extra cycle delay during write operations. The 
module delays setting the `ce`, `we` signals to the peripherals and the data 
grant signal to the cores.

A reset source SFR was added, the SFR is 0 if the reset was triggered from a 
normal reset and 1 if the reset was triggered by a CLS fault. That way the 
software knows the reset source.

### Fault injection

Faults were simulated by injecting errors in the CLS design. These tests were 
the only way to ensure that the design was working. The errors are created by 
modifying the values in variables during runtime, usually by introducing 
multiplexers. To my knowledge there isn't a framework that could make 
automated integration of the multiplexers in the CLS design, so the 
integration would have to be made manually. Introducing fault injection in 
random places in the pulpino core would have been a difficult and cumbersome 
task so it was avoided. A more plausible way was to inject errors in the cores 
output.

The `fault_injection_assist` module was introduced in the `minion_cls.sv`. The 
module overrides the cores outputs and when a fault injection is issued it 
toggled the selected signal. The new signals are defined in the `minion_cls` 
module. In order to use the fault injection, a `_finj` should be added in the 
signal name, going to the CLS comparison module. The module's internal 
implementation uses the `fault_injection_mux` module which is a simple 
multiplexer. In normal operation, the multiplexer forwarded the incoming 
signal value to the output. If a fault injection was requested and the index 
matched the multiplexer, it toggled the incoming signal's value. The first 
implementations tried to modify the existing signals by XORing to itself but 
that created an infinite feedback loop.

One key issue was finding the best approach for the fault injection timing. 
Without a model of the SEU generation in space, the best way was to inject 
faults pseudo-randomly in a time range that would make sense. The first 
attempt was to use a hardware pseudo random generator but it was quickly 
abandoned for a more swift solution, implemented in software. In the beginning 
all the output signals were exposed to fault injection but in order to make 
testing simpler and reduce the used FPGA resources, only the data and 
instruction bus request and address signals were used.

The first tests were made in verilator. The verilog top module was modified in 
order to expose the fault generation and signal index to the  verilator C++ 
program. In verilator test program a simple menu was created, where the user 
selected from the terminal if there would be a fault injection and in what 
signal. The menu was triggered by C++ pseudo random generator. As it was noted 
above in the first implementations of the fault injection unit a XOR was used 
in the affected signals. When the implementation was tested in the verilator, 
a non convergence error was triggered, that lead to the discovery of the bad 
design. Due to the added resources, the running simulation took longer to 
evaluate, so the delay running in the main loop of the minion hardware was 
reduced.

After the successful testing in the simulator, the design was tested in the 
actual hardware. A Xilinx VIO debug IP was used to trigger and verify the 
fault injection. The VIO IP connects the Arty board through JTAG to the Vivado 
suite in real time. There the VIO inputs were used to monitor critical signals 
in order to verify the correct behaviour of the CLS configuration. A VIO 
output was connected to the fault injection unit, and a button in Vivado was 
used to trigger a fault. The minion SoC with fault injection unit along with 
the VIO IP required more LUTs that there were available in the Arty FPGA, I 
had to remove the SD peripheral in order to free resources. Also the fault 
injection unit was modified to allow only one signal to be used, in order to 
limit resources usage.

![Fault injection in simulation](finj.png)
*Fault injection in simulation. The fault is injected in the red cursor.*

### Packetcraft

In order to assess the CLS configuration, a test application was developed.
The application implements the test service, a subset of the command and data 
handling protocol, running on UPSat. The test service is the equivalent of 
`ping` in computer networks. The user sends a test service telecommand and the 
subsystem, which in our case is the Arty, responds with a telecommand. For 
more information about the protocol see the ECSS-E70-41A specification.

`packet.py` continuously sends a test packet and counts the responses from the 
Arty, while it randomly triggers a fault injection. If there is a difference 
between the number of packets sent and received, it would mean that something 
went wrong due to the fault injection. The fault injection is triggered by an 
Arduino connected to the fault injection pin in the Arty.

The minion SoC runs with a CLS and fault injection configuration 
`test_packet.c` found in software/packetcraft implements the test app on the 
minion SoC side. The software is a very simple implementation, it reads the 
incoming characters, has a small delay of ~5us that simulates the packet 
processing time, check if there is a valid packet and responds. The original 
software does multiple checks which weren't necessary to implement in this 
case.

For the test I started to find which Tx period (packets send from 
`packet.py`), is the limit where the SoC starts losing packets without fault 
injection. The SoC had 20% packet losses with a Tx period of 0.08 which is 
very good as the application is not optimized and the tx packet takes 0.01 sec 
to transmit.  After that I started to find the fault injection interval that 
the SoC starts losing packets.  At average of one fault injection per 0.025 
sec, the SoC had 1.2% packet losses, at 0.01 sec there was 39.6, while at 
0.005 there was 100% packet loss. This is very promising results since the 
expected rate of faults induced by radiation is much less than that.

<center>
<table>
  <tr>
    <td>Tx period (Sec)</td>
    <td>Fault injection average period (Sec)</td>
    <td>Packet losses (%)</td>
  </tr>
  <tr>
    <td>0.08</td>
    <td>0</td>
    <td>20</td>
  </tr>
  <tr>
    <td>0.05</td>
    <td>0</td>
    <td>50</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>1</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>0.5</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>0.05</td>
    <td>0</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>0.025</td>
    <td>1.2</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>0.01</td>
    <td>39.6</td>
  </tr>
  <tr>
    <td>0.1</td>
    <td>0.005</td>
    <td>100</td>
  </tr>
</table>
</center>

## Code generation

The minion SoC functionality is implemented in the `minion_soc.sv`. In that 
file the PULPino core along with the memories and peripherals are placed 
together.  In order to make a minion with a different configuration the user 
would have to have modify the file, a cumbersome action that would be 
intimidating for beginners and users that don’t have a good understanding of 
the SoC.

For that reason I made a generator that takes a JSON configuration file and 
produces the minion SoC. The project is still a work in progress and not a 
full working project. Using the generator in the future enables users to 
easily use the Core Lock Step configuration without writing code.

The generator is based on python and jinja2 for the templating engine. Other 
options that were consider was the use of Chisel, myHDL and pyHDL but a 
simpler solution in terms of dependencies and ease of use was preferred. One 
design intention was to have minimal verilog code modification for the 
template.

The JSON configuration file holds the configuration parameters of each module. 
The usual options are the peripheral's name, the memory region that it uses 
and if the module could be used multiple times the module's number. Each 
module could have its own specific parameters.

The CLS configuration in core is enabled by setting the `core_lockstep` 
parameter to true. In the case fault injection is needed, the 
`fault_injection` must be set to true. The fault injection trigger is set by 
selecting either a pin, a button or a VIO IP module.

The templates were derived from the `minion_soc.sv`. Each template could have:

1. a port template that defines the module's I/O ports, if the module has I/O ports.
2. an instance template that defines the peripheral, along with any variable 
that is needed. This template usually has the read SFRs and the memory region 
that it uses. Finally if the peripheral could be used multiple times e.g.
UART, all the names of variables and modules uses a `peripheral_number` 
template variable in order to distinguish itself from each different 
peripheral instance.
3. an init template that has any register that needs to have a specific value 
at reset.
4. a bus template that has holds all the write SFRs.

Any custom peripheral could be added by implementing any of the above 
templates.

The following templates are available:

1. the core template has the CPU core.
2. the LED template.
3. the DIP switches template.
4. UART template.
5. PS2 template used for connection with a keyboard.
6. SD controller template.
7. VGA template

The generator creates the `minion_soc.sv`, `coremem.sv`, `top_arty.sv` and the 
`minion_cls.sv` if CLS is used. All generation is based on their corresponding 
templates.

The peripherals use memory mapped SFRs to exchange information with the core. 
The memory location of each SFR is used in the HAL from the software running 
in the SoC. One of the key aspects of the code generation is the ability to 
quickly modify each peripherals SFR memory region without requiring to rewrite 
the HAL by generating the file that holds the memory locations.

Note that this code is still under development so it is possible that it 
contains bugs. Currently the more than 1 UARTs implementation doesn't work.

## CLS power and size differences

One of the key metrics of any protection techniques, is the changes in 
resources usage. In this section the resource usage of the CLS configuration 
and the original SoC are reported. As we can see in the tables, the CLS has 
26.47% overhead in LUTs, 3.51% in flip flops, 6.66% in DSP. The other 
resources remain the same (the BUFG are not taken into account).

The other critical factor for use in CubeSats is the power dissipation. The 
added 8mW is not an issue. Also the general power dissipation makes it usable 
for 2U cubesat, as In [UPSat](https://upsat.gr/) the onboard computer used 
0.198W.

![](cls_graph.png) ![](cls_util.png)

![](graph.png) ![](util.png)

*Resource utilization with CLS (top) and without (bottom)*

![](cls_pwr.png) ![](cls_pwr_el.png)

![](pwr.png) ![](pwr_graph.png)

*Power usage: with CLS (top) and without (bottom)*

## Thoughts and future work

One of the reasons that I started the GSoC project was get more familiar with 
HDL and FPGAs while I contributed to an open source project. Even though the 
CLS configuration is experimental and needs more work to be done, I believe 
that I made one step towards more open source in Space. Also debugging the 
minion SoC in the FPGA without JTAG is bad.

After GSoC I would like to continue working in the code generation project.
Using the code generation made design and testing simpler. I wish I started 
working in the project earlier in the summer.

Finally I would like to thank my mentor, Alex Bradbury for his help and 
patience, Mr Aris Stathakis for lending me his Arty board, and Google for 
making GSoC.
