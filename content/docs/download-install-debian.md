+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Download and install Debian"

+++

## Build Linux and early stage root filesystem

The previous release assumed that Debian release sid would be used as the root file system.

With the introduction of the LLVM build system and the rust compiler, this has introduced a lot
of instability in package versions and dependencies, resulting in a bit of a lottery when it comes
to downloading a complete and consistent file system. With the passage of time, this will make a
much more complete and stable system. For now it will remain in the unstable branch.

For this reason the Debian root filing system has been made an optional feature, instead buildroot-2019.11-1
has been chosen to make a controlled and repeatable installation from source. This can take several hours
to build, and is much more limited in package choice than Debian, and in particular it does not include any compilers.
On the plus side, it is a convenient framework to manage the building of the kernel(s) and auxiliary packages such
as openocd and riscv-pk. If this functionality is adequate, there is no need to proceed with the Debian installation.
If you proceed with the Debian installation and it doesn't work, it may be necessary to back off and try a week later or so.

If you feel tempted to try alternative distributions such as Fedora rawhide, bear in mind that they are script heavy,
in particular extensive use of Python is assumed under the hood. RISCV does not have an optimised interpreter for Python,
so performance and stability will be disappointing, as will memory usage as swap space is hoovered up.

The following instructions assume that you are running our recommended distribution Ubuntu 18.04 LTS

Debian installation requires the ability to emulate RISCV execution on the host PC.

The bootstrapping process requires the qemu binary built in the previous step. This needs to be registered if not already done by the quickstart procedure. It also requires super-user privileges on the host workstation. If these privileges are not available then an idea of operation may be seen using the pre-build debian image from the github download area. During this process the keyboard layout and default language will be chosen as well as the timezone and preferred locale.

    sudo update-binfmts --import debian-riscv64/work/qemu-riscv64

If the message: no executable /usr/bin/qemu-riscv64-static found, it should be ignored since the path will be different inside the chroot.

You will need to clone the optional Debian build environment.

git clone -b ariane-v0.7 https://github.com/jrrk2/debian-riscv64.git 

Proceed as follows, first generate an initial root file system for booting, we use Debian to generate initial tmpfs for booting,
and at the same time, the subsystems for multi-user operation:

    make -C debian-riscv64 image

This stage could fail due to server timeouts or lack of signing keys. If so run the above step twice to make sure.
Support for non-Debian derived base operating systems is outside the scope of this tutorial. A secondary site-effect
of this command will be the creation of a compressed tar file lowrisc-quickstart/rootfs.tar.xz, which may subsequently be used to
build an SD-Card, or root file system served via AOE/NBD/NFS.
