+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Diplomacy and TileLink from the Rocket Chip"
showdisqus = true

+++

_Wei Song_

(11-2017)

## 1. Introduction

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
which is implemented and encapsulated into a Chisel package
heavily leveraging the software engineering features provided by Chisel (Scala),
including functional programming, generic type inference and object oriented programming.
Taking the full benefits of this Diplomacy package,
the in-house TileLink bus protocol has been totally overhauled and renovated.
The new TileLink protocol supports automatic parameter negotiation and checking, bus generation and
interrupt connection at compile time.

As for lowRISC, we use the Rocket-Chip as the internal SoC architecture
while extends it with a top level AXI interconnects implemented using SystemVerilog (SV) rather than Chisel.
This allow further system extension for engineers and companies who would prefer SystemVerilog.
However, the devices added to the extended AXI buses should be coherently controlled by the Rocket-Chip
with no difference with the Chisel devices hanging on the internal TileLink or Chisel AXI buses.
To be specific, this means the individual address spaces of the external SV devices are observable and verifiable
inside the L1 data cache;
therefore, an illegal access to a wrong address towards the external AXI bus can be stopped immediately inside
the L1 data cache with a precise exception.
Also, the interrupts of the external SV devices should be automatically connected to the internal interrupt interconnects.
These would provide similar correctness insurance with the Chisel devices
but do need special extension towards the Diplomacy package.

This short document is written with three purposes in mind:

* Provide the information needed to understand the Diplomacy and the TileLink.
* Provide extra information about how to extend the Rocket-Chip using the existing infrastructure, namely the cake pattern.
* Provide the internal information of the extension done by lowRISC to support the external SV AXI buses.

## 2. Background Information

It is probably unfeasible to write a single piece of document describing all related information.
There are some good sources which serve as foreknowledge before any endeavour to read this document.

#### Short users guide to Chisel: [https://github.com/freechipsproject/chisel3/wiki/Short-Users-Guide-to-Chisel](https://github.com/freechipsproject/chisel3/wiki/Short-Users-Guide-to-Chisel)

This guide provides the basic features available from the Chisel3 DSL language which is developed upon the Scala language.

#### TileLink Spec 1.7-draft [[2]](#TileLink): [https://www.sifive.com/documentation/tilelink/tilelink-spec/](https://www.sifive.com/documentation/tilelink/tilelink-spec/)

This specification provides a detailed description of the TileLink protocol and bus hardware structure.

#### Diplomatic design patterns: A TileLink case study [[3]](#Cook2017): [https://carrv.github.io/papers/cook-diplomacy-carrv2017.pdf](https://carrv.github.io/papers/cook-diplomacy-carrv2017.pdf)

This CARRV 2017 paper provides a high-level description of why and how the Diplomacy and TileLink packages are developed.

#### U54-MC Core Complex Manual: [https://www.sifive.com/documentation/risc-v-core/u54-mc-risc-v-core-ip-manual/](https://www.sifive.com/documentation/risc-v-core/u54-mc-risc-v-core-ip-manual/)

U54-MC coreplex shows nearly all what the Rocket-Chip can provide at the point when this document is written. 

#### Structure of the lowRISC SoC: [http://www.lowrisc.org/docs/minion-v0.4/](http://www.lowrisc.org/docs/minion-v0.4/)

The tutorial of the latest release from lowRISC. The difference between lowRISC and Rocket-Chip leads to the extension to the Diplomacy package.

#### Notes for Rocket-Chip: [https://github.com/cnrv/rocket-chip-read](https://github.com/cnrv/rocket-chip-read)

An unfinished but detailed note on the source code of the Rocket-Chip implementation.

## 3. Extra Information About the Diplomacy Package

Assuming you have read [[2]](#TileLink), [[3]](#Cook2017),
here is a quote from [[3]](#Cook2017) which summarises Diplomacy pretty well:

> Diplomacy is a framework for negotiating the parameterization of protocol implementations.
> Given a description of sets of interconnected master and slave devices, and a bus protocol template,
> Diplomacy cross-checks the requirements of all connected devices, negotiates free parameters,
> and supplies final parameter bindings to adapters and endpoints for use in their own hardware generation processes.
> Beyond confirming the mutual compatibility of the system endpoints,
> Diplomacy enables them to specialize themselves based on knowledge about the capabilities of other endpoints
> included in a particular system.

### 3.1 Diplomacy supports directed acyclic graphs

Now let us dive into some details. Figure [1](#figure-1) is a simple TileLink interconnect depicted as Figure 2.2 in [[2]](#TileLink).
Every hardware component (the white outer block) connected to the TileLink interconnect contains one or more TileLink _agent_.
Each _agent_ have at least one slave or master _interface_ which is directly connected to the TileLink.
Each pair of _interfaces_ is connected by a single _link_
which contains 3 or 5 different uni-directional _channels_ depending on the level of TileLink traffic support by the interfaces.

<a name="figure-1"></a>
<img src="figures/tilelink-topo.png" alt="Drawing" style="width: 600px;"/>
<br>**Figure 1**. A simple TileLink interconnect.

An important observation of the TileLink interconnect (or any interconnect that can be generated using Diplomacy) is that:
if every _agent_ is considered a node and every _link_ is considered a directed arc pointing from the master _interface_
towards the slave _interface_, the interconnect is a directed acyclic graph (DAG).

There are several notes here:

- **The mapping between _agents_ and hardware components is not one-to-one!**
A hardware component may not be associated to any _agent_ if it is not directly connected to an interconnect.
A hardware component may have more than one _agents_ if it is connected to more than one interconnects.
Considering a DMA component, it may have one _agent_ controlling its connection to the high-speed data bus
while also has another _agent_ controlling its connection to the configuration bus.

- **The mapping between _links_ and actual hardware links is not always one-to-one either!**
The DAG is built at compile time to negotiate the parameters of various agents.
Although it is normally true that an _agent_ represents a real communication agent in hardware,
it is not necessary that the Diplomacy must produce the actual hardware connections for these agents.
The DAG and the diplomacy package can be hijacked to negotiating the parameters for a virtual network
while the actually hardware connections are settled separately.
This is how the Diplomacy package is extended for the shared SV AXI bus in lowRISC.

### 3.2 A rough description of the implementation of a _Node_

In the Chisel implementation of the Diplomacy package, all _agents_ are an object derived from a class named a _Node_.
Here shows the derivation relationship of all _agents_ in Figure [1](#figure-1).
All _agents_ supported by the current Diplomacy package derived from a single parent class, **MixedNode**,
which is defined in the Diplomacy package: [Nodes.scala](https://github.com/freechipsproject/rocket-chip/blob/master/src/main/scala/diplomacy/Nodes.scala)

~~~
# Processor
TLOutputNode < OutputNode < IdentityNode < AdapterNode < MixedAdapterNode < MixedNode
# Cache
                           TLAdapterNode < AdapterNode < MixedAdapterNode < MixedNode
# Crossbar
                                 TLNexusNode < NexusNode < MixedNexusNode < MixedNode
# memory-mapped device / memory controller
                                                 AXI4SlaveNode < SinkNode < MixedNode
~~~

Now let us have a look of the internals of this `MixedNode` class:

~~~scala
sealed abstract class MixedNode[DI, UI, EI, BI <: Data, DO, UO, EO, BO <: Data](
  inner: InwardNodeImp [DI, UI, EI, BI],
  outer: OutwardNodeImp[DO, UO, EO, BO])(
  val numPO: Range.Inclusive,
  val numPI: Range.Inclusive)(
  implicit valName: ValName)
  extends BaseNode with NodeHandle[DI, UI, BI, DO, UO, BO] with InwardNode[DI, UI, BI] with OutwardNode[DO, UO, BO]
{
  def resolveStar(iKnown: Int, oKnown: Int, iStar: Int, oStar: Int): (Int, Int)
  def mapParamsD(n: Int, p: Seq[DI]): Seq[DO]
  def mapParamsU(n: Int, p: Seq[UO]): Seq[UI]
  def gco = if (iParams.size != 1) None else inner.getO(iParams(0))
  def gci = if (oParams.size != 1) None else outer.getI(oParams(0))

  lazy val (oPortMapping, iPortMapping, oStar, iStar) // resolve from #D#.iStar and #U#.oStar
  lazy val oPorts                                // resolve from #D#.iPortMapping()
  lazy val iPorts                                // resolve from #U#.oPortMapping()
  lazy val oParams: Seq[DO] // resolve from oPorts, iPorts and mapParamsD()
  lazy val iParams: Seq[UI] // resolve from iPorts, oPorts and mapParamsU()
  lazy val edgesOut         // resolve from oPorts and oParams
  lazy val edgesIn          // resolve from iPorts and iParams

  lazy val bundleOut: Seq[BO] = edgesOut.map(e => Wire(outer.bundleO(e)))
  lazy val bundleIn:  Seq[BI] = edgesIn .map(e => Wire(inner.bundleI(e)))

  def out: Seq[(BO, EO)]
  def in: Seq[(BI, EI)]

  def instantiate()
  def bind(h: OutwardNode[DI, UI, BI], binding: NodeBinding)

}
~~~

### References
<!-- References --> 

<a name="Asanovic2016"></a>
[1] K. Asanovic, R. Avizienis, J. Bachrach, S. Beamer, D. Biancolin, C. Celio, H. Cook, D. Dabbelt, J. Hauser, A. Izraelevitz, S. Karandikar, B. Keller, D. Kim, J. Koenig, Y. Lee, E. Love, M. Maas, A. Magyar, H. Mao, M. Moreto, A. Ou, D. A. Patterson, B. Richards, C. Schmidt, S. Twigg, H. Vo and A. Waterman. "[The Rocket chip generator.](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-17.html)" EECS Department, University of California, Berkeley, Technical Report No. UCB/EECS-2016-17, 2016.

<a name="TileLink"></a>
[2] "[SiFive TileLink Specification.](https://static.dev.sifive.com/docs/tilelink/tilelink-spec-1.7-draft.pdf)" SiFive, Inc. Version 1.7, August 2017.

<a name="Cook2017"></a>
[3] H. Cook, W. Terpstra and Y. Lee. “[Diplomatic design patterns: A TileLink case study.](https://carrv.github.io/papers/cook-diplomacy-carrv2017.pdf)” In proc. of Workshop on Computer Architecture Research with RISC-V (CARRV), 2017.
