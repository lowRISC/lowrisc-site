+++
Description = ""
date = "2016-06-10T16:00:00+00:00"
title = "Compile the RISC-V Linux and the ramdisk `root.bin`"
parent = "/docs/untether-v0.2/dev-env/"
prev = "/docs/untether-v0.2/riscv_compile/"
showdisqus = true

+++

<a name="linux"></a>
### RISC-V Linux

The Linux kernel can be simulated using Spike or booted on an FPGA. To
compile your own Linux kernel, use the following script (more instructions
can be found [here](https://github.com/riscv/riscv-linux#linuxrisc-v):

    # set up the RISCV environment variables
    cd $TOP/riscv-tools
    curl https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.14.41.tar.xz \
      | tar -xJ
    cd linux-3.14.41
    git init
    git remote add origin https://github.com/lowrisc/riscv-linux.git
    git fetch
    git checkout -f -t origin/untether-v0.2
    make ARCH=riscv defconfig
    make ARCH=riscv -j vmlinux

After the compilation, you should be able to find the Linux kernel image:

    ls -l vmlinux


<a name="busybox"></a>
### Ramdisk `root.bin` (busybox)

[BusyBox](www.busybox.net) is used in the root image to provide the
basic shell environment. To build your own root image, the BusyBox
binary must be generated at first:

    # set up the RISCV environment variables
    cd $TOP/riscv-tools
    curl -L http://busybox.net/downloads/busybox-1.21.1.tar.bz2 | tar -xj
    cd busybox-1.21.1
    cp $TOP/riscv-tools/busybox_config .config
    make -j$(nproc)

If the compilation finishes successfully, the BusyBox binary is generated in the same directory.

    ls -l busybox

After the BusyBox binary is ready, the root image (root.bin) can be
built using the following script: 

    $TOP/riscv-tools/make_root.sh

More details can be found [here](https://github.com/riscv/riscv-tools).

### Test images in Spike

Now it should be possible to boot Linux in Spike. See [Booting RISC-V 
Linux](../spike#spike-boot).
