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

On the target system (first time only):

    adduser upload

You will need to choose a password and ensure the network is running

On the host (first time only, if you have a public key):

    ssh-copy-id upload@lowrisc5.sm.cl.cam.ac.uk # substitute your boards' own IP address

On the host:

    cd $TOP/fpga/board/nexys4_ddr
    sftp upload@lowrisc5.sm.cl.cam.ac.uk # substitute your boards' own IP address
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

* [Booting a customised NFS system] ({{< ref "docs/BootNFS.md">}})
