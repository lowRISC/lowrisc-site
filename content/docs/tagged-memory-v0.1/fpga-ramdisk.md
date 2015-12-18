+++
Description = ""
date = "2015-04-12T16:22:20+01:00"
title = "Modifying the contents of the RAMdisk"
parent = "/docs/tagged-memory-v0.1/"
prev = "/docs/tagged-memory-v0.1/fpga-bootimage/"
next = "/docs/tagged-memory-v0.1/fpga-fesvr/"
aliases = "/docs/tutorial/fpga-ramdisk/"
showdisqus = true

+++

The contents of the RAMDisk for the ARM Linux (`uramdisk.image.gz`) can be extracted to a local directory for you to modify: 

    make ramdisk-open

The RAMDisk is extracted to `ramdisk/` in `fpga-zynq/zedboard`. Note
that the default user in the ARM Linux is root, so use `sudo` when
revising the files.

You can repack the RAMDisk using: 

    make ramdisk-close

The extracted RAMDisk remains at `ramdisk/`. It can be removed with: 

    sudo rm -fr ramdisk 

See also the notes [here](https://github.com/ucb-bar/fpga-zynq#changing-the-ramdisk)

