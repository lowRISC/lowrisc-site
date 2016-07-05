+++
Description = ""
date = "2015-04-12T15:05:25+01:00"
title = "Rocket chip overview"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/"
next = "/docs/tagged-memory-v0.1/rocket-core/"
aliases = "/docs/tutorial/rocket-chip/"
showdisqus = true

+++


An overview of Berkeley's RISC-V "Rocket Chip" SoC Generator can be found [here](https://1nv67s1krw3279i5yp7fko14-wpengine.netdna-ssl.com/wp-content/uploads/2015/01/riscv-rocket-chip-generator-workshop-jan2015.pdf).

A high-level view of the rocket chip is shown below. The design
contains multiple Rocket tiles consisting of a Rocket core and L1
instruction and data caches. Our tagged memory implementation inserts
a tag cache before the main memory interface. Our tagged memory additions
are described in detail [here]({{< ref "docs/tagged-memory-v0.1/tags.md" >}}). 

<img src="../figures/rocket_chip.png" alt="Drawing" style="width: 650px;"/>

The host-target interface (HTIF) provides a FIFO interface between the
ARM PS and RISC-V systems. Two communication registers (`fromhost`,
`tohost`) are provided in CSR space (Control and Status Registers) for
this purpose. The HTIF allows the host to load binaries, access memory
and CSRs and service syscalls for peripheral device emulation.

Coherence between the private L1 caches is maintained with the
assistance of the "coherence managers". Requests are interleaved
across a number of coherence managers at the granularity of cache
lines. Each coherence manager contains a number of transaction "trackers"
and can manage numerous outstanding transactions (or cache misses).
A MI, MSI or MESI coherence protocol may be selected.

Communication between the Rocket tiles and coherence managers uses the
[TileLink protocol][TileLinkSpec]. The protocol defines a number of
independent transaction channels, the prioritization of channels (to
avoid deadlock) and their format. TileLink helps to isolate the
design of the coherence protcol from that of the physical networks
and cache controlllers. 

### Default configuration parameters

The default configuration parameters are listed in the table
below. All configuration parameters are located in
`src/scala/main/PublicConfigs.scala`. 

Further details on how to parameterize Rocket Chip can be found
[here](https://github.com/ucb-bar/rocket-chip#-how-can-i-parameterize-my-rocket-chip). 
A manual describing the advanced
parameter library within Chisel is also
[available][Chisel-parameterization-manual].

| Description                          | Parameter Name | Default Value                               | Possible Value     | Notes                  |
| ------------------------------------ | -------------- | ------------------------------------------- | -----------------  | ---------------------- |
| No. of Rocket tiles                  | NTILES         | 1                                           | >0                 |                        |
| No. of banks                         | NBANKS         | 1                                           | >0, power of 2     |                        |
| No. of MSHRS                         | L1D_MSHRS      | 2                                           | >0                 |                        |
| No. of sets in L1D                   | L1D_SETS       | 128                                         | >0, power of 2     |                        |
| No. of ways in L1D                   | L1D_WAYS       | 4                                           | >0, power of 2     |                        |
| No. of sets in L1I                   | L1I_SETS       | 128                                         | >0, power of 2     |                        |
| No. of ways in L1I                   | L1I_WAYS       | 2                                           | >0, power of 2     |                        |
| Size of data TLB                     | NDTLBEntries   | 8                                           | >0, power of 2     |                        |
| Size of instr TLB                    | NITLBEntries   | 8                                           | >0, power of 2     |                        |
| Size of BTB                          | NBTBEntries    | 62                                          | >0                 |                        |
| No. of trackers in coherence manager | L2_ACQ_XACTS   | 7                                           | >0                 |                        |
| Instantiate FPU?                     | BuildFPU       | Some(() => Module(new FPU))                 |                    | Set to None to disable |
| Coherence protocol                   | Coherence      | new MSICoherence()=>new(NullRepresentation) | MI, MEI, MSI, MESI |                        |

<!-- Links -->

[TileLinkSpec]: https://github.com/ucb-bar/uncore/blob/master/doc/TileLink0.3.1Specification.pdf
[Chisel-parameterization-manual]: https://github.com/ucb-bar/chisel/blob/master/doc/parameters/parameters.pdf

