+++
Description = ""
date = "2017-04-18T15:00:00+00:00"
title = "Bring back the tag support in lowRISC"
parent = "/docs/minion-v0.4/"
prev = "/docs/minion-v0.4/tag_lowrisc/"
next = "/docs/minion-v0.4/tag_lowrisc/"
showdisqus = true

+++

This lowRISC release brings back the tagged memory idea into Rocket-chip with a total redesign.
The diagram below shows the tag extension added into the Rocket-chip.
Built-in tag manipulation and check functions are integrated into every Rocket core.
Data words in the whole cacheable memory space are augmented with a tag (currently set to 4-bit per 64-bit word).
The whole hierarchical cache system, from the L1 data and instruction caches to the DDR main memory are tagged.
The old tag cache is replaced with an optimised tag cache to reduce the memory traffic towards DDR when no tag is used.

<img src="../figures/lowRISC_tag.png" alt="Drawing" style="width: 800px; padding: 20px 0px;"/>

For detailed information of this new design:

* [Hierarchical tag cache]({{< ref "docs/minion-v0.4/tag_cache.md" >}}).
* [Tag support in the Rocket core]({{< ref "docs/minion-v0.4/tag_core.md" >}})
