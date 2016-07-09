+++
Description = ""
date = "2016-07-08T11:00:00+00:00"
title = "Soc structure updates"
parent = "/docs/debug-v0.3/"
prev = "/docs/debug-v0.3/fpga/"
next = "/docs/debug-v0.3/addrmap/"
showdisqus = true

+++

Thanks to the continuous development from the RISC-V group in Berkeley, there are a lot of structure reshuffle and extra features incorporated in this release.

<a name="figure-overview"></a>
<img src="../figures/lowRISC_soc.png" alt="Drawing" style="width: 500px; padding: 20px 0px;"/>

 * **Shared TileLink MEM network for both cached (memory) accesses and uncached (IO) accesses.**
<br>In the previous untethered release, cached memory accesses and uncached IO accesses are separated early in the L1 D$, which has the benefit of small on-chip interconnects and less interference to the memory interconnect from IO transactions. However, this leads to troubles when a peripheral, such as a DMA, need to access the memory (L2 cache). This release follows the choice from RISC-V that separate uncached IO transactions from cached memory accesses at the coherent TileLink MEM network. As a result, the debug MAM module can access memory as well as all IO space by a single access point to the MEM network.

* **A global memory space regulator: address map**
<br>A static data structure is added into the Rocket-chip

*To be finished soon.*