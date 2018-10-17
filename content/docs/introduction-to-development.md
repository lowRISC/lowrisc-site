+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Introduction to Development"
parent = "/docs/refresh-v0.6/"
next = "/docs/refresh-v0.6/overview/"
showdisqus = true

+++

## Introduction to Development

This project uses Field-programmable Gate Array (FPGA) manufacturered by Xilinx as the underlying technology. These devices are manufacturered in large volumes, hence are relatively inexpensive, but the overhead of programmability results in a large area increase and consequent high leakage current, as well as a considerably lower clock rate than mask programmed Application Specific Integrated Circuits (ASICs). Manufacturers try their best to products as usable as possible, but at the end of the day some of the error messages will not be very comprehensible to non-specialists. The Xilinx software that supports these chips is called Vivado.

### Hardware description language

This project incorporates a processor generator that uses Scala, a functional language that incorporates a shallow embedding of hardware concepts. As such it is difficult to predict in advance what size of hardware will be generated until the program runs. Because of the shallow embedding, errors in generation of hardware will frequently not be noticed until much later. For this reason it is advisable to run a test suite whenever the Scala description changes.

The remainder of the project uses a mixture of System Verilog and (legacy) Verilog. In the subset of this language that makes sense in hardware, there is more or less a one-to-one correspondence between what is written and the hardware generated.

### Simulation of the hardware description

Vivado from Xilinx incorporates a form of simulation built in. It has a number of limitations. Essentially each flip-flop in the design is modelled by a memory location and all paths that change after an event will get updated one by one. Naturally this is very slow on a large hardware simulation.

### Emulation of the hardware description

Within certain limitations, the main one being clock frequency, the FPGA allows behaviour very close to the real ASIC to be modelled. Since the configuration of the FPGA is held in RAM, as well as its datapath contents, the probably of an upset is increased. Typically a power line glitch or cosmic ray event or background radioactivity will cause this. Nevertheless it is entirely possible for an emulation to run for days without any observable glitches. This is invaluable for generating test coverage for the expensive process of masking an ASIC.

### Mask making from the hardware description

A number of options exist, the most ambitious being a full mask set for all transistors and metallisation, usually measured in tens of millions of dollars. A halfway house is a sea-of-gates, where the transistors are kept the same and only the metallisation is changed. This kind of option is appropriate where the expected sales are a million plus. A cheaper option for prototyping is the multi-project wafer, where unrelated projects share a reticule at a saving in mask making costs, but a considerable increase in unit costs, as most of the wafer must be discarded for each given customer.

## Development process

It is apparent that the emulation phase of the development process is extremely important before any money should be spent on engineering the solution further. For certain applications the requirement for flexibility overrides the lower clock rate and in such cases (for example reconfigurable computing cards), the bulk of the development work involves optimising the design to make the most of the FPGA resources.

For this project the development problem is a classic one, combining a CPU with caches, dynamic memory, ROM and peripherals to produce a usable computer.

## Continue the process below:

* [Overview of the Refresh system]({{< ref "docs/overview.md" >}})
