+++
Description = ""
date = "2016-05-16T12:00:00+00:00"
title = "Debug modules"
parent = "/docs/debug-v0.3/overview/"
prev = "/docs/debug-v0.3/interface/"
next = "/docs/debug-v0.3/softwaremethodology/"
showdisqus = true

+++

In the following we will give you a brief overview of the debug
modules employed in this release. They are all at a relatively early stage of 
implementation, but contain the basic functionality we will
extend over the next months. Please find more details about the
modules at [Open SoC Debug](http://opensocdebug.org).

## Basic Module Interface

Each module has to provide a control and status interface via
addresses that are accessed with register access packets. There is a
basic memory map that contains the following information to enable
easy system enumeration and tool adjustment to different module
versions. It includes the module type, a vendor:id pair and the
version of the module.

Beside that all modules that generate debug packets from events can be
stalled remotely by writing to a certain address. This is necessary to
mute trace modules or special modules as the UART adapter.

Finally, each module can provide more control and status registers,
e.g., the information about the memory layout, the reset control, etc.

## Debug Modules

### System Control Module (SCM)

The SCM is the only mandatory module. One of its main functions is to
provide the *system information*:

 * A system ID, which can be used by debug tools to identify the
   hardware platform

 * The total number of debug modules

 * The maximum length of debug packets supported by this platform

Beside this, the module exposes a register where the lower two bits
drive two pins: The `sys_rst` reset the entire system and `cpu_rst`
resets only the CPUs. The general use case of this register is to
assert `sys_rst` and `cpu_rst` by the host and immediately de-assert
`sys_rst` while holding `cpu_rst`. Next, the debug tool can initialize
the memory, configure the trace modules, etc. Finally, it de-asserts
`cpu_rst` to start the processors.

<a name="figure-scm"></a>
<img src="../figures/debug_module_scm.png" alt="SCM" style="padding: 20px 0px;"/>

### Memory Access Module (MAM)

The memory access module is connected to the TileLink interconnect
between the L1 caches and the L2 cache, which is the last level
cache. Thereby it is ensured that no data is written or read
incoherent to the caches. The host can read and write single words
with a byte strobe or read and write bursts of words.

In this tutorial we use the MAM to initialize the memory, but the use
cases are not limited to this.

<a name="figure-mam"></a>
<img src="../figures/debug_module_mam.png" alt="MAM" style="padding: 20px 0px;"/>

### Device Emulation Module - UART (DEM-UART)

The DEM-UART module is hooked up in the IO subsystem of lowRISC
instead of the UART controller and has the same interface as the UART
(16550). There are two reasons why UART is now implemented that way:

 * On the FPGA board the physical UART is actually needed for the
   debug interface

 * The terminal can directly be integrated into the debug tools
   without any further ado around the tty device

In future we plan to have multiple memory-mapped serial devices
multiplexed into one DEM-UART, which can be assigned to different
processors or processes.

<a name="figure-dem-uart"></a>
<img src="../figures/debug_module_dem-uart.png" alt="DEM-UART" style="padding: 20px 0px;"/>

### Core Trace Module (CTM)

A core trace is essentially sampling the execution of the processor
core. The size of the sampled information can vary a lot, including
the information about taken branches, executed program counters,
register accesses, cache misses, branch predictor misses, just to
mention a few. In this basic version we track the signals depicted in
the figure to generate two kinds of trace events: 

 * All *execution mode changes* (machine mode and user mode) are
   detected. This can be used to determine time spent in the kernel or
   to update the information about the currently running thread.

 * All *function calls*, i.e., whenever a function is entered or
   left. We track the `jal` and `jalr` signals in accordance to the
   calling convention (so that this does not cover all hand-written
   assembly), but still this is speculative and the ELF is needed to
   determine which of the jumps were actually related.

This already generates a high volume of trace events and with
increasing information, better filtering and
compression will be mandatory to take full advantage of tracing.

<a name="figure-ctm"></a>
<img src="../figures/debug_module_ctm.png" alt="CTM" style="padding: 20px 0px;"/>

### Software Trace Module (STM)

We introduce another kind of trace beside the core trace. The latter
is generated independently from the actual software and is thereby
non-intrusive. A better directed approach is to instrument the
software with trace events, for example you could instrument your DMA
driver like this:

    uint8_t *buffer = malloc(42);
    TRACE(TRACE_DMA_BUFFER, buffer);

    TRACE(TRACE_DMA_START, slotid);
    TRACE(TRACE_DMA_START, src);
    TRACE(TRACE_DMA_START, buffer);

    dma_transfer(slotid,incoming,buffer);

    TRACE(TRACE_DMA_FINISH, slotid);

Each software trace event consists of a 16-bit *id*
(`TRACE_DMA_BUFFER` etc.) and an `XLEN`-sized *value* (here: 64
bit). This reduces the amount of necessary trace events
significantly. The approach can be compared to `printf` debugging, but
has a much smaller impact in the form of extra instructions. Instead
each trace event is two instructions:

    /* Write value to a0 (first parameter) register */
    asm volatile ("mv a0,%0": :"r" ((uint64_t)value) : "a0");
	/* Write id to the STM CSR register */
    asm volatile ("csrw 0x8ff, %0" :: "r"(id));

This sequence can also be emitted by user applications while still
being thread safe (the register access will be restored and the CSR
access is atomic). All accesses to the register are tracked and also
stored. When the CSR access occurs the event is then emitted with the
value stored in the STM.

Finally, the STM contains a configurable comparator that tracks all
changes to a configured user register. This can be used to track
accesses to the thread local storage pointer or similar, but this
functionality is not used in this tutorial.

The following figure sketches the interface between the Rocket core
and the STM.

<a name="figure-stm"></a>
<img src="../figures/debug_module_stm.png" alt="STM" style="padding: 20px 0px;"/>

