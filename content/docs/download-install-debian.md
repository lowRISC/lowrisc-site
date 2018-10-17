+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Download and install Debian"

+++

## Build Linux and early stage root filesystem

These instructions assume you are running our recommended distribution Ubuntu 16.04.5 LTS

Debian installation requires the ability to emulate RISCV execution on the host PC.

Proceed as follows, first generate an initial root file system for booting, we use Debian to generate initial tmpfs for booting,
and at the same time, the subsystems for multi-user operation:

    cd $TOP/debian-riscv64

The bootstrapping process requires the qemu binary built in the previous step. This needs to be registered if not already done by the quickstart procedure.

    sudo update-binfmts --import work/qemu-riscv64

If the message: no executable /usr/bin/qemu-riscv64-static found, it should be ignored since the path will be different inside the chroot.

This step downloads the RISCV basic bootstrap and extracts those elements that are needed for booting (because any superfluous files waste memory and download time)

    make cpio
    
This stage could fail due to server timeouts or lack of signing keys. If so run the above step twice to make sure.
Support for non-Debian derived base operating systems is outside the scope of this tutorial. A secondary site-effect
of this command will be the creation of a compressed tar file ../rootfs.tar.xz, which may subsequently be used to
build an SD-Card, or root file system served via NFS.

The next recommended step is:

* [Build the Linux Kernel] ({{< ref "docs/linux-kernel-build.md">}})
