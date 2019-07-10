+++
Description = ""
date = "2019-07-10T16:00:00+01:00"
title = "The RISC-V LLVM backend in Clang/LLVM 9.0"
slug = "risc-v-llvm-backend-in-clang-llvm-9.0"

+++

On Monday I
[proposed](http://lists.llvm.org/pipermail/llvm-dev/2019-July/133724.html)
promoting the upstream RISC-V LLVM backend from "experimental" to "official"
for the LLVM 9.0 release. Responses so far are [extremely
positive](http://lists.llvm.org/pipermail/llvm-dev/2019-July/133740.html), and
we're working to ensure this is a smooth process. This means that from 9.0, the
RISC-V backend will be built by default for LLVM, making it usable out of the
box for standard LLVM/Clang builds. As well as being more convenient for end
users, this also makes it significantly easier for e.g. Rust/Julia/Swift and
other languages using LLVM for code generation to do so using the
system-provided LLVM libraries. This will make life easier for those working on
RISC-V ports of Linux distros encountering issues with Rust dependencies. As
[Sam mentioned yesterday]({{< ref "introducing-sam.md" >}}), we aim to work with the upstream
Rust community to help unblock this. 9.0 will branch on the 18th of July with
the release scheduled for the 28th of August.

The LLVM project is a popular open source suite of compiler toolchain related
tools. The core LLVM library and Clang C/C++ front-end are the most
recognisable components. See the [project home page](https://llvm.org/) for
more background.

I started the upstream RISC-V LLVM effort towards the end of 2016, having
developed and maintained an out-of-tree backend for a research architecture for
a number of years. At the time, there was some downstream work heavily based on
the MIPS backend but it had a range of problems. In order to maximise the value
from upstream code reviews (and also provide a useful reference for LLVM
newcomers), great care was taken to ensure backend functionality could be built
up incrementally. I'm delighted that this has frequently been picked out by the
LLVM community as the golden standard to follow when contributing new targets.

## Status

The RISC-V backend supports the 32- and 64-bit RISC-V base ISAs and all
standard extensions. i.e. RV32IMAFDC, RV64IMAFDC and the ilp32, ilp32f, ilp32d,
lp64, lp64f, lp64d ABIs (the [Clang hard-float ABI
patch](https://reviews.llvm.org/D60456) will land imminently). Working with
other backend contributors, we have developed a comprehensive set of in-tree
unit tests. For quite some time various groups have reported success using
Clang/LLVM for their RISC-V embedded firmware builds and more recently we have
been pushing forwards on issues related to building Linux/BSD applications. The
GCC torture suite has a 100% pass rate, we're seeing a 98% pass rate on the
LLVM test-suite (failures are almost all related to C++ exception handling,
which we hope to resolve soon), and we've been able to get over 90% of
buildroot's over 2000 packages to build for RISC-V using clang (most failures
are due to build system issues or GCCisms). We can compile and run meaningful
programs e.g.  build a rootfs with nginx, serve HTTP requests). See the [blog
post from Luis]({{< ref "risc-v-llvm-buildroot-testing.md" >}}) for many more
details on this testing.

LLD support is now roughly feature-complete with the exception of support for
linker relaxation. Fangrui Song has been most active on RISC-V LLD recently,
and prior to that Andes Tech contributed the majority of this code. In terms of
other language support, there is initial Rust support for bare metal RV32 and
RV64 with support for hard float Linux targets due to start soon.

Support for RISC-V in LLVM is important for the wider RISC-V ecosystem and at
lowRISC, we're proud of the role we've played in initiating its development,
driving it forwards, and building a community around it. As an independent
non-profit engineering organisation, we're uniquely positioned to perform this
kind of work - [it's what we do]({{< ref "our-work.md" >}}). Our toolchain team has
grown to include Luís Marques and Sam Elliott as well as myself and we are
always interested in hearing from skilled engineers who’d like to [join our
team]({{< ref "jobs.md" >}}). If you're interested in further supporting this work
or in applying a similar approach to other open source hardware/software
projects then get in touch at info@lowrisc.org.

## Thanks

As well as the lowRISC toolchain team I would like to thank everyone who gave
encouragement, helped with funding in order to support this work, or submitted
reviews or patches. We're delighted at the growing community of contributors
around this backend and feel it's a real success story for collaboration within
the RISC-V ecosystem. There are far too many names to mention everyone, but
engineers from organisations such as (alphabetically) AndesTech, Embecosm,
Google, Qualcomm, and the University of Cambridge have all made notable
contributions.

## Next steps

Becoming an "official" backend is a huge milestone, but of course that doesn't
mean we're done. As well as ongoing maintenance and support, we'll be
continuing to work on: code size, generated code performance improvements,
better testing, collaborating with language communities such as
Rust/Swift/Julia, adding support for additional LLVM features or RISC-V
instruction set extensions, and more.

_Alex Bradbury, CTO and Co-Founder_
