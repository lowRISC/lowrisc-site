+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "Updating the kernel of a running system"

+++

As an install step, the Linux kernel (with BBL) can always be written on the host card reader. However,
for regular use, it is inconvenient to keep swapping the card between devices.
If you already have a running Linux system, perhaps based on the pre-made
executables, it is possible to replace the kernel in the running system, which saves wear and tear from
regularly swapping cards between target system and PC. To use this method proceed as follows:

On the target system (first time only, optional):

    adduser upload

You will need to choose a password and ensure the network is running. If you don't want to create an upload user,
your own username created in the firstboot process will do equally well.

Generate a public key (optional, but more convenient if you don't already have one):

    ssh-keygen -t rsa
   
On the host (first time only, if you have a public key):

    ssh-copy-id upload@192.168.0.51 # substitute your boards' own IP address

On the host:

    cd $TOP/fpga/board/nexys4_ddr
    sftp upload@192.168.0.51 # substitute your boards' own IP address
    put boot.bin
    quit

On the target system, logged in as root, proceed as follows:

    cd /home/upload
    mv boot.bin /mnt/dos # ignore error about preserving ownership
    halt

You cannot upload directly to the DOS filing system because it does not support credentials so only
root and write to it normally, and root login via sftp is disabled for security reasons. After the final
shutdown message is printed, the reset button may be used to reboot.

Next recommended step:

* [Booting a customised NFS system] ({{< ref "docs/boot-customised-nfs.md">}})
