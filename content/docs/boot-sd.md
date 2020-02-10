+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Boot SD-Card instructions"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Boot Linux using SD-Card on FPGA

| SW[7:5]             | boot mode                  |
| --------------      | :----------:               |
| 000                 | boot from SD-Card  |

The installation target by default creates a 32MB DOS partition as the first partition on the SD-Card. This is plenty
to store the Kernel and a large RAM disk, if needed. If no ram disk is present the kernel will try to mount the second partition
which is the root partition without previously checking it. This may not be robust if the system previously crashed or was powered
off without unmounting. In these circumstances, the rescue image which is normally stored in QSPI or downloaded from Ethernet
would be used.

No special action is needed to install this kernel. The 'make sdcard-install' target installs it automatically at the same time as
the root filing system.

* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})

