
### Boot Linux from local SD-Card

The kernel previously produced should be copied to the DOS partition of the SD-Card. It should be booted
with SW1 on and SW0/2 off. If you already have a running Linux system, perhaps based on the pre-made
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
    put boot_mmc.bin
    quit

On the target system, logged in as root, proceed as follows:

    cd /home/upload
    mount -t msdos /dev/mmcblk0p1 /mnt
    mv boot_mmc.bin /mnt/boot.bin # ignore error about preserving ownership
    umount /mnt
    halt

You cannot upload directly to the DOS filing system because it does not support credentials so only
root and write to it normally, and root login via sftp is disabled for security reasons. After the final
shutdown message is printed, the reset button may be used to reboot.
