+++
Description = ""
date = "2016-01-06T17:05:57+00:00"
title = "Third RISC-V Workshop: Day Two"

+++
Today is the second day of the [third RISC-V 
workshop](https://riscv.org/2015/12/prelim-agenda-3rd-risc-v-workshop/). Again, I'll be keeping a
semi-live blog of talks and announcements throughout the day. See
[here](https://www.lowrisc.org/blog/2016/01/third-risc-v-workshop-day-one) for
notes from the first day.


## RISC-V ASIC and FPGA implementations: Richard Herveille
* Look for freedom of design. Want to free migrate between FPGAs, structured 
ASICs, standard cell ASICs
* Want to make it easier to migrate FPGAs to ASICs for advantages in price, 
performance, power, IP protection.
* Roa Logic's RV32I/64 implementations are called RV11 and RV22. RV11 is 
in-order, single-issue, single thread. RV22 is in-order, dual-issue and dual 
thread.
* Implement a 'folded' optimizing 5-stage pipeline, where some classic RISC 
stages are folded together for performance improvement. e.g. the instruction 
decode stage decides if the instruction sequence can be optimized.
* Ported a debug unit for or1k from OpenCores
* Mostly target the eASIC nextreme platform. Start with an existing FPGA 
design, then transfer.
* Achieved Fmax of 649MHz (32-bit core) on a nextreme-3, vs 114MHz on the customer's 
current CYCLONE-V. Achieved a 70% power reduction.
* Next steps are to improve resource utilization, increase offering of 
extensions, and add multi-threading and multi-issue.

## lowRISC: plans for RISC-V in 2016: Alex Bradbury
* Find my slides 
[here](https://speakerdeck.com/asb/lowrisc-plans-for-risc-v-in-2016).
Apologies for not live-blogging my own talk.

## A 32-bit 100MHz RISC-V microcontroller with 10-bit SAR ADC in 130nm GP: Elkim Roa
* Current goal: a low-footprint RISC-V microcontroller like EFM32 or SAMD11 
with USB low-speed PHY on-chip.
* Looked at picorv32 and vscale, but ultimately implemented their own 
implementation. Also adding in a 10-bit SAR ADC, DAC, PLL, GPIO.
* Implement RV32IM using a 3-stage pipeline. IRQ handling is adapted from the 
picorv32 timer.
* Provides AXI-4 lite and an APB bridge.
* SAR ADC intends to be fully synthesizable, 10-bit 10MHz.
* The chip was taped out in October 2015 on 130nm TSMC GP. The core+interfaces 
area was 800um x 480um.
* Undertook a large effort on verification, implemented verification 
testbenches for AXI-4 and APB peripheral functionality. Would like to partner 
to get access to proven VIP.
* Future work to be done on a USB PHY low-speed interface, DMA channels, 
watchdog timer, eNVM 1-poly ROM
* Question: where and when can I download it? Soon! Still cleaning it up.

## SoC for satelline navigation unit based on the RISC-V single-core Rocket chip: Sergei Khabarov
* Currently have an RF-mezzanine card for FPGA prototypes, and 
silicon-verified GNSS IP and ASIC development board with a LEON3 CPU inside.
* On the software, have universal receive firmware and plug-and-play support 
for different targets. Plus a host application for data analysis. See 
gnss-snsor.com.
* Now transitioning from the previous 180nm ASIC to a new 90nm chip with a 
RISC-V core. The target frequency is 300MHz.
* The new SoC design aims to take the best ideas of the GPL-licensed grlib 
library (Gaisler Research) and will be written in VHDL.
* Current code can be found [here](https://github.com/sergeykhbr/riscv_vhdl).
* Plug and play approach taken from grlib to help quickly assemble a complex 
SoC design. Device ID, vendor ID, address and interrupt configuration, 
cacheability etc etc routed in sideband signals accessible via a dedicated 
slave device on a system bus.
* Some memory access optimizations have been implemented to allow access to 
AXI peripherals in one clock cycle.
* Implemented (or implementing?) the multi-core debug protocol, potentially 
supported by Trace32 (Lauterbach).

## RISC-V photonic processor: Chen Sun
* Process scaling has helped massively for data transfer within a chip, but 
we've had little improvement for moving data off-chip.
* The I/O wall involves being both power and pin limited. Silicon photonics 
may help overcome this.
* Started by tring to provide DRAM connected by photonics (as part of the 
DARPA POEM project).
* What about the foundry? Do it without a foundry. How to connect electronics 
and photonics? Put them on the same chip. Where are you going to get a 
processor? RISC-V!
* They produced it and it was published in Nature last month. Dual-core 
1.65GHz RISC-V. Manufactured in a commercial SOI process.
* Build a waveguide with planar silicon processing. Silicon is the high-index 
core. Oxides form the low-index cladding.
* Transmitter is driven by a CMOS logic inverter. 5Gb/s data rate at 30fj/b.
* Issue with ring resonators is massive variation based on process and 
temperature variation. Need to stabilise this some-how. Add thermal tuning.
* To demonstrate the optical memory system, had a second chip emulating a DRAM 
controller.
* We proposed an architecture, built it, and got performance competitive to 
our predictions!

## Untethering the RISC-V Rocket Chip: Wei Song
* Rocket is an open-source SoC generator from Berkeley. The base Rocket core 
is a 5/6 stage single-issue in-order processor.
* Previously an host-target interface was connected to the L2 bus which 
communicates with an ARM core on the Zynq to provide peripherals.
* The untethered Rocket chip adds a separate I/O bus. Currently uses Xilinx IP 
for peripherals. First stage bootloader is on FPGA block RAM, second stage 
bootloader is loaded from SD. I/O read and write are totally uncached.
* The top-level (including I/O devices) is all in System Verilog. There is a 
separate 'Chisel island' containing the Rocket interface.
* The I/O and memory maps can be configured by CSRs.
* The first-stage bootloader copies the second stage to DRAM, performing an 
uncached copy. It then remaps the DRAM to memory address 0, resets Rocket and 
starts the second stage. The second stage uses a version of the Berkeley 
bootloader. It starts multi-core, VM support, then loads and boots RISC-V 
Linux in a virtual address space.
* Currently the second stage bootloader stays resident to handle HTIF 
requests.
* Our code release contains a very detailed tutorial. Key features include 
support for the Nexys4 as well as the more expensive KC705. You can also use 
Verilator for simulation and a free WebPACK Vivado license.
* The code release includes a rewritten TileLink/NASTI interface, DDR2/3 
controller, SD, UART.
* Future work: re-integrate tagged memory, remove HTIF from Linux kernel (help 
wanted), interrupt controller, trace debugger (Stefan Wallentowitz), 
run-control debug (SiFive), platform spec.

## MIT's RISCY expedition: Andy Wright
* MIT implemented an IMAFD 64-bit RISC-V processor in Bluespec System Verilog.
It supports machine, supervisor, and user modes, boots Linux, and has been 
tandem-verified with Spike.
* Want to work on formal specification of the ISA, formally verified processor 
implementations, memory consistency models, accelerators, microarchitecture 
exploration, VLSI implementations using a standard ASIC flow.
* Philosophy: get a working processor first, figure out why it's slow, and 
make it faster without breaking it.
* Moving to work on formal verification, which requests a formal specification 
for RISC-V. Lots of questions to be answered, e.g. whether referenced bits in 
page table entries should be set for speculatively accessed pages.
* A single instruction can result in up to 13 effective memory accesses - how 
do these interact with each other, and how do they influence the memory model?
* Want simple operational definitions where legal behaviours can be observable 
on a simple abstract machine consisting of cores and a shared monolithic 
memory.
* Looked at defining WMM, a new easy-to-specify weak consistency model.
* Propose there should be a new instruction similar to sfence.vm, but going in 
the opposite direction.
* See also [their website](http://csg.csail.mit.edu/riscy-e/).
* Question: will it be open source? Concerned currently because some aspects 
of the design are used as challenges for student projects and releasing it 
could compromise the projects.

## Pydgin for RISC-V, a fast and productive instruction-set simulator: Berkin Ilbeyi
* Simple interpreted instruction set simulators get 1-10MIPS of performance.
Typical dynamic binary translation may achieve 100s of MIPS, with QEMU 
achieving up to 1000 MIPS.
* Another aspect worthy of consideration is productivity when working with the 
simulator, for instance when looking to extend it to explore new hardware 
features. Can you achieve high developer productivity and runtime performance?
* Observe there are similar productivity-performance challenges for building 
high performance language runtimes as for simulators. e.g. the PyPy project.
* Pydgin uses PyPy's RPython framework.
* Pydgin describes its own architectural description language (really a Python 
DSL).
* Pydgin running on a standard Python interpreter gives ~100KIPS. But when 
going through RPython this gives 10MIPS. When targeting the RPython JIT, 
adding extra RPython JIT hints are added achieved up to a 23x performance 
improvement over no annotations.
* Performs 2-3x better than Spike for many workloads. Spike caches decoded 
instructions and uses PC-indexed dispatch to improve performance.
* Achieved a 100MIPS+ RISC-V port after 9 days of development.
* Pydgin is used in the Cornell research group to gain statistics for 
software-defined regions, experimentations with data-structure specialisation, 
control and memory divergence for SIMD, and more.
* Pydgin is [online at Github](https://github.com/cornell-brg/pydgin).

## ORCA, FPGA-optimized RISC-V soft processors: Guy Lemieux
* ORCA is completely open-source. See it [at 
Github](https://github.com/cornell-brg/pydgin).
* Initially targeted the Lattice iCE40 (3.5kLUTs, under $5 in low quantities).
* RV32M implemented in 2kLUTs at around 20MHz on the iCE40.
* ORCA is highly parameterized, ideally suitable for FPGAs, portable across 
FPGA vendors, and BSD-licensed.
* Achieved 244MHz, 212MIPS on an Altera Stratix-V. Lots of room for further 
improvements.
* Clock speed is close to matching the picorv32 clock speed, but with higher 
DMIPS/MHz.
* Found 64-bit vs 32-bit counters added a lot of area.
* A good FPGA implementation often leads to a good ASIC implementation, but a 
good ASIC implementation often leads to a poor FPGA implementation.
* Use dual-ported block RAMS on the FPGA for the register file.
* Observe that reduced register count in RV32E makes no difference for FPGAs.
Divide is very expensive.
* Beware when writing software, a shift could be as slow as 1b/cycle.
* The privileged architecture spec contains too many CSRs and the 64bit 
counters are too big, putting pressure on multiplexers. For FPGAs, perhaps 
defined small/med/full versions.

## PULPino, a small single-core RISC-V SoC: Andreas Traber
* PULP and PULPino developed at ETH Zurich and University of Bologna with many 
partners.
* Develop an ultra low power processor for computing IoT. Explot parallelism 
using multiple small simple cores organised in clusters.
* Share memory within the cluster.
* Support near-threshold operation for very low power.
* PULP has been taped out over a dozen times across multiple process 
technologies, down to 28nm.
* PULP has a large number of IPs. To start with, open source PULPino as a 
starting point.
* PULPino is a microcontroller-style platform. No caches, no memory hierarchy, 
no DMA. It re-uses IP from the PULP project and will be taped out in 65nm UMC.
* The boot ROM loads a program from SPI flash.
* Motivated to switch to RISC-V due to more modern design (no set flags, no 
delay slot), compressed instructions, easily extensible.
* Looking to extend RISC-V with non-standard extensions for hardware loops, 
post-increment load+store, multiply-accumulate, ALU extensions (min, max 
absolute value).
* RI5CY core has full support for RV32I, implements just the mul from RV32M.
It has a 4 stage pipeline.
* Performed a comparison based on published Cortex M4 numbers. RI5CY is a 
little faster and a little smaller.
* The RI5CY core itself is just 7% of the area of a PULPino SoC (assuming 
32KiB instruction and data RAM).
* Open source release will follow shortly, including a FreeRTOS port. Using 
the Solderpad license. Just awaiting final approval from the University 
(expected by the end of the month).
* Want to port PULPino to IP-XACT. Also want to add floating point support, 
branch prediction, and evaluate further non-standard ISA extensions.

## The Berkeley Out-of-Order Machine (BOOM): Christopher Celio
* An out-of-order core. It's synthesizable, parameterizable, and open-source.
* Out-of-order is great for tolerating variable latencies, finding 
instruction-level parallelism, and working with poor compilers or lazily 
written code.
* Downsides are it's more complex and potentially expensive in area and power.
* Should work as an interesting baseline for micro-architecture research. Also 
enables research that need and out of order core (e.g. on memory systems, 
accelerators, VLSI methodologies).
* BOOM implements IMAFD and the RV64G+ privileged spec.
* The RISC-V ISA is easy to implement. Relaxed memory model, accrued FP 
exception flags, no integer side-effects (e.g. condition codes), no cmov or 
predication, no implicit register specifiers, rs1+rs2+rs3+rd are always in the 
same space allowing decode and rename to proceed in parallel.
* As Rocket-chip gets better, so does BOOM.
* The host-target interface is being removed from rocket-chip to provide an 
untethered system.
* BOOM has a unified physical register file (floating point and integer).
* Masses of parameters can be tweaked.
* 2-wide BOOM with 16KiB L1 caches 1.2mm2 in TSMC 45nm. Can clock at 1.5GHz 
for two-wide.
* Currently designed for single-cycle SRAM access as the critical path.
* Planning on a tapeout later this year.
* Achieve 50MHz on an FPGA where the bottleneck is the FPGA tools can't 
register-rename the FPU.
* BOOM is 9kloc, plus 11kloc from Rocket.
* 9% CoreMarks/MHz for ARM Cortex-A9 with similar architectural parameters and 
smaller (but lacking the NEON unit). Power is also similar based on public 
numbers.
* Don't yet have a SPEC score. Need more DRAM on the FPGA and DRAM emulation.
With a cluster of FPGAs, this should only take about a day to run.
* BOOM-chip is currently a branch of rocket-chip. See the slides for how to 
get going.
* Currently test/verify using riscv-tests, coremark, spec, and the 
riscv-torture tool.
* riscv-torture, a randomised test generator was open-sourced yesterday. If it 
finds a bug, it will minimise the program for you.
* A design document is a work in progress up on github.com/ccelio (doesn't 
seem to be published yet?)
* Want to grow a community of "baby BOOMers" :)

## Bluespec's "RISC-V Factory": Rishiyur Nikhil
* Bluespec's 'RISC-V Factory' is aimed at organisations who want to create 
their own RISC-V based CPUs or SoCs without the usual learning curve, startup 
costs, and ownership costs.
* Currently working with Draper on the DOVER project we'll be hearing about in 
the next talk.
* The Flute RISC-V CPU has interfaces for direct GDB control, an elastic 
(latency-insensitive) pipeline, hooks for optional tagged data.
* Have components such as interconnect, memory controller, DMA engine, 
devices. Working on flash for booting and Ethernet.
* Provide a complete development and verification environment.

## DOVER, a metadata-extended RISC-V: Andre DeHon
* Current computer systems are insecure, and the processor architecture 
contributes by blinding running code and making the secure and safe thing 
expensive.
* Add software defined metadata processing as implemented in PUMP.
* Give each word a programmable tag. This is indivisible from a word and its 
interpretation is programmable.
* PUMP is a function from (Opcode, PCtag, Instrtag, RS1tag, RS2tag, MRtag) to 
(Allowed?, PCtag, Resulttag).
* Possible policies include access control, types, fine-grained instruction 
permissions, memory safety, control flow integrity, taint tracking and 
information flow control.
* Rules are installed by software on PUMP misses. This demands metadata 
structures be immutable.
* A metadata tag can be a pointer, meaning it can point to a data structure of 
arbitrary size.
* Can support composite policies. i.e. no limit of only one policy at once.
* There are no instructions to read or write metadata, i.e. no set-tag or read 
tag. All tag manipulation is done through the PUMP.
* In RISC-V use PUMP CSRs for rule inputs and outputs.
* Compared to lowRISC: lowRISC has a limited number of tag bits, tags are 
accessible to user code. Good for self-protection safety but argue it's not 
adequate to enforce policies against malicious code (i.e. code actively trying 
to circumvent protection).
* Compare to Oracle M7. M7 has a limited number of colors and a fixed policy.
* Have some global tags and rules so they have the same meaning across 
different processes.
* Idiosyncrasies about RISC-V: one instruction uses RS3, sparse opcode space 
increases table size, multiple instructions per machine word (policies want 
tagged instructions)
* Draper plans to make available Bluespec RISC-V and metadata changes, PUMP, 
set of basic micropolicies, runtime support and tools all under open source 
licenses.
* Building a consortium around Dover, an "Inherently Secure Processing Hive".
* Question: what is the overhead? Don't have figures yet for RISC-V. From 
previous work, have 10% area overhead and twice the area, 60% energy overhead.
