+++
Description = ""
date = "2015-04-12T15:12:50+01:00"
title = "Rocket core overview"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/rocket-chip/"
next = "/docs/tagged-memory-v0.1/tags/"
aliases = "/docs/tutorial/rocket-core/"
showdisqus = true

+++


The Rocket core is an in-order scalar processor that provides a
5-stage pipeline. It implements the RV64G variant of the RISC-V
ISA. The Rocket core has one integer ALU and an optional FPU. An
accelerator or co-processor interface, called RoCC, is also provided.

Further details of the RISC-V Rocket core pipeline can be found
[here](http://www-inst.eecs.berkeley.edu/~cs250/fa13/handouts/lab2-riscv.pdf#13). See
p.13 of this document for a detailed diagram of Rocket's
microarchitecture. The Rocket core is sometimes described as a 6-stage
pipeline with the addition of a 'pcgen' stage. While it is useful to
layout the figure in this way, the stage is perhaps best considered as
part of the other stages and is not a distinct pipeline stage in the
traditional sense.

The `pcgen` and `fetch` stages are shown below. Instruction fetch is
assisted by a gshare predictor, Return Address Stack (RAS) and Branch
Target Buffer (BTB).

<img src="../figures/icache.png" alt="Drawing" style="width: 750px;"/>

The remaining four pipeline stages are shown below:

<img src="../figures/pipeline.png" alt="Drawing" style="width: 850px;"/>

The L1 data cache is shown below. 

<img src="../figures/dcache.png" alt="Drawing" style="width: 1000px;"/>

Note: The data cache's metadata (tags etc.) and data arrays are shown in 
both stage 1 (for read operations) and stage 4 (for write operations). 

Key:

  * amoalu: Atomic memory operation ALU
  * mshrs: Miss status handling registers
  * prober: Handles incoming probe requests (i.e. tag lookups or requests to revoke permissions)
  * code: placeholder for ECC support


