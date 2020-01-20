+++
Description = ""
date = "2019-06-24T00:00:00+01:00"
title = "Review of RISCV capable distributions"

+++

## Debian

Debian was an early adopter of the RISCV architecture, unfortunately the ABI was rather unstable at this time. Along with Fedora they took the decision to only support the GC variant (general-purpose, compressed instruction set). Insufficient progress has been made to migrate from an unstable to a stable release since then, largely due to lack of incomplete LLVM and JAVA support, needed by some packages.

A large number of packages have been ported to RISCV Debian, but occasional breakage of the distribution system is to be expected, which is annoying as there is no stable version to fall on. It incorporates rarely seen packages such as xfishtank, used as an illustration in this documentation. It may be used in a similar way to the previous release, but cannot be 100% relied on to be a repeatable installation experience. In theory after installation upgrades are possible using APT, however the Nexys4DDR board is limited in memory and this makes upgrading painfully slow.

## Fedora

The Fedora Rawhide picture is a little more rosy, because versioned snapshots of installed disk images are available. However there is a rather limited choice available with this method (similar to the live distribution method for PC desktops). The use of DNF as a default package manager, with its reliance on Python and friends, has too high an overhead for this hardware. If the live distribution is chosen there is good compatibility possible, however Fedora dropped support for certain legacy mouse and keyboard drivers at the FC20 stage or so, therefore you cannot use the core pointer and core keyboard approach which LowRISC relies on in this release. Hotplugging in X-windows is not supported by LowRISC device drivers. The distribution is naturally systemd based and, from an embedded point of view, starts many unnecessary and memory hungry services.

## SUSE

The SUSE tumbleweed distribution also supports RISCV. It was not investigated in any detail but would appear to have the same drawbacks as the Fedora distribution.

## Buildroot 2019.11

The latest stable buildroot supports RISCV, but it also drops support for riscv-pk, which is premature in my view. However it is straightforward to adopt an out-of-distribution kernel, and generates a lean and mean installation binary of around 70 megabytes (compressed), including a usable X-windows system, but excluding development tools. By default it does not rely on perl, python or java, which is a good thing from an FPGA point of view.

## Gentoo

Stage-3 binaries are available for RISCV (this consists of all development tools needed for bootstrapping on the RISCV machine) but X-windows has not been customised with RISCV keyword compatibility. Much of the infrastructure is Python based.

## Yocto/Poky

Another system targetting embedded systems. This option is similar in concept to buildroot, but offers compilers and development tools as well. It is not particularly build host agnostic, which could be a disadvantage in corporate environments where OS and settings are determined centrally.
