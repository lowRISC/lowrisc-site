No pre-build installation images are available for our setup. So we accelerate the bootstrapping process using qemu.
This first step creates a RISCV emulation environment to short-circuit the complexities of preparing a rootfs

    cd $TOP/qemu
    ./configure --static --disable-system --target-list=riscv64-linux-user
    make

