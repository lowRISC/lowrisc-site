+++
Description = ""
date = "2015-11-16T15:44:50+01:00"
title = "Memory and I/O maps, soft reset, and interrupts"
parent = "/docs/untether-v0.2/overview/"
prev = "/docs/untether-v0.2/mmio/"
next = "/docs/untether-v0.2/bootload/"
showdisqus = true

+++

**Note: the content of this part is subject to changes due to the lack of specification.**

The `untethered` Rocket chip starts to regulate the shared resources among cores, such as interrupts, memory and I/O maps, global timers, etc. A sub-set of control status register (CSR) space is defined as processor control registers (PCRs), whose values and accesses are shared by all cores and controlled a global PCR control unit (`PCRControl`).

<img src="../figures/pcr_ctl.png" alt="Drawing" style="width: 450px;"/>
