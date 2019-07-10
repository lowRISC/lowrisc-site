+++
Description = ""
date = "2019-07-10T16:10:00+01:00"
title = "Large-scale RISC-V LLVM testing with Buildroot"

+++

A few years ago lowRISC started developing a new LLVM backend targeting RISC-V.
Rather than copying and modifying an existing backend, in an ad hoc fashion, we
started from scratch and proceeded systematically. This approach proved
successful in producing a high-quality codebase. We [recently announced]({{<
ref "risc-v-llvm-backend-in-9.0.md" >}}) on the llvm-dev mailing
list that the backend is now reaching stability and could be promoted from its
current status of experimental to an official target. This post explains how
our testing strategy has evolved as the compiler matured.

**TL;DR**: we now successfully compile more than 90% of the 2000+ Linux packages
built by the [buildroot](https://buildroot.org/) tool. The remaining packages
mostly fail due to relying on GCC-specific C constructs and configurations,
and not due to anything fundamental related to the new backend.

During the initial development of the backend our testing approach consisted
mostly of unit tests. As each feature was implemented corresponding unit tests
were added. This was done both to document the expected behaviour of the
compiler and to ensure that future LLVM changes would not introduce regressions
in those areas.

More recently, we started compiling entire programs using Clang targeting
RISC-V, to exercise the backend using real-world code. We started with a few
small programs and have now moved towards compiling a full Linux userspace.

One of the programs we chose for our initial tests was BusyBox. BusyBox
replaces many standard UNIX programs with a single binary that mimics those
individual programs. With almost 400 "applets", BusyBox provided a reasonable
amount of complexity to test. To compile it with LLVM we produced a
configuration file that enables all of the BusyBox features and that specifies
Clang as the compiler, with the correct flags to target RISC-V and find the
appropriate sysroot headers and libraries.

BusyBox compiled successfully at the first try. To be reasonably confident it
had been correctly compiled, we wrote a script to exercise all of the applets.
Our testing revealed that a significant portion of the commands would crash
upon launch. Investigating those crashes revealed that they all had a common
cause, which was that BusyBox relied on C undefined behaviour and LLVM HEAD
would optimize away code that was intended to run. So, in fact, this issue
wasn’t specific to the new RISC-V target. We [submitted a patch upstream](http://lists.busybox.net/pipermail/busybox/2019-June/087337.html) fixing
the issue, with which BusyBox now runs without problems.

Our initial testing of a handful of programs and libraries used QEMU Linux user
mode emulation for a quick and convenient testing. Next, we moved to building a
complete rootfs that we could boot with qemu-system as a sanity check, before
starting to compile large amounts of packages. For that we chose the buildroot
tool.

Buildroot can be used either with an existing toolchain or by letting it build
its own. To facilitate the testing process, we let buildroot build its own
GCC-8 RISC-V cross-compiler, and we then patch the resulting toolchain to use
Clang / LLVM when desired, by using a wrapper script. For our sanity check we
included a handful of programs, such as some simple command line utilities and
the nginx web server. The wrapper script will redirect the compilation to
Clang, adding a few additional command line options in the process to correctly
configure the toolchain. The wrapper can also remove a few GCC-specific
compilation flags that Clang doesn’t know about, cutting down on the
compilation noise, although that isn’t strictly necessary for basic testing.
With this approach we produced a full Linux system we could boot with QEMU.
From within QEMU we saw that we could login into the system and use it
normally, including making HTTP requests served by nginx.

In the terminal session below you can see me booting a clang-built rootfs
(everything other than the kernel, opensbi, and glibc is built by Clang) in
qemu, and browsing the web using links:

<script id="asciicast-9Cde6gZq8KljgZD50BhLFSms6" src="https://asciinema.org/a/9Cde6gZq8KljgZD50BhLFSms6.js" async></script>

Once we had a bootable system we wanted to determine how many packages we could
build. We also wanted this process to be easily reproducible, to be able to
check for compiler regressions, changes in code quality and so on. This would
require making the testing tools smarter since normally any buildroot
compilation failure will halt the build process. We extended the testing tools
to produce a tree of package dependencies, to be able to build individual
packages, and to build the individual packages in the correct order to satisfy
their dependencies. The tools are also able to apply per-package workarounds,
to avoid problems caused by some packages that depend on very GCC-specific
behaviour. This includes packages that refuse to compile unless the compilation
is warning-free and are then tripped by Clang’s additional diagnostic messages.

Of the 2000+ packages that buildroot provides we are now able to compile more
than 90% of them. We are still triaging a few of the remaining failing packages
to see if there are any actionable compiler issues, or if those failures also
relate to trivial configuration issues.

As next steps, we expect to do some more in-depth testing of the compiled
packages and to start building the Linux kernel with Clang. We will also
further investigate code size and generated code performance.

_Luís Marques_
