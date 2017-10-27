+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Diplomacy and TileLink from the Rocket Chip"
showdisqus = true

+++

_Wei Song_

(11-2017)

## Introduction

Rocket-Chip is a SoC generator [[1]](#Asanovic2016) initially developed by UC Berkeley and now mostly maintained by SiFive.
The SoC can be configured with a single or multiple processor cores,
such as the in-order Rocket cores or the out-of-order BOOM cores.
The architecture of the whole SoC,
including the type/size/level of caches, the number of on-chip buses and the devices hanging on individual buses,
are all configurable at design time.
Considering each different configuration (parameter) combination as a different SoC that requires individual settings,
maintaining the flexibility and correctness of the SoC generator is a tough job.
The traditional way of using design time parameters and macros to choose manually implemented hardware components at compile time
clearly would not fit the purpose.
For this reason, the developing team of Rocket-Chip come out with
a new compile time parameter negotiation and generation mechanism called Diplomacy,
which is implemented and encapulated into a Chisel package
heavily leveraging the software engineering features provided by Chisel (Scala),
including functional programming, generic type inferrence and object oriented programming.
Taking the full benefits of this Diplomacy package,
the in-house TileLink bus protocol has been totally overhaulled and reinnovated.
The new TileLink protocol supports automatic parameter negotiation and checking, bus generation and
interrupt connection at compile time.

As for lowRISC, we use the Rocket-Chip as the internal SoC architecture
while extends it with a top level AXI inerconnects implemented using SystemVerilog (SV) rather than Chisel.
This allow further system extension for engineers and companies who would prefer SystemVerilog.
However, the devices added to the extended AXI buses should be coherently controlled by the Rocket-Chip
with no difference with the Chisel devices hanging on the internal TileLink or Chisel AXI buses.
To be specific, this means the individual address spaces of the external SV devices are observable and checkable
inside the L1 data cache;
therefore, an illegal access to a wrong address towards the external AXI bus can be stopped immediately inside
the L1 data cache with a precise exception.
Also, the interrupts of the external SV devices should be automatically connected to the internal interrupt interconnects.
These would provide similar correctness insurance with the Chisel devices
but do need special extension towards the Diplomacy package.

This short document is written with three purposes in mind:

* Provide the information needed to understand the Diplomacy and the TileLink.
* Provide extra information about how to extend the Rocket-Chip using the existing infrustracture, namely the cake pattern.
* Provide the internal information of the extension done by lowRISC to support the external SV AXI buses.


### Bibliography
<!-- References --> 

<a name="Asanovic2016"></a>
[1] K. Asanovic, R. Avizienis, J. Bachrach, S. Beamer, D. Biancolin, C. Celio, H. Cook, D. Dabbelt, J. Hauser, A. Izraelevitz, S. Karandikar, B. Keller, D. Kim, J. Koenig, Y. Lee, E. Love, M. Maas, A. Magyar, H. Mao, M. Moreto, A. Ou, D. A. Patterson, B. Richards, C. Schmidt, S. Twigg, H. Vo and A. Waterman. "[The Rocket chip generator.](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-17.html)" EECS Department, University of California, Berkeley, Technical Report No. UCB/EECS-2016-17, 2016.
