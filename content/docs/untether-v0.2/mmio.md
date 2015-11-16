+++
Description = ""
date = "2015-11-16T15:44:50+01:00"
title = "Memory mapped I/O (MMIO)"
parent = "/docs/untether-v0.2/overview/"
prev = "/docs/untether-v0.2/rocket-core/"
next = "/docs/untether-v0.2/pcr/"
showdisqus = true

+++

**Note: this initial implementation of MMIO is subject to significant further optimizations.**

Although peripherals are mapped into the memory space, they cannot be accessed in the same way as cachable memory due to the consistency requirement of I/O operations and the possible side-effect of I/O read and write. To safely access the I/O psace of peripherals, a memory mapeed I/O gives core pipeline uncached access to I/O space (bypassing both L1 and L2) while enforcing I/O operations in the program order.

To bypass L1 and L2 for I/O operations, they must be extracted from the normal memory operations and processed separately in L1 D$. The fllowing figure shows a L1 D$ with the MMIO support (probe and write-back units are removed to highlight the MMIO). The components in blue are used for MMIO.

<img src="../figures/dcache_mmio.png" alt="Drawing" style="width: 600px;"/>

The `ioaddr` is an address checker controlled by the global I/O space mapping (see [Memory and I/O maps, soft reset, and interrupts]({{< ref "pcr.md" >}})). Using the I/O mapping, `ioaddr` identifies I/O requests in all D$ misses (denoted by `s1_req.addr`). Since all I/O operations are uncached, they are all missed in D$ and catched by `ioaddr`, which then notify them to the I/O missing handler (`iomshr`). `iomshr` process the actual I/O request through the I/O bus shown in the [high-level view of the untethered Rocket chip](../overview#figure-overview). If it is write operation, the D$ assume it is served once the miss is acepted by `iomshr`. For I/O read operations, `iomshr` initiate a I/O replay after fetch the data from peripherals. Buffer registers (`io_data`, `s1_io_data`) ensures the I/O replay follows the exact timing of normal memory replay; therefore, the core pipeline get the I/O value through the usual `cpu.resp` port at "Stage 3". Since there is only one `iomshr`, all I/O operations are enforced to be processed in the program order.