+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Download and install Debian"

+++

## Build Linux and early stage root filesystem

These instructions assume you are running our recommended distribution Ubuntu 18.04 LTS

Debian installation requires the ability to emulate RISCV execution on the host PC.

The bootstrapping process requires the qemu binary built in the previous step. This needs to be registered if not already done by the quickstart procedure. It also requires super-user privileges on the host workstation. If these privileges are not available then an idea of operation may be seen using the pre-build debian image from the github download area. During this process the keyboard layout and default language will be chosen as well as the timezone and preferred locale.

    sudo update-binfmts --import debian-riscv64/work/qemu-riscv64

If the message: no executable /usr/bin/qemu-riscv64-static found, it should be ignored since the path will be different inside the chroot.

Proceed as follows, first generate an initial root file system for booting, we use Debian to generate initial tmpfs for booting,
and at the same time, the subsystems for multi-user operation:

    make -C debian-riscv64 image

This stage could fail due to server timeouts or lack of signing keys. If so run the above step twice to make sure.
Support for non-Debian derived base operating systems is outside the scope of this tutorial. A secondary site-effect
of this command will be the creation of a compressed tar file lowrisc-quickstart/rootfs.tar.xz, which may subsequently be used to
build an SD-Card, or root file system served via AOE/NBD/NFS.

The next recommended step is:

* [Build the Linux Kernel] ({{< ref "docs/linux-kernel-build.md">}})
