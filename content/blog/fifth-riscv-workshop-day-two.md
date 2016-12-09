+++
Description = ""
date = "2016-11-30T17:00:00+00:00"
title = "Fifth RISC-V Workshop: Day Two"

+++
Today is the second day of the [fifth RISC-V 
workshop](https://riscv.org/2016/10/5th-risc-v-workshop-agenda/). I'll be 
keeping a semi-live blog of talks and announcements throughout the day.

## OpenSoC System Architect: Farzad Fatollahi-Fard
* Current architectures are wasteful. Only a small fraction of chip area goes 
to computation.
* For both GoblinCore and OpenHPC, ended up doing a lot of similar work to 
achieve only a point design. Why not make a generator to avoid repeating the 
same steps?
* OpenSoC System Architect is a combination of multiple tools to form a 
well-defined development flow for complex RISC-V SoCs
* Supports standard RISC-V modules and custom extensions
* It outputs pre-verified Chisel for the SoC, synthesisable Verilog, and an 
LLVM compiler for the SoC
* OpenSoC Fabric is an open-source, flexible, parameterised NoC generator. It 
integrates with a wide variety of existing processors, as well as IO devices.
* Created a 'CoreGen' IR. It allows automatic generation of HDL 
representations of the SoC and build LLVM compiler backend implementations of 
the SoC and any extensions.
* The IR is stored on disk in well-formed XML
* What's next? Better support for Chisel3, more integration with existing 
RISC-V tools and environment, frontend support to import existing 
Chisel/Verilog/SystemVerilog. Also want CoreGen as a standalone IR
* See the website at http://www.opensoc.community/

## V Vector Extension Proposal: Krste Asanovic
* The vector extension intends to scale to all reasonable design points 
(low-cost microcontroller or high-performance supercomputer). Support both 
implicit auto-vectorisation and explicit SPMD
* Fit into the 32-bit encoding space, but be a base for future vector 
extensions (e.g. crypto algorithms)
* The goal is to ratify a proposal 12 months from now, at the 7th workshop
* Cray-style vectors. "The right way" to exploit SIMD parallelism (as opposed 
to the wrong way: GPUs or packed SIMD)
* V has an implementation-dependent vector length, meaning the same code runs 
across different hardware without recompiling
* Each vector data register is configured with a width and type, or disabled.
There are also a configurable number of predicate registers. The maximum 
vector length is a function of configuration, physical register storage, and 
microarchitecture
* There are a number of mandatory supported types. e.g. an RV32IF system must 
support X8, X16, X32, F16, F32. This means that scalar and vector half 
precision floating point is a requirement if you are supporting floating 
point.
* Each vector data register has a 4-bit field in a CSR (or multiple CSRs) 
indicating its width, and another for its type.
* A vcfgd CSR alias is defined to allow faster writes of common vector data 
configurations.
* Most user code would use the setvl instruction (which is actually setting a 
CSR).
* A 16-bit+32-bit vector addition is pleasingly straight forward to specify in 
assembly
* The architecture guarantees a minimum vector length of four regardless of 
configuration. This means 1KB SRAM is required as a minimum
* A polymorphic instruction encoding is used. A single signed integer ADD 
opcode works on different size inputs and outputs, depending on the 
configuration of its inputs.
* There is support for vector atomics (e.g. vector fetch-and-add).
* For vector function calls (e.g. in auto-vectorised code) you want to make 
vector calls to a function library with separate vector calling convention.
The caller has to allocate registers for the callee to use. It sets the 
maximum width, allowing the callee to change the vctype as needed.
* For OpenCL/CUDA/SPMD, the configuration must be set at kernel launch to the 
maximum width used anywhere in the call tree. It needs a general vector 
function call capability with standard callee/caller save protocol
* Krste argues autovectorisation is much preferable to OpenCL or CUDA.
* Question: are you interested in smaller types (e.g. 4-bit). Answer: yes, 
also interested in non-power-of-two types
* Question about the calling convention: the vector configuration state is 
assumed to be caller-saved (including the vector register file), meaning the 
scalar ABI is unmodified

## Towards Thousand-Core RISC-V Shared Memory Systems: Quan Nguyen
* Tardis is a new cache coherency protocol with greater scalability than 
traditional directory coherence protocols.
* Tardis enforces consistency through timestamps, using logical leases
* It only tracks the exclusive owner of any particular cache line, requiring 
only O(log N) storage. No broadcast invalidations, and timestamps aren't tied 
to the core count. There is no need for synchronised real-time clocks
* They are building a thousand-core prototype. Fit as many cores as possible 
on a ZC706 FPGA, the connect in a 3D mesh to demonstrate at scale.
* Want to adapt Tardis for release consistency (rather than sequential 
consistency), and Quan introduces how they have started to do this by 
introducing new timestamps

## SCRx: a family of state-of-the art RISC-V synthesizable cores: Alexander Redkin
* Syntacore develops and licenses energy-efficient programmable cores 
implementing the RISC-V ISA
* SCRx is the family of RISC-V implementations, now available for evaluation.
Each core can be extended and customised
* The smallest core, SCR1 is less than 20kgates in a basic untethered 
configuration.
* SCR3 is a high-performance MCU core with up to 1.7DMIPS/MHz, 
3.16CoreMark/MHz.
* SCR4 is an MCU core with a high-performance FPU.
* SCR5 is an efficient mid-range embedded core. Full MMU with Linux support.
1GHz+ at 28nm, and 1.5+DMIPS/MHz per core.
* In the near term, want to support the latest privileged spec, adding trace 
debug

## Enabling hardware/software co-design with RISC-V and LLVM: Alex Bradbury
* I'll try and write something up for the blog later, but for now see my 
slides 
[here](https://speakerdeck.com/asb/software-co-design-with-risc-v-and-llvm).

## VM threads: an alternative model for virtual machines on RISC-VM: Ron Minnich
* Akaros is a research kernel originally from UC Berkeley.
* One core idea is the 'multi core process'. This can be thought of as a set 
of cores assigned an entity to a program.
* How do VMs fit into the Akaros model. A VM could be kind of a process.
* Look back at how we start a process. With the introduction of fork(), it 
became easy and clean. But its introduction was controversial.
* Virtualisation on Linux/BSD/Unix requires a device (e.g. /dev/kvm). This 
typically requires daemons who are used to interact with the device. In 
Akaros, they did not want to recreate this.
* Can we just run a virtual machine like we do a thread? Introduce 
`vthread_create`. In Akaros, they have extended the thread model to include 
virtual machine threads.
* Virtual machine threads (vthreads) can run Linux 4.8 (with 12 lines of 
patches) and any code that shares the host ring 3 address space.
* Ring 3 and Ring V share and address space. Ring V is limited to 2^46 bytes, 
while ring 3 is in a 2^47 byte address space.
* VM threads are integrated tightly into the kernel.
* On x86, Akaros pairs page table roots and page table pages. Page table pages 
are 2x4k pages, with the process PTP in the lower 4K and the VM PTP in the 
upper 4K. This makes it trivial to convert the two.
* It is significantly easier to write virtual machine managers in Akaros than 
with the Linux model
* Akaros VMS are unlike any other VMs - threads can easily switch from being a 
VM to being a host thread
* Kernels also look like threads, and spinning up a core looks like CPU 
hotplug, accomplished by spinning up a vthread with IP at the 64-bit entry 
point.
* There are a variety of implications and questions for RISC-V. How will 
RISC-V handle nested paging? Can we avoid massive shadow state. How about 
injecting interrupts without a vmexit?
* RISC-V is a chance to enable software innovation. We shouldn't get locked 
into "but we've always done it this way".

## Enabling low-power, smartphone-like graphical UIs for RISC-V SoCs: Michael Gielda
* Industrial/embedded UIs mostly look bad, but also have terribly user 
experience
* For better UIs you mostly have to jump to Android or Linux - there's a lack 
of a middle ground
* For a previous project, produced a mobile-like GUI experience targeting an 
MCU (STM32F4).
* With the right approach and tools, embedded GUIs can be beautiful too
* Their library was written in C++, with support for layers+formats. It has 
its own font engine for kerning, anti-aliasing etc.
* The GUI is specified in XML and has its own minimal CSS
* Initially developed for eCos RTOS, and has an initial port for FreeRTOS. Can 
also run on Linux.
* To prototype on a Zynq, implemented 'micro blender' for blending, filling, 
scaling etc. This was written in Chisel.
* Software-driven IP (silicon) is possible (and advisable!)

## A Fast Instruction Set Simulator for RISC-V: Maxim Maslov
* Esperanto is a stealth mode startup designing chips with RISC-V
* Wanted a fast RISC-V ISA simulator capable of running large applications 
with minimal slowdown
* [Sorry folks, I had to duck out for a quick discussion - see the 
[slides](https://riscv.org/wp-content/uploads/2016/11/Wed1330-Fast-ISA-Simulator-for-RISC-V-Maslov-Esperanto.pdf)]

## Go on RV64G: Benjamin Barenblat and Michael Pratt
* Why RISC-V? Better architecture, lower power, faster processing, easier 
accelerator development. RISC-V is not going away
* The Go toolchain is complex. It has its own compiler, assembler (and 
assembly language), and linker
* Getting close, but the runtime doesn't quite compile. Hope to get it working 
in the next few months.
* In the mean time, relatively simple go programs will compile and run
* It's been mostly good. One pain-point has been that other Go ports don't 
target architectures with good conditional branches so had to emulate a flag 
register. Another gripe is that loading 64-bit constants is a pain.
* Within a couple of months you should be able to compile real Go programs and 
have them run on RISC-V

## A Java Virtual Machine for RISC-V: Porting the Jikes RVM: Martin Maas
* Why do a JVM port? Both to run interesting applications, and for research 
(e.g. hardware support for GCed languages)
* Porting OpenJDK/Hotspot for high performance, and the Jikes research VM for 
academic work. This talk will focus on Jikes
* Jikes is itself written in Java
* JVMs have a large number of dependencies, so use the riscv-poky Linux 
distribution generator to build a cross-compiled SDK and Linux image.
* While developing, add assertions everywhere to fail as early as possible
* Allowed the JIT to selectively emit instructions that dump trace output
* Booting JikesRVM is no easy task (there a _lot_ to do in order to get to 
hello world)
* The non-optimising JIT compiler is mostly feature-complete. Passes 65/68 
core tests. Targets RV64G

## YoPuzzle - an Open-V development platform the next generation: Elkim Roa
* 'Open source' hardware. Raspberry Pi have sold 10 million boards, Arduino 
sold 4.5 million boards (estimated). Some predictions indicate the market will 
be worth over $1B within the next four years. These are based on commercial, 
closed-source silicon
* OnChip UIS have developed an open 32-bit RISC-V based microcontroller. To 
test the initial silicon, used chip-on-board
* RV32IM with a 3-stage pipeline. On TSMC 130nm GP. Die area 2.1mm x 2.1mm.
* The Microprocessor core is 0.12mm2, max freq 200MHz, core voltage 1.2V, core 
dynamic power at 100MHz is 167uW/MHz (all peripheral clocks disabled)
* Arduino is mostly aimed at children in secondary schools. But what about 
1-10 year olds?
* The Open-V microcontroller is up on crowdsupply, trying to raise funds to 
produce 70k chips. Aim to do the second tapeout in Q1 2017, and produce puzzle 
boards in Q2 2018.
* Elkim showed a neat live demo of the OnChip prototype along with a 
browser-based programming environment

## The RISC-V community needs peripheral cores: Elkim Roa
* It's good to have an open ISA, but what about the peripherals? e.g. PHYs, 
bus IP, clocking circuitry, GPIO
* Open hardware would translate into quality (Linux) drivers
* There is no standard for GPIO. Want to have standard features (e.g.
switching speed, current drive) with a standard interface.
* The OnChip peripherals use AMBA buses
* Have a synthesizable CDR and PLL
* Are working on USB 3.1 gen 2, including the analog frontend.
* Have also been working on 'chipscope' and offset correction
* Also working on LPDDR3. PCS is done, working on UVM IP
* Have a fully synthesised true-random noise generator, and working on NVRAM 
on CMOS
* Suggestion: have a common listing of recommended IP (e.g. SPI, I2C, USB PHY 
etc).

## Sub-microsecond Adaptive Voltage Scaling in a 28nm RISC-V SoCs: Ben Keller
* Energy efficiency is critical in mobile applications
* Faster adaptive voltage scaling (AVS) saves more energy, especially for 
bursty workloads
* State of the art SoCs cannot achieve fine-grained AVS because they use 
off-chip regulators
* Integrate switch-cap regulators entirely on-die.
* Need adaptive clock generation
* The tape-out (~2 years ago) featured a version of Rocket. 16K I$, 32K D$, no 
L2. It also feature a version of Hwacha
* Use a Z-scale core for the power management unit
* Taped out in 28nm FD-SOI. Die area 3.03mm2, with the core area 1.07mm2. 568K 
standard cells
* Achieved 41.8 DP GFLOPS/W
* Body bias can be tuned to optimise efficiency for different workloads
* Integrated voltage regulation provided 82-89% system efficiency with 
adaptive clocking
* Sub-microsecond adaptive voltage scaling provided up to 40% energy savings 
with negligible performance loss
* Will now talk about the Berkeley interpretation of 'agile' hardware 
development. See "An Agile Approach to Building RISC-V Microprocessors", MICRO 
2016.
* 'Tape-ins' before 'tape-outs'. Sprint to an initial design that is 
feature-incomplete but functional, put it through the tools etc and shake out 
the issues with the VLSI flow. Then iteratively add features.
* There have been 13 Berkeley RISC-V tapeouts in the last 5 years

## Reprogrammable Redundancy for Cache Vmin Reduction in a 28nm RISC-V Processor: Brian Zimmer
* Voltage scaling is effective in reducing energy consumption, and SRAM limits 
the minimum operating voltage
* Instead of preventing errors, tolerate errors. A significant reduction in 
the minimum voltage is possibly by tolerating 1000s of errors per MB of SRAM
* There's been lots of work on the circuit-level for preventing errors, and at 
the architectural level for tolerating errors
* Goal for the chip is to prove that SRAM Vmin can be effectively lowered by 
tolerating a reasonable number of failing bitcells
* Built on Rocket and modified caches to add reprogrammable redundancy, ECC, 
and BIST
* Implemented three techniques: dynamic column redundancy (avoid single-bit 
errors in data SRAM), line disable (avoid `>=` 2 bit errors in data SRAM), and 
bit bypass (avoid all errors in tag SRAM)
* The system architecture involves three voltage domains. One for the uncore, 
one for the core, and another for the L2 cache
* Reprogrammable redundancy is fairly straight-forward to add to the L1, but 
ECC is more difficult. The ECC decoding is pipelined. If an error is detected, 
the operation is recycled
* There is a 2% area overhead for the L2.
* Fabricated prototype is TSMC 28nm HPM.
* The proposed techniques achieve 25% average Vmin reduction (and 49% power 
reduction) in the L2 for a 2% area overhead
