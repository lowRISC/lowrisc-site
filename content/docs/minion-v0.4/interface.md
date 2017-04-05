+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Debug interface"
parent = "/docs/debug-v0.3/overview/"
prev = "/docs/debug-v0.3/overview/"
next = "/docs/debug-v0.3/debugmodules/"
showdisqus = true

+++

As mentioned in the [overview]({{< ref "docs/debug-v0.3/overview.md"
>}}) the debug infrastructure abstracts from the physical transport
interface with the
[generic interface logic project (glip)](http://glip.io). The
following sketch shows the basic interface provided by glip and how it
is used by the Open SoC Debug (osd) infrastructure.

<a name="figure-osdglip"></a>
<img src="../figures/osd_glip.png" alt="OSD and glip" style="padding: 20px 0px;"/>

The basic interface abstraction of glip is a simple FIFO with 16-bit
data and ready/valid flow control. The underlying glip backend
implementation maps this interface to a protocol for different
physical interfaces. It also adds a reset signal that can be used to
remotely reset the entire system.

## Debug packets

The simple glip interface is used to exchange debug datagrams between
the host and the system. Each of those datagrams contains one 16-bit
word as header followed by multiple 16-bit words payload. The header
currently only contains the length of the payload and the payload is
exactly one *debug packet*. Those debug packets are then transferred
to the debug modules over the on-chip debug interconnect.

Each debug packet has a header that contains the source module, the
destination module and the packet type, plus some bits specific to the
packet type. The packet payload is specific to the debug packet type
and in most cases specific to the module type and the dynamic
configuration. While a "register write" packet always has the same
length and structure, trace modules will usually have variable sized
packets depending on the current tracing configuration.

## Hardware Interface

The system has a physical interface as provided by glip (UART in this
tutorial) and follows the technical specification of this glip
backend. The interface block of glip is then instantiated and the Open
SoC Debug infrastructure connects to this.

In hardware the debug packets are converted into the debug datagrams
and vice versa by the so called "Host Interface Module (HIM)". The
interconnect interface is again a simple FIFO/stream interface with
valid/ready flow control. With an extra last signal the different
packets are then routed through the network to the final
destination. This interface is pretty similar to AXI stream, with
semantic routing and protocol (header) information in the first words.

## Software Interface

On the software side glip provides an interface to read and write
16-bit words to the hardware FIFOs, each in a blocking and
non-blocking variant. Sending debug packets is then performed by assembling 
the header and payload in `uint16_t` arrays and sending them with
`glip_write`. A thread receives the packets and dispatches them to
handlers that were registers for the different modules. You find more
details on the software interface in the
[debug software and methodology]({{< ref
"docs/debug-v0.3/softwaremethodology.md" >}}) part of the tutorial.
