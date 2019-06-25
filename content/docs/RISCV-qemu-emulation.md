+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "RISCV emulation"

+++

No pre-build installation images are available for our setup. So we accelerate the bootstrapping process using qemu.
This first step builds qemu binary that provides user-space emulation (i.e.
will execute RISC-V binaries, and intercept Linux syscalls to be handled by 
the host OS). This is in contrast to QEMU's full system emulation mode, which 
provides emulation devices and requires you to boot a native operating system.

    cd $TOP/qemu
    ./configure --static --disable-system --target-list=riscv64-linux-user
    make

Next recommended step below:

* [Downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})
