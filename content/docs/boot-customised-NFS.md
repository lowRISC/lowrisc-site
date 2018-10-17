+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Booting a customised NFS system"

+++

It is possible to boot LowRISC in the absence of an SD-Card. This is useful if a large
number of files are shared with a Host PC. However there are many variables to be considered
which would be inconvenient to hardwire into the binary builds.

We will use the boot selection switches to choose a customised boot option. Prepare a file
as follows:

        mount -t proc none /proc
        udhcpc -s /usr/share/udhcpc/default.script
        rdate -s 132.163.97.4 # This should be replaced by a local server
        echo Mounting NFS root
        mount.nfs -o nolock 128.232.65.94:/local/scratch/debian-riscv64 /nfs # This should be updated appropriately
        echo Mounting proc
        mkdir -p /nfs/proc
        mount -t proc none /nfs/proc
        echo Mounting sysfs
        mkdir -p /nfs/sys
        mount -t sysfs none /nfs/sys
        echo Mounting devtmpfs
        mkdir -p /nfs/dev
        mount -t devtmpfs udev /nfs/dev
        mkdir -p /nfs/dev/pts
        echo Mounting devpts
        mount -t devpts devpts /nfs/dev/pts
        echo Mounting tmpfs
        mkdir -p /nfs/tmp
        mount -t tmpfs tmpfs /nfs/tmp
        mkdir -p /run
        mount -t tmpfs tmpfs /run
        umount /proc
        echo Executing switch_root for nfs
        exec switch_root /nfs /sbin/init

This file should be saved as 5022.sh on the DOS partition of the SD-Card.
The FPGA board switches should be set to match this value (in hex). Referring to the table in  [Build the Linux Kernel] ({{< ref "docs/linux-kernel-build.md">}}), it is clear that this means SD-boot, Custom-root, MAC ending in 5.

If it is desired to boot the NFS Client kernel over the Ethernet (a common use case), the file should be called 5024.sh, corresponding to DHCP boot, Custom-root, MAC ending in 5.

Once the settings are working, it may
be hardwired into an eventual rebuild of the kernel inside debian-riscv64/work/busyboxinit.sh (option 1).
This option would then not require the SD-Card and it could be reinitialised with a different O/S or any other action requiring full unrestricted access to the card.

On your PC-workstation/server, create a suitable NFSroot mount point (replace the IP address of your FPGA board as necessary):

    sudo mkdir -p /local/scratch/debian-riscv64
    sudo vi /etc/xinetd.d/time
    #Change the first occurence of "disable=yes" to "disable=no". This enables the time service.
    sudo /etc/init.d/xinetd restart
    sudo /etc/init.d/nfs-kernel-server stop
    sudo vi /etc/exports
    #Add the following to the end of the file.
    /local/scratch/debian-riscv64 192.168.0.51(rw,sync,no_subtree_check,no_root_squash)
    cd  /local/scratch/debian-riscv64
    sudo tar xJf $TOP/rootfs.tar.xz
    #Restart the NFS server
    sudo /etc/init.d/nfs-kernel-server start

The dangerous option no_root_squash which allows the NFS client to run as root on the server, may be mitigated by the confinement of the mount to a loopback mount which we can easily set up (not shown, refer to the ethernet-v0.5 release for a suitable example). If access to host files is desired this may be done by copying on the host, or with a second mount point without no_root_squash inside the server's filing system

## Turbo super-user

It is certainly inconvenient requiring slow card operations during normal use. The use of a turbo super-user on the workstation

    sudo chroot /local/scratch/debian-riscv64

will rapidly allow the NFSroot to be customised for any possible application. For example if ocaml is to be installed, it can be done in a chroot on the PC, and it will immediately be available on the LowRISC without having to reboot or swap any cards.

This is in essence the best of both worlds, the security of knowing that the software runs on the FPGA, at the same time the convenience and speed of installing on the PC.
