+++
Description = ""
date = "2017-06-09T12:35:57+00:00"
title = "lowRISC 0-4 milestone release"

+++

The [lowRISC 0.4 milestone release]({{< ref "docs/minion-v0.4/_index.md" >}})
is now available. The various changes are best described in our [accompanying
documentation]({{< ref "docs/minion-v0.4/_index.md" >}}), but in summary this
release:

* Moves forward our support for tagged memory by re-integrating the tag cache,
  reducing overhead with a [hierarchical scheme]({{< ref "docs/minion-v0.4/tag_cache.md" >}}).
  This will significantly reduce caches misses caused by tagged memory accesses
where tags are distributed sparsely.
* Integrates support for specifying and configuring [tag propagation and
  exception behaviour]({{< ref "docs/minion-v0.4/tag_core.md" >}}).
* A [PULPino](http://www.pulp-platform.org/) based "minion core" has been
  integrated, and is used to provide peripherals such as the SD card
interface, keyboard, and VGA tex display (when using the Nexys4 DDR FPGA
development board).

Please report any issues [on our GitHub
repository](https://github.com/lowRISC/lowrisc-chip), or discuss on our
[mailing list](http://listmaster.pepperfish.net/cgi-bin/mailman/listinfo/lowrisc-dev-lists.lowrisc.org). As always, thank you to everyone who has contributed in any way - whether it's advice and feedback, bug reports, code, or ideas.
