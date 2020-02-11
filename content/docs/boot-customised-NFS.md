+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Booting a customised NFS system"

+++

It is possible to boot LowRISC in the absence of an SD-Card using the rescue image. However the new
block driver does not yet support hot-swapping of cards. To support X-windows systemd is used as
the startup manager. This places a heavy load on the filing system with many parallel threads. As
a result NFS accesses, which operate at the file level, will be slower and less reliable.

Two other protocols AOE (ATA over Ethernet), and NBD (network block device) are available which
operate at the block level. These options would be enabled by customising busyboxinit.sh in the
debian-riscv64/work directory, or using the Turbo option as shown below.

## NFS client configuration

mount.nfs -o nolock 10.0.0.1:/local/scratch-legacy/debian-ariane /mnt
echo Executing switch_root for NFS
exec switch_root /mnt /sbin/init

## AOE client configuration

aoe-discover
fsck.ext4 /dev/etherd/e0.1 || (echo fsck.ext4 /dev/etherd/e0.1 failed, dropping to ash; /bin/ash)
mount -t ext4 /dev/etherd/e0.1 /mnt || (echo mount -t ext4 /dev/etherd/e0.1 /mnt failed, dropping to ash; /bin/ash)
echo Executing switch_root for aoe
exec switch_root /mnt /sbin/init

## NBD client configuration

nbd-client 10.0.0.1
mount -t ext4 /dev/nbd0 /mnt || (echo mount -t ext4 /dev/rda2 /mnt failed, dropping to ash; /bin/ash)
echo Executing switch_root for nbd
exec switch_root /mnt /sbin/init

All of these options should be regarded as experimental attempted by advanced users. Because of the many variations
the server configuration is outside the scope of this tutorial.

## Turbo super-user

It is certainly inconvenient requiring slow card operations during normal use. The use of a turbo super-user on the workstation
is recommended for slow operations such as installing new packages. This technique applies if you use the optional Debian install.
On buildroot new package installation is possible in principle with rpm. However there is no pre-made repository of compatible packages.

The SD-Card will be put into the workstation via a USB-adaptor, the lsblk command reveals the mount points (for example):

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part /media/jrrk2/4B81-D0E9
    ├─sdc2   8:34   1     2G  0 part /media/jrrk2/f7f09dd8-07cb-4208-99fe-1b2989f3c0bb
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part /media/jrrk2/5cfa6765-3761-456c-8af5-d4648c05d2d4

    sudo chroot /media/jrrk2/f7f09dd8-07cb-4208-99fe-1b2989f3c0bb

This works by the aid of the miscfs support that was installed earlier in the tutorial, it will rapidly allow the root to be customised for any possible application. For example if ocaml is to be installed, it can be done in a chroot on the PC, and it will immediately be available on the LowRISC after the next reboot.

This is in essence the best of both worlds, the security of knowing that the software runs on the FPGA, at the same time the convenience and speed of installing on the PC.

root@hostpc:/# mount -t devtmpfs - /dev
root@hostpc:/# mount -t proc - /proc
root@hostpc:/# apt update
root@hostpc:/# apt install ocaml
root@hostpc:/# umount /proc
root@hostpc:/# umount /dev

Be sure to unmount the pseudo file systems to allow clean SD-Card unmounting.

