+++
Description = ""
date = "2017-09-27T17:00:00+00:00"
title = "Moving RISC-V LLVM forwards"

+++

A high quality, upstream RISC-V backend for LLVM is perhaps the most 
frequently requested missing piece of the RISC-V software ecosystem. This 
blog post provides an update on the rapid progress we've been making towards 
that goal, outlines next steps and upcoming events, and tries to better 
explain the approach that we're taking.
As always, you 
can track status [here](https://www.lowrisc.org/llvm/status/) and find the code
[here](https://github.com/lowRISC/riscv-llvm).

## Status
I've been able to make substantial progress since the [last 
update](http://lists.llvm.org/pipermail/llvm-dev/2017-August/116709.html).

### RV32
100% of the GCC torture suite passes for RV32I at -O0, -O1, -O2, -O3, and -Os 
(after masking gcc-only tests). MC-layer (assembler) support for RV32IMAFD has 
now been implemented, as well as code generation for RV32IM.

### RV64
This is the biggest change versus my last update. LLVM recently gained support 
for parameterising backends by register size, which allows code duplication to 
be massively reduced for architectures like RISC-V. As planned, I've gone 
ahead and implemented RV64I MC-layer and code generation support making use of 
this feature. I'm happy to report that 100% of the GCC torture suite passes 
for RV64I at O1, O2, O3 and Os (and there's a single compilation failure at 
O0). I'm very grateful for Krzysztof Parzyszek's (QUIC) work on variable-sized 
register classes, which has made it possible to parameterise the backend on 
XLEN in this way. That LLVM feature was actually motivated by requirements of 
the Hexagon architecture - I think this is a great example of how we can all 
benefit by contributing upstream to projects, even across different ISAs.

### Other activities
* Community members Luís Marques and David Craven have been experimenting with 
D and Rust support respectively.
* Andes Technology have started working to contribute to this effort, and are
putting together patches for compressed instruction set support. This is a 
really positive move and I hope others will follow their lead.

### Development stats
* The 'reference' [patch queue](https://github.com/lowRISC/riscv-llvm) consists
of 48 patches, modifying 128 files and inserting over 11500 lines to the LLVM
and Clang codebases. Close to 50% of these lines are new tests.
* Other activities:
  * 8 committed patches to LLVM in areas other than lib/Target/RISCV 
  (cleanups, support code, documentation improvements, bug fixes) with 5 more 
  making their way through the review process.
  * 2 GCC/binutils bugs reported
  * RISC-V [psABI 
	doc](https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md):
	Authored 7 merged commits, 13 issues filed.

I'd like to thank [everyone](https://github.com/lowRISC/riscv-llvm#credits) 
who has contributed code review, feedback, or suggestions so far, as well as
our industrial sponsor.

## Approach and philosophy

As enthusiastic supporters of RISC-V, I think we all want to see a huge range 
of RISC-V core implementations, making different trade-offs or targeting 
different classes of applications. But we _don't_ want to see that variety in 
the RISC-V ecosystem result in dozens of different vendor-specific compiler 
toolchains and a fractured software ecosystem. Unfortunately most work on LLVM 
for RISC-V has been invested in private/proprietary code bases or short-term 
prototypes. The work described in this post has been performed out in the open
from the start, with a strong focus on code quality, testing, and on moving
development upstream as quickly as possible - i.e. a solution for the long term.

My implementation approach has been to first work towards a cleanly designed 
and well tested RV32I baseline compiler. Once the fundamentals are solid, it 
is _significantly_ easier to add in new features, optimisations, or indeed 
customisations for different RISC-V variants. This careful approach has 
enabled the rapid progress of the past few weeks. I would summarise this
approach as:

1. Ensuring (to the extent possible) that correct code is always generated for 
a simple RV32I baseline
2. Expand that baseline to support more RISC-V ISA variants (RV{32,64}IMA and 
later FD)
3. Push forwards on optimisations (generated code quality) and compiler 
feature support. Part of this work is moving to larger scale test programs and 
benchmarks in order to maintain confidence about the correctness of generated 
code.

This project is currently in the process of moving from point 2) to point 3) 
on the list above. As it stands, you will benefit from LLVM's many middle-end 
optimisations, but the final code generation stage has seen little work 
focused on the performance of generated code. With a high quality base now in 
place, adding these optimisations can be done relatively easily.

If you want to see first-class support for RISC-V in LLVM, now is the time to
get involved and help make it happen.

## Roadmap and upcoming events

My aim is to have Clang and LLVM developed to serve as a competitive
alternative to GCC on RISC-V by the end of the calendar year. If the RISC-V
community works together, this is an achievable goal.

My near-term goals are:

* Expand testing for RV64. There are rather few RV64 unit tests right now 
because parameterising the backend by XLEN mostly "just worked".
* Go through the implementation again (particularly recently added code) to 
look for further cleanup or refactoring opportunities, then propose to merge 
it upstream.
* Once I'm happy with the implementation approach for the most recently added 
features, move the 5.0-based 
[riscv-llvm-integration](http://github.com/lowrisc/riscv-llvm-integration) 
tree forwards.
* Review patches from contributors such as Andes and help to support language 
port efforts.

Focus areas after that include:

* Clang toolchain driver, MAFD codegen and ABI support
* Benchmarking vs RISC-V GCC and generated code quality improvements
* Documentation, expanded test cases, and improved compiler testing tooling

I've mapped out a number of TODO items
[here](https://github.com/lowRISC/riscv-llvm/issues).

I'm pleased to report that my proposal for a RISC-V "birds of a feather" 
session at the [upcoming LLVM Dev 
Meeting](http://llvm.org/devmtg/2017-10/#bof4) (Oct 18th) was accepted. You 
should definitely attend this event if you are an LLVM developer working on an 
out-of-tree RISC-V backends or are looking to get involved (representatives 
from several companies in that position are already confirmed as attending).
We're also looking to run a longer working/hacking session the day before, at 
a San Jose location. More details on both events will be circulated shortly.

## FAQ
### Do you care about performance of generated code and code size?

Like any compiler developer, of course. Starting with a solid and well tested 
base is the best way of achieving those aims. We're now in a position where we 
can push forwards on these fronts, which will will soon become a primary focus 
of this development effort.

### I have a RISC-V LLVM fork which works for me, why should I care about an upstream backend?

This is ultimately a question about long-term maintenance and sharing the 
support burden with others in the RISC-V ecosystem. By working together and 
pooling our development efforts, we can unlock the benefits of the open source 
approach. Contributing to this effort is almost definitely the right long-term 
choice for your project. If you want to discuss how to contribute, please drop 
me an email or come along to the upcoming birds of a feather session.

### What is the difference between this and other RISC-V LLVM efforts?

This effort is focused on high code quality, long term maintainability, and in 
getting development merged in to upstream LLVM. Andes have recently released a 
private development tree to the public. That tree was was based on an early 
version of the lowRISC patchset, but diverged significantly in terms of 
implementation approach. Andes are now working to submit patches to this 
effort.

### Who are you?

I (Alex Bradbury) am a co-founder and director of lowRISC CIC, where this 
development work has been taking place. I have been developing LLVM backends 
for the past seven years, and am now upstream code owner for the RISC-V 
backend. If you're interested in LLVM, you are hopefully already familiar with 
my [LLVM Weekly](http://llvmweekly.org/) newsletter.

### Why is lowRISC interested in LLVM?

lowRISC is a not-for-profit created to push forward open source hardware by 
developing a secure, open, and flexible SoC design. Enabling custom hardware 
and derivative designs is about much more than shipping RTL with an open 
source license - hardware is of little use without the software infrastructure
in place to support it. A high quality and easy to modify LLVM backend is
important for potential lowRISC adopters, but also benefits our own hardware
development efforts. Specifically, we will be building the software component
of our tagged memory mechanisms on top of LLVM. If our mission sounds
interesting to you, there's good news - [we're
hiring](https://www.lowrisc.org/blog/2017/09/were-hiring-work-on-making-open-source-hardware-a-reality/).

### Who do I contact to discuss further sponsoring this effort?

If your company would like to see lowRISC's work on RISC-V LLVM be sustained 
or expanded through 2018, then contributing development time and/or 
sponsorship is the best way to do this. Please contact asb@lowrisc.org to 
discuss further.
