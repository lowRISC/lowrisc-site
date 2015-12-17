+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Configuration parameters"
parent = "/docs/untether-v0.2/overview/"
prev = "/docs/untether-v0.2/bootload/"
showdisqus = true

+++

The default configuration parameters are listed in the table
below. All configuration parameters are located in
`src/scala/main/Configs.scala`. 

Further details on how to parameterize Rocket Chip can be found
[here](https://github.com/ucb-bar/rocket-chip#-how-can-i-parameterize-my-rocket-chip) (note that now lowRISC has its own chip generator). 
A manual describing the advanced
parameter library within Chisel is also
[available][Chisel-parameterization-manual].

| Description                          | Parameter Name | Default Value        | Possible Value (a) |
| ------------------------------------ | -------------- | -------------------- | -----------------  |
| No. of Rocket tiles                  | NTILES         | 1                    | a > 0              |
| No. of MSHRS in L1 D$                | L1D_MSHRS      | 2                    | a > 0              |
| No. of sets in L1 D$                 | L1D_SETS       | 64                   | a > 0, power of 2  |
| No. of ways in L1 D$                 | L1D_WAYS       | 4                    | a > 0, power of 2  |
| No. of sets in L1 I$                 | L1I_SETS       | 64                   | a > 0, power of 2  |
| No. of ways in L1 I$                 | L1I_WAYS       | 4                    | a > 0, power of 2  |
| Size of BTB                          | NBTBEntries    | 62                   | a > 0              |
| No. of trackers in L2$               | L2_XACTORS     | 2                    | a > 0              |
| No. of sets in L2$                   | L2_SETS        | 256                  | a > 0, power of 2  |
| No. of ways in L2$                   | L2_WAYS        | 8                    | a > 0, power of 2  |
| No. of banks in L2$                  | NBANKS         | 1                    | a > 0, power of 2  |
| Instantiate FPU?                     | BuildFPU       | true                 | true/false         |
| No. of memory sections               | NMemSections   | 2                    | 0 < a <= 4         |
| Initial memory base                  | InitMemBase    | `0x00000000`         |                    |
| Initial memory mask                  | InitMemMask    | `0x7FFFFFFF`         |                    |
| Initial physical memory base         | InitPhyBase    | `0x00000000`         |                    |
| No. of I/O sections                  | NIOSections    | 2                    | 0 < a <= 4         |
| Initial I/O base                     | InitIOBase     | `0x80000000`         |                    |
| Initial I/O mask                     | InitIOMask     | `0x0FFFFFFF`         |                    |




<!-- Links -->

[Chisel-parameterization-manual]: https://github.com/ucb-bar/chisel/blob/master/doc/parameters/parameters.pdf

