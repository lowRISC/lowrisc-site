+++
Description = ""
date = "2017-04-18T15:00:00+00:00"
title = "Bring back the tag support in lowRISC"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/index/"
next = "/docs/minion-v0.4/tag_cache/"
showdisqus = true

+++

This lowRISC release brings back the tagged memory idea into Rocket-chip with a total redesign.
The diagram below shows the tag extension added into the Rocket-chip.
Built-in tag manipulation and check functions are integrated into Rocket core piplines.
All data words in the cacheable memory space are augmented with tags (currently a 4-bit tag per every 64-bit word).
All levels of the memory hierarchy, from the L1 data and instruction caches to the DDR memory, are tagged.
For the uncached address space, including the I/O address space and boot ROM/RAM, tags are disabled and hardwired to 0.
The plain tag cache in the previous implementation is replaced with an optimised hierarchical tag cache
to significantly reduce the extra traffic towards DDR when cache lines are not tagged.

<p style="text-align:center;"><img src="../figures/lowRISC_tag.png" alt="Drawing" style="width: 800px; padding: 20px 0px;"/></p>

For detailed information of this new design:

* [Hierarchical tag cache]({{< ref "docs/minion-v0.4/tag_cache.md" >}})
* [Tag support in the Rocket core]({{< ref "docs/minion-v0.4/tag_core.md" >}})
