+++
Description = ""
date = "2015-04-12T16:24:16+01:00"
title = "Building the front-end server"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/fpga-ramdisk/"
next = "/docs/tagged-memory-v0.1/"
aliases = "/docs/tutorial/fpga-fesvr/"
showdisqus = true

+++

The front-end server runs on the ARM side (PS) of the Zynq. It must 
be cross-compiled against the Xilinx SDK. 

To compile your own front-end server:

    # set up the RISCV environment variables
    # set up the Xilinx environment variables
    cd $TOP/riscv-tools/riscv-fesvr
    mkdir build_fpga
    cd build_fpga
    ../configure --host=arm-xilinx-linux-gnueabi
    make -j$(nproc)

Once compilation has completed, you should find the following files:

    ls -l fesvr-zedboard
    ls -l libfesvr.so

To copy your new front-end server to the FPGA image:

    cd $TOP/fpga-zynq/zedboard
    make ramdisk-open
    sudo cp $TOP/riscv-tools/riscv-fesvr/build_fpga/fesvr-zedboard \
      ramdisk/home/root/fesvr-zynq
    sudo cp $TOP/riscv-tools/riscv-fesvr/build_fpga/libfesvr.so \
      ramdisk/usr/local/lib/libfesvr.so
    make ramdisk-close
    sudo rm -fr ramdisk

The proxy kernel (pk) used by the FPGA is the same one used in
simulation.  While not normally necessary, the proxy kernel can be recompiled using the following commands: 

    cd $TOP/fpga-zynq/zedboard
    make ramdisk-open
    sudo cp $TOP/riscv-tools/riscv-pk/build/pk ramdisk/home/root/pk
    make ramdisk-close
    sudo \rm -fr ramdisk


