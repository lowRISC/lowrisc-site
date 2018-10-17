+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "RISCV emulation"

+++

No pre-build installation images are available for our setup. So we accelerate the bootstrapping process using qemu.
This first step creates a RISCV emulation environment to short-circuit the complexities of preparing a rootfs

    cd $TOP/qemu
    ./configure --static --disable-system --target-list=riscv64-linux-user
    make

Next recommended step below:

* [Downloading and Installing Debian] ({{< ref "docs/download-install-debian.md">}})
