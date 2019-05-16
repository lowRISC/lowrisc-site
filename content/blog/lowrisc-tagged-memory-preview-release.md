+++
date = "2015-04-13T22:28:10Z"
title = "lowRISC tagged memory preview release"

+++

We're pleased to announce the [first lowRISC preview release]({{< ref 
"docs/tagged-memory-v0.1/_index.md" >}}), demonstrating support for tagged memory as 
described in [our memo]({{< ref 
"docs/memo-2014-001-tagged-memory-and-minion-cores.md" 
>}}). Our ambition with lowRISC is to provide an open-source System-on-Chip 
platform for others to build on, along with low-cost development boards 
featuring a reference implementation. Although there's more work to be done on 
the tagged memory implementation, now seemed a good time to document what 
we've done in order for the wider community to take a look. Please see our 
[full tutorial]({{< ref "docs/tagged-memory-v0.1/_index.md" >}}) which describes in some 
detail the changes we've made to the Berkeley [Rocket 
core](https://github.com/ucb-bar/rocket), as well as how you can build and try 
it out for yourself (either in simulation, or on an FPGA). We've gone to some 
effort to produce this documentation, both to document our work, and to share 
our experiences building upon the Berkeley RISC-V code releases in the hopes 
they'll be useful to other groups.

The initial motivation for tagged memory was to prevent control-flow hijacking 
attacks, though there are a range of other potential uses including 
fine-grained memory synchronisation, garbage collection, and debug tools.  
Please note that the instructions used to manipulate tagged memory in this 
release (`ltag` and `stag`) are only temporary and chosen simply because they 
require minimal changes to the core pipeline. Future work will include 
exploring better ISA support, collecting performance numbers across a range of 
tagged memory uses and tuning the tag cache. We are also working on developing 
an 'untethered' version of the SoC with the necessary peripherals integrated 
for standalone operation.

If you've visited lowrisc.org before, you'll have noticed we've changed a few 
things around. Keep an eye on this blog (and its [RSS 
feed](https://www.lowrisc.org/index.xml)) to keep an eye on developments - we
expect to be updating at least every couple of weeks. We're very grateful to 
the RISC-V team at Berkeley for all their support and guidance. A large 
portion of the credit for this initial code release goes to [Wei 
Song](http://wsong83.github.io/), who's been working tirelessly on the HDL 
implementation.
