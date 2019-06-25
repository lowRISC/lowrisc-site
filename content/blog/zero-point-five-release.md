+++
Description = ""
date = "2018-01-12T14:45:57+00:00"
title = "lowRISC 0-5 milestone release"

+++

The [lowRISC 0.5 milestone release]({{< ref "docs/ethernet-v0.5/_index.md" >}})
is now available. The various changes are best described in our [accompanying
documentation]({{< ref "docs/ethernet-v0.5/_index.md" >}}), but the main focus 
is the integration of open-source Ethernet IP. The tutorial demonstrates how 
to use Ethernet support to boot with an NFS root, as well as with a rootfs on 
SD card.

Our main development focus currently is migrating to a newer version of the 
upstream Rocket chip design and reintegrating our changes on top of that, but 
we felt that the integration of Ethernet support merits a release before that 
change.

Please report any issues [on our GitHub
repository](https://github.com/lowRISC/lowrisc-chip), or discuss on our
[mailing 
list](http://listmaster.pepperfish.net/cgi-bin/mailman/listinfo/lowrisc-dev-lists.lowrisc.org). 
As always, thank you to everyone who has contributed in any way - whether it's 
advice and feedback, bug reports, code, or ideas.
