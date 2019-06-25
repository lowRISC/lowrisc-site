+++
Description = ""
date = "2017-09-19T14:45:00+00:00"
title = "OS enablement for tagged memory (lowRISC Summer Internship 2017)"
+++

*Katherine Lim*

## Project Overview

Tagged memory in lowRISC provides (by default) a 4 bit tag per 8 byte word.
Policies are set by tagging data/instructions in memory and modifying a 64-bit 
control register called `tagctrl`. More details about tagged memory can be 
found in the [tagged memory section]({{< ref "docs/minion-v0.4/tag_core.md" 
>}})
of the tutorial for release 0.4 and in the initial lowRISC memo.

The goal of this internship was to implement OS support for user processes 
using lowRISC's tagged memory. This task had several parts. At minimum, 
multiple processes have to be able to use tags without interfering with each 
other. I also wanted to support tags being read in from a file for file-backed 
memory. Finally, I explored some ways that user programs might interface with 
the tagged memory infrastructure, such as tagging valid branch targets.

I modified both Spike and the Linux kernel throughout the project, and my 
changes can be found in branches of [lowRISC's Github 
repos](https://github.com/lowrisc/) (full details at the end of this 
document). Hopefully, my work will enable experimentation with different ways 
user processes might use tagged memory as a basic implementation for others to 
build on.

## Supporting multiple processes

To support multiple processes, I modified typical kernel abstractions used to 
provide process isolation. Specifically, this involved modifying the context 
switch code as well as certain aspects of the paging system. Tags on general 
purpose registers (GPRs) as well as the `tagctrl` register become part of a 
process's state, so they need to be preserved on context switch. Paging gives 
each process the illusion of its own address space, but in reality, physical 
pages might be shared or reallocated. When physical pages are shared for 
copy-on-write, tags must be copied along with data and when pages are 
reallocated, tags must be cleared.

### Context switch

When a context switch occurs, the value of `tagctrl` and any tags set on the 
GPRs must be saved. Additionally, when saving GPRs, `tagctrl` must be set to 
make sure tags are propagated appropriately and tag exceptions are disabled 
when performing these stores. Therefore, the context switch code must:

* Save the old `tagctrl` value
* Set `tagctrl` to enable safe propagation of all tags upon store
* Save GPRs
* Restore `tagctrl`

#### Overview

We decided on modifying the definition of the `tagctrl` register from release 
4 to make it easier to reason about tag policies at different privilege 
levels.  The `tagctrl` register is now unaliased and there are 3 different 
`tagctrl` registers (`utagctrl`, `stagctrl`, and `mtagctrl`) with each 
privilege level using a different `tagctrl` register: U-mode uses `utagctrl`, 
S-mode uses `stagctrl`, and M-mode uses `mtagctrl`.

Saving the old `tagctrl` value and setting `tagctrl` to enable safe 
propagation of tags turned out to be quite a tricky problem. Because there is 
no CSR to CSR move instruction, this sort of movement requires going through a 
GPR. When you context switch however, no GPRs are available, so you must spill 
a register before doing anything. Spilling a GPR to the stack though has the 
potential to cause exceptions. After trying several different solutions, we 
decided on adding extra scratch CSRs to spill a GPR to when saving the 
`tagctrl` registers. 

#### Spike modifications

I began by modifying Spike to have separate `utagctrl`/`stagctrl`/`mtagctrl` 
registers. To determine which one should be used for tag checking, I also 
modified instruction wrappers to check privilege level and use the appropriate 
one. 

I added extra scratch CSRs `stagctrl_scratch`/`mtagctrl_scratch` for use in 
saving and restoring `stagctrl`/`mtagctrl` on entry to a different privilege 
level before setting it to save GPRs. This was not strictly a Spike change, 
because it also involved modifying the encoding.

Finally, I modified Spike to propagate tags to/from certain CSRs. While this 
was for allowing tags to be propagated to the new scratch CSRs, it also 
brought the Spike implementation more in line with the FPGA implementation of 
tags on CSRs. The CSRs which propagate tags are listed in the tagged memory 
section of release 4.

#### Software modifications

In the kernel, to save `utagctrl` of a process and `stagctrl`, two new fields 
(`utagctrl` and `stagctrl`) were added to the `pt_reg` struct. I then modified 
the macros to save and restore `stagctrl` as appropriate and set `stagctrl` to 
disable tag exceptions and to propagate tags on load and store before saving 
all the GPRs.

In BBL, I made similar modifications to the entry and exit code except using
`mtagctrl_scratch` and `mtagctrl`. Saving registers is also done just via 
stack offsets. On every entry to machine mode, the stack pointer is decreased 
by `INTEGER_CONTEXT_SIZE + TAG_CONTEXT_SIZE` to make room to save registers, 
so I added extra space on the stack to save `mtagctrl` and `utagctrl`.

Even with the extra CSRs, this ends up being quite a fiddly process to make 
sure that `stagctrl`/`mtagctrl` are saved in a way that won't cause exceptions 
and without clobbering any data.

### Paging

#### Copy-on-write pages

Copy on write is a way for multiple processes to share a physical page even 
when the process thinks the page isn't shared. The most common use of this is 
for forking processes. The child has a separate copy of the parent's address 
space. However, the parent and the child can share the same pages until one of 
the processes writes to the page, at which point, a copy is actually made. 
Because the copied page should be indistinguishable from the original, the 
kernel needs to make sure tags are copied with the data.

Copy-on-write is handled as a specific type of page fault, so supporting 
copy-on-write involves modifying a couple of functions used in the page fault 
handling code for copy-on-write faults. I modified the function used for 
copying data for copy-on-write to have it copy tags as well

#### Clearing pages

To make sure tags don't leak from one process to another, either for security 
reasons or to avoid exceptions, tags need to be cleared from pages before they 
are reallocated to a different process. I modified the function used to clear 
pages before allocation to set the tags to 0.

Performance impact of these changes is negligible, because only a couple of 
constant time operations were added in each case.

## Delivering Tag Exceptions to user space

As part of using tags in user programs, we would like to be able to able to 
deliver tag exceptions to user space and trace back to the source of the 
exception. We decided to piggyback off of the signal infrastructure used in 
the Linux kernel and added a new code to distinguish a tag exception from 
other exceptions causing a `SIGILL`.

Under the current implementation, Spike generates a trap with the same cause 
(`CAUSE_TAG_CHECK_FAIL`) for every tag exception. You can identify that a tag 
exception has occurred in the kernel via `scause` (and then pass that to 
userspace via signal). The user program can also get the faulting address from 
the siginfo struct. However, it is impossible to identify what kind of tag 
exception occurred unless you go and read the opcode of the instruction that 
it faulted on. Implementing this would involve changing the ABI, and we 
decided we did not want to make extensive changes to the ABI at this point

## Tags on ELF binaries

We then wanted to define a mechanism for reading in tags from a file for file 
mapped memory. For this project, we decided to implement this by modifying ELF 
binaries. Future work might involve constructing a tagged filesystem, but for 
compatibility and portability we decided on ELF binaries. Currently, the 
kernel supports both tagged and non-tagged binaries and tagged binaries can 
run on non-tagged architectures. We currently support only static binaries

### Modified binaries

I decided to modify ELF binaries by adding a section with tags in it. To focus 
primarily on getting it working, I implemented the tags section as a flat 
array where there is a byte (a tag only uses 4 of the 8 bits) for each word in 
the ELF binary's virtual address space. The tag corresponding to a certain 
address can be retrieved by indexing into this section with the address.

### Kernel modifications

Because we want to set tags whenever memory whenever we page fault a page in, 
I modified the page-in code used in the kernel. The code checks if the virtual 
memory it faulted on is mapped to an ELF binary. If it is, it then checks for 
a tag section on the binary. If it finds it, then it reads in the appropriate 
tags. 

We considered several ways other read in tags. In particular, we considered 
modifying the user space loader to set tags dynamically similar to how it 
resolves library functions dynamically. However, we want to set tags whenever 
we page fault and the user space loader does not know when page faults occur.
Thus, this method would have required us to define some sort of interface 
between the user and the kernel

### Future work

This method of reading in tags from a file is not meant to be the final 
implementation. From a storage and performance perspective, there are a lot of 
improvements that can be made. In particular, it would be good to work on a 
more compact representation of the .tags section. Also, the current method of 
reading in the .tags section causes several extra disk reads on every page 
fault, which is quite a high performance overhead. This implementation also 
doesn't support dynamic binaries and shared libraries, so future work could 
focus on implementing support for these as well.

## Tags on branch targets

Tagged memory can be used to implement a simple form of control flow integrity 
by tagging valid branch targets. My focus was not so much deriving a scheme 
for control flow integrity as setting up the infrastructure to support a CFI 
scheme, which involved modifying Spike to support branch tag checking and 
logging branch targets.

### Spike modifications

I modified branch and jump instructions in Spike to tag the next PC and 
implement checks defined as defined in release 4. I also modified the loop 
that Spike uses to run instructions to `check pc_tag` and `insn_tag` when 
running as defined in release 0.4. However, because Spike doesn't really 
implement a tag pipeline, the point this check takes place isn't identical to 
the hardware tag pipeline implementation [detailed in the v0.4 lowRISC 
release]({{< ref "docs/minion-v0.4/tag_core.md" >}}).

### Capturing branch targets

To log branch targets, I added print statements to branch and jump 
instructions in Spike to print out their targets to `stderr` if the processor 
is executing in user-mode.

## Demoing New Functionality

I implemented a basic framework to put together demos. It is a bit clunky and 
hasn't been tested extensively for corner cases, but it works well enough to 
run a demo testing out the added functionality. The basic strategy is to run a 
program in Spike, log the branch targets, and then tag those branch targets in 
the ELF binary. This doesn't tag all possible targets, but should give 
something reasonably realistic for a simple demo or even benchmark. 

Note that you do need to be careful about how you set up the program for 
tracing, so the actual run of the program matches the trace. In particular, I 
had to be careful with the `tagctrl` register. Ideally, you want to be able to 
leave control checks off while running the trace. However, setting the 
`tagctrl` register can add some extra instructions, so it may be necessary to 
turn off branch exceptions in Spike instead,.

### Using the Framework
1. Run Spike, making sure to redirect `stderr` to a file for the trace
  * This means the Spike debug interface is not available, but if you’re 
  logging branch targets, probably everything is running well enough that you 
  shouldn't need the debug interface
2. Boot Spike, run your binary in Spike at the command line. Run only your 
binary in Spike, because currently there is no way to distinguish branch 
targets from different processes
3. Exit Spike and run `./parse_trace.sh`
  * `parse_trace` takes a raw trace file and outputs all the branch targets 
    between two addresses sorted in ascending order, eliminating duplicate 
    targets. The output is meant to be used by `elf_tagger`
  * Usage: `./parse_trace [input file][output file][lower limit][higher limit]`
4. Run `elf_tagger`. You may want to add this step to `make_root_spike.sh` 
after you compile your target binary, to ensure the .tags section is always 
the right size.
  * `elf_tagger` takes an ELF binary and a sorted list of tag targets to 
  produce tag section of the right size for an ELF binary. Tags the 
  appropriate words based on the addresses given as targets
  * Usage: `./elf_tagger [binary] [output tag file] [targets]`
5. Run `riscv-unknown-linux-gnu-objcopy --add-section .tags=[tag file] [ELF 
binary]` to add the `.tags` section to the binary
6. Run tagged binary in Spike

### Tests

I have modified a couple of basic examples to be used as examples of this 
framework. `stack_elf_tagged.c` and `ptr_elf_tagged.c` can both be run with 
the instructions above and then used in Spike. Branch tags protect against a 
buffer overflow attack overwriting a return address on the stack in 
`stack_elf_tagged` and protect against a buffer overflow overwriting a 
function pointer in `ptr_elf_tagged.c`.

## Future Work

### Signal handling

To fully support tag exceptions where we are able to figure out exactly what 
caused the tag exception, we most likely want to have Spike generate traps 
with different causes for each tag exception. These traps can be caught in the 
kernel and then passed up to the user signal handler via new codes or a 
new/modified field in the `siginfo` struct.

### Swap/debugging swap

Because tagging data on disk is not supported either in the swap system or the 
hardware, tags on memory must be harvested from the pages and saved manually 
and then restored when the page is swapped back in. Questions that must be 
addressed include where to store the saved tags and when to save and restore 
tags to pages

Some prior work has been done in this area by the
[Minos](http://agl.cs.unm.edu/~crandall/p359-crandall.pdf), 
[UFO](https://www.ideals.illinois.edu/bitstream/handle/2142/11287/UFO%20A%20General-Purpose%20User-Mode%20Memory%20Protection%20Technique%20for%20Application%20Use.pdf?sequence=2), 
and [CHERI](http://www.cl.cam.ac.uk/research/security/ctsrd/cheri/) projects.
All of these works use data structures in kernel memory to save tags for 
swapped out memory, harvesting the tags on page-out and restoring the tags on 
page in. 

Similar to prior works, I chose to start by storing tags in memory, using a 
flat array to store all the tags for the pages in the swap space. This is 
quite expensive from a memory perspective, and there are optimizations 
available for future work. However, the main roadblock is in getting swap 
working and testing it. 

Because Spike doesn't support block devices, I set up a ramdisk as a block 
device. Using the brd module, I created a ramdisk and formatted it as an ext2 
file system. I then created a file on the ramdisk to use as a swapfile. 
However, I found that writing to the swapfile at all has the potential to 
corrupt the ext2 filesystem. The corruption isn't consistent (though it 
happens more often than not) and can occur at different points during testing. 
It's unclear as of now whether this is a kernel bug or a Spike bug.

As this issue is not specific to tagged memory, I tried to test a similar 
configuration on FPGA to see if I would run into the same problem. However, it 
kept freezing when I put my swapfile on the SD card, and it started writing to 
the swap file. I also tried to do it with a ramdisk, but the boot process hung 
when it was supposed to be loading the brd module, so likely there is some 
issue with ramdisk on FPGA.

### libc Modifications

Supporting user programs will also mean modifying some common library 
functions such as `memcpy`, `memset`, etc. to treat tags "properly". The exact 
desired behaviour will depend on the tagging use-case. It may be enough to 
define simple versions of the functions that move tags in addition to data and 
users select which version of the function to use.  Alternately, a more 
complex scheme may be needed where some bits in the page table or in the tag 
itself determines whether or not the tags are copied with the data. 

CHERI has defined modified versions of certain library functions which could 
be helpful to reference in future implementations of library functions for 
lowRISC.

## Github Repos

* [riscv-linux](https://github.com/lowRISC/riscv-linux/tree/ctxswitch_with_tags)
  * Changes to support properly saving/restoring user context on entry/exit 
  to/from the kernel
  * Changes to support COW propagating tags and clearing pages upon allocation
  * Minor changes to support differentiating a tag exception from an illegal 
  instruction exception in the kernel
  * Added support for reading in tags from an ELF binary
* [riscv-pk](https://github.com/lowRISC/riscv-pk/tree/ctxswitch_with_tags)
  * Modifications to support properly saving/restoring user context on 
  entry/exit to/from machine mode
* [riscv-tests](https://github.com/lowrisc/riscv-tests/tree/ctxswitch_with_tags)
  * Added a couple extra tests for unaliased `tagctrl` registers, check that 
  tags propagate on the appropriate CSRs
* [riscv-gnu-toolchain](https://github.com/lowrisc/riscv-gnu-toolchain/tree/ctxswitch_with_tags)
  * Added extra scratch CSRs to the encoding
* [riscv-isa-sim](https://github.com/lowrisc/riscv-isa-sim/tree/ctxswitch_with_tags)
  * Modifications to unalias `tagctrl` 
  * Changes to propagate tags on certain CSRs
  * Added branch target checking
  * Changes to capture branch targets
* [riscv-tools](https://github.com/lowRISC/riscv-tools/tree/ctxswitch_w_tags)
  * Added binaries to test kernel changes
  * Added scripts to parse the branch target output from Spike and create a 
  file that can be added as a section
