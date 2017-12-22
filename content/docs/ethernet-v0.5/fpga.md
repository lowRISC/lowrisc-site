+++
Description = ""
date = "2017-04-14T13:00:00+00:00"
title = "Running the pre-built images on the FPGA"
parent = "/docs/ethernet-v0.5/"
prev = "/docs/ethernet-v0.5/walkthrough/"
showdisqus = true

+++

In this step, we want to test the Ethernet functionality on an FPGA board.
The system will use the Ethernet 100Base-T connection at 100 MBaud to communicate with 
the LowRISC Linux system.

## Run the pre-built FPGA demo

The files you may need:

 * [chip_top.bit](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/nexys4ddr.bit):
   The tagpipe/minion/debug enabled FPGA bitstream
 * [boot0000.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/boot0000.bin):
   Linux, Busybox and Berkley bootloader (BBL) packaged in one image (for local filing system).
 * [boot0001.bin](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/boot0001.bin):
   Linux, Busybox and Berkley bootloader (BBL) packaged in one image (for NFS root filing system).
 * [rootfs.ext2](https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/rootfs.bzip2)
   riscv-poky root filing system ready-built for LowRISC

Download and write the bitstream

    cd $TOP/fpga/board/nexys4_ddr
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/nexys4ddr.bit > nexys4ddr.bit
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/boot0000.bin > boot0000.bin
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/boot0001.bin > boot0001.bin
    curl -L https://github.com/lowRISC/lowrisc-chip/releases/download/v0.5-rc1/rootfs.bzip2 | bzip2 -d > rootfs.ext2
    
Convert the bitstream to quad-spi memory format

    vivado -mode batch -source $TOP/fpga/common/script/cfgmem.tcl -tclargs "xc7a100t_0" nexys4ddr.bit

Burn the quad-spi memory (Ensure the MODE switch is set to QSPI)

    vivado -mode batch -source $TOP/fpga/common/script/program_cfgmem.tcl -tclargs "xc7a100t_0" nexys4ddr.bit.mcs

## Access the boot-loader and connect to the UART console.

First check the available serial ports:

    ls -l /dev/*USB*

which should result in a response similar to:

    crw-rw---- 1 root dialout 188, 1 Apr 14 16:32 /dev/ttyUSB1

In this case the device is user and group only access, so you need to be a member of the group dialout to use it.

    microcom -p /dev/ttyUSB1

This needs a separate terminal window as it takes over the screen. Alternatively a separate VGA display and USB keyboard may be used. You should see a display similar to the below a short delay after the PROG button is pushed.

    Selftest iteration 1
    Selftest matches=4/4, delay = 5
    Selftest iteration 2
    Selftest matches=8/8, delay = 5
    Selftest iteration 3
    Selftest matches=16/16, delay = 7
    Selftest iteration 4
    Selftest matches=32/32, delay = 13
    Selftest iteration 5
    Selftest matches=64/64, delay = 26
    Selftest iteration 6
    Selftest matches=128/128, delay = 52
    Selftest iteration 7
    Selftest matches=256/256, delay = 103
    Selftest iteration 8
    Selftest matches=375/375, delay = 151
    Hello LowRISC! Thu Dec 21 18:02:20 2017
    MAC = eee1:e2e3e4e5
    MAC address = ee:e1:e2:e3:e4:e5.
    IP Address:  192.168.0.51
    Subnet Mask: 255.255.255.0
    Enabling interrupts

## Ethernet server preparation

We need to make some changes on the server to enable this option. First of all create a suitable NFSroot mount point:

    sudo mkdir /mnt/poky-dev
    sudo mount -t ext2 -o loop rootfs.ext2 /mnt/poky-dev
    sudo vi /etc/xinetd.d/time
    #Change the first occurence of "disable=yes" to "disable=no". This enables the time service.
    sudo /etc/init.d/xinetd restart
    sudo /etc/init.d/nfs-kernel-server stop
    sudo vi /etc/exports
    #Add the following to the end of the file. "/mnt/poky-dev 192.168.0.51(rw,sync,no_root_squash)"
    #Restart the NFS server
    sudo /etc/init.d/nfs-kernel-server start

## Ethernet booting

    cd $TOP/fpga/board/nexys4_ddr
    make etherboot

You should see a display similar to the following:

Clear blocks requested
......??..6?6.6?6...6?.....?????....?6..............6.................Report blocks requested
Report blocks requested
Report md5 requested
md5(0x86e00000,5272576) = 5f460062003d4b7293709df08dd09d71
Report md5 requested
Report md5 requested
Report md5 requested
Report md5 requested
?Report md5 requested
Report md5 requested
Report md5 requested
6?Report md5 requested
Report md5 requested
Report md5 requested
Report md5 requested
Report md5 requested
Boot requested
Disabling interrupts
Ethernet interrupt status = 0
Load 5272576 bytes to memory address 86e00000 from boot.bin of 5272576 bytes.
load elf to DDR memory
Section[0]: memcpy(0x80000000,0x0x86e01000,0x6c70);
memset(0x80006c70,0,0x58);
Section[1]: memcpy(0x80007000,0x0x86e08000,0x4fcc20);
Boot the loaded program...
Goodbye, booter ...
              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    
rr                vvvvvvvvvvvvvvvvvvvvvv      
rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr
rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr
rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr
rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr
rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr
rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr
rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr
rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr

       INSTRUCTION SETS WANT TO BE FREE
[    0.000000] Linux version 4.6.2-gf7aa0f9 (jrrk2@jrrk2-iMac) (gcc version 6.1.0 (GCC) ) #1 Thu Dec 21 19:36:57 GMT 2017
[    0.000000] Available physical memory: 114MB
[    0.000000] Initial ramdisk at: 0xffffffff80016958 (781719 bytes)
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000080600000-0x00000000877fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080600000-0x00000000877fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080600000-0x00000000877fffff]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 28785
[    0.000000] Kernel command line: 
[    0.000000] PID hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 110464K/116736K available (2601K kernel code, 144K rwdata, 548K rodata, 856K init, 239K bss, 6272K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:0 nr_irqs:0 0
[    0.000000] clocksource: riscv_clocksource: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100 ns
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 0.50 BogoMIPS (lpj=2500)
[    0.000000] pid_max: default: 32768 minimum: 301
[    0.000000] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.000000] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.090000] devtmpfs: initialized
[    0.120000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.150000] NET: Registered protocol family 16
[    0.360000] clocksource: Switched to clocksource riscv_clocksource
[    0.430000] NET: Registered protocol family 2
[    0.460000] TCP established hash table entries: 1024 (order: 1, 8192 bytes)
[    0.470000] TCP bind hash table entries: 1024 (order: 1, 8192 bytes)
[    0.470000] TCP: Hash tables configured (established 1024 bind 1024)
[    0.480000] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.480000] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.490000] NET: Registered protocol family 1
[    0.510000] RPC: Registered named UNIX socket transport module.
[    0.510000] RPC: Registered udp transport module.
[    0.510000] RPC: Registered tcp transport module.
[    0.510000] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.770000] Unpacking initramfs...
[    5.040000] hid_keyboard address 40020000, remapped to ffffffff78002000
[    5.040000] hid_display address 40028000, remapped to ffffffff78010000
[    5.390000] console [xuart_console0] enabled
[    5.400000] keyb_timer is started
[    5.440000] futex hash table entries: 256 (order: 0, 6144 bytes)
[    5.460000] workingset: timestamp_bits=61 max_order=15 bucket_order=0
[    6.000000] io scheduler noop registered (default)
[    9.100000] lowrisc-digilent-ethernet: Lowrisc ethernet platform (40012000-40013FFF) mapped to ffffffff78008000
[    9.130000] libphy: GPIO Bitbanged LowRISC: probed
[    9.140000] Probing lowrisc-0:01
[    9.150000] SMSC LAN8710/LAN8720 lowrisc-0:01: attached PHY driver [SMSC LAN8710/LAN8720] (mii_bus:phy_addr=lowrisc-0:01, irq=-1)
[    9.200000] lowrisc_digilent_ethernet lowrisc_digilent_ethernet: Lowrisc Ether100MHz registered
[    9.300000] Card inserted, mask changed to 4
[    9.330000] NET: Registered protocol family 17
[    9.340000] Key type dns_resolver registered
[    9.360000] mmc0: mmc_rescan_try_freq: trying to init card at 5000000 Hz
[    9.530000] Freeing unused kernel memory: 856K (ffffffff80000000 - ffffffff800d6000)
[    9.550000] This architecture does not have kernel memory protection.
Running the initial fake init
[   10.040000] Open device, request interrupt
Setting the clock ...
[   10.860000] mmc0: new SDHC card at address 0007
[   10.880000] blk_queue_max_hw_sectors: set to minimum 8
[   10.900000] mmcblk0: mmc0:0007 SD08G 7.42 GiB 
[   10.970000]  mmcblk0: p1
Mounting the nfs partition ...
Switch to nfs root
INIT: version 2.88 booting
bootlogd: cannot find console device 4:0 under /dev
[   51.130000] random: nonblocking pool is initialized

## Mount an SD card inside RISC-V Linux

To discover whether an SD is recognized by the kernel:

    cat /proc/partitions

If an SD card is formated in FAT32 and inserted (hot insertion not supported in this kernel), it should look like:

     179        0    7707648 mmcblk0
     179        1    7706624 mmcblk0p1

The first two device nodes, and first mount point are pre-created for you. If you created further partitions manually, create the device node as follows:

    mkdir /mnt2
    mkdir /mnt3
    mknod /dev/mmcblk0p2 b 179 2
    mknod /dev/mmcblk0p3 b 179 3 #etc..

To mount a DOS file system from this card:

    mount /dev/mmcblk0p1 /mnt

After you finished with the SD card, remember to unmount it.

    umount /mnt

To mount a manually created ext2 chroot partition from this card:

    mount /dev/mmcblk0p2 /mnt
    mount -t proc none /mnt/proc
    chroot /mnt

After you finished with the chroot partition, remember to unmount it.

    exit
    umount /mnt/proc
    umount /mnt
