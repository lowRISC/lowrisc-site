## Build Linux and early stage root filesystem

These instructions assume you are running our recommended distribution Ubuntu 16.04.5 LTS

Proceed as follows, first generate an initial root file system for booting, we use debian to generate initial tmpfs for booting,
and at the same time, the subsystems for multi-user operation:

    cd $TOP/debian-riscv64
    make cpio
    
This stage could fail due to server timeouts or lack of signing keys. If so run the above step twice to make sure.
Support non-debian derived base operating systems is outside the scope of this tutorial.

Then continue to customise debian in the same directory as follows:

    sudo cp $TOP/qemu/riscv64-linux-user/qemu-riscv64 work/debian-riscv64-chroot/usr/bin/qemu-riscv64-static
    sudo update-binfmts --import work/qemu-riscv64
    sudo mount -t proc none work/debian-riscv64-chroot/proc
    sudo mount -o bind /dev work/debian-riscv64-chroot/dev
    sudo mount -o bind /dev/pts work/debian-riscv64-chroot/dev/pts
    sudo chroot work/debian-riscv64-chroot

Which should eventually drop into a qemu riscv user shell. We use this facility to prepare the root filing system for debian-riscv

    apt install -f
    apt install locales
    dpkg-reconfigure locales

Various questions will be asked, say no to using dash as the default system shell. You set your locale to a suitable value for your region.

    passwd root
    "Enter new UNIX password:"
    "Retype new UNIX password:" 
    "passwd: password updated successfully"

This naturally will be the root password for the RISCV system.

    exit
    
Now the rootfs is ready to copy to the NFS mount point / SD-Card

    sudo umount work/debian-riscv64-chroot/proc work/debian-riscv64-chroot/dev/pts work/debian-riscv64-chroot/dev
    sudo mkdir -p /mnt/nfs
    sudo rsync -a work/debian-riscv64-chroot/. /mnt/nfs
    cd work/debian-riscv64-chroot
    sudo tar cJf $TOP/fpga/board/nexys4_ddr/debian-root.tar.xz .
