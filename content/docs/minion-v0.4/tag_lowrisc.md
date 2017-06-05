+++
Description = ""
date = "2017-04-18T15:00:00+00:00"
title = "Tagged memory developments"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/index/"
next = "/docs/minion-v0.4/tag_cache/"
showdisqus = true

+++

This lowRISC release brings back support for tagged memory in our
Rocket-derived codebase, redesigning and further optimising a number of
aspects. The diagram below shows how Rocket-chip was extended to support
tagged memory. Built-in tag manipulation and check functions are integrated
into Rocket core piplines.  All data words in the cacheable memory space are
augmented with tags (by default a 4-bit tag for every 64-bit word).
Tags are stored in a table in main memory. To prevent the need to access this table
on every memory access a dedicated tag cache is provided and both L1 and L2 caches
are extended to hold tags. For the uncached address space, including the I/O address
space and boot ROM/RAM, tags are disabled and hardwired to 0. The simple tag
cache in the previous implementation is replaced with an optimised
hierarchical tag cache to significantly reduce the extra off-chip memory
traffic in regions of memory where tags are either not used at all, or are distributed
sparsely.

<p style="text-align:center;"><img src="../figures/lowRISC_tag.png" alt="Drawing" style="width: 800px; padding: 20px 0px;"/></p>

For detailed information of this new design, see:

* [Hierarchical tag cache]({{< ref "docs/minion-v0.4/tag_cache.md" >}})
* [Tag support in the Rocket core]({{< ref "docs/minion-v0.4/tag_core.md" >}})
