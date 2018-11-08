+++
Description = ""
date = "2018-09-14T13:26:41+01:00"
title = "Getting started"

+++

## Getting Started with the refresh-v0.6 prebuilt binaries

This guide will walk you through downloading the binaries of the latest lowRISC release and booting it
on a Nexys4DDR FPGA.

*    You will require:
*    A Linux PC with sudo access with two readily accessible USB ports
*      (these instructions apply to Ubuntu 16.04.5 LTS)
*    A Nexys4DDR FPGA board from Digilent with combined power and USB cable
*    A micro-SD card (minimum 4GBytes capacity)
*    A PC-compatible SD-card reader

## Choosing a hardware configuration

lowRISC can be configured standalone, mimicking a PC, or with a remote serial console (not to be confused with the tethered option mentioned in some RISCV documentation sources). For the remote console option the FPGA configuration can come from USB memory stick, so the large (up to 28GBytes) Vivado installation is not required. For the standalone option it has to come from Quad-SPI flash memory.

### Remote console requirements

*   A USB memory stick if you don't want to use Vivado and Quad-SPI.
*   Install microcom or your favourite terminal emulator program (remote keyboard option only will be available)
*    You will need to use the following command to allow microcom to run as the non-superuser:
*    sudo usermod -a -G dialout $USER

### Standalone (PC free) requirements
    
*   A VGA compatible LCD monitor
*   A PS/2 style PC-AT keyboard with USB connector
*   A copy of Vivado 2018.1 webpack edition (with SDK if you plan to do development) to program the Quad-SPI

#### For both options a 100Base-T Ethernet cable to a home hub or corporate LAN is recommended.

The quickstart Makefile should be installed as follows:

    git clone https://github.com/lowRISC/lowrisc-quickstart.git
    cd lowrisc-quickstart
    
If you don't have git installed the following workaround may be used:

    wget https://github.com/lowRISC/lowrisc-quickstart/archive/master.zip
    unzip master
    cd lowrisc-quickstart-master

However the Makefile was obtained, proceed as follows to obtain the release files:

    make getrelease

Three files will be downloaded as follows:

*   boot.bin - The Linux kernel, Berkeley boot loader, and initial cpio (ramdisk)
*   chip_top.bit - The FPGA bitstream containing the RISCV processor and peripherals and the first-stage booter
*   rootfs.tar.xz - The compressed tape archive containing the Debian root filing system for RISCV

Type lsblk before and after inserting the SD-card and its adaptor into the computer. You should see new devices added, similar to the following:

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part /media/jrrk2/2BBB-DCFE
    ├─sdc2   8:34   1     2G  0 part /media/jrrk2/c7370d8e-67dd-405f-abe5-0a6d40fef98d
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part /media/jrrk2/578a1c8d-92c9-48cb-9fdc-c593d5c68107

## READ THIS WARNING (!)

The procedure below erases all data on the disk, so do not mistakenly specify your hard drive or external mass storage. Some checks will be carried out, such as skipping UUIDs found in /etc/fstab.
If your USB disk shows up as something other than sdc, you need to run the following commands with the parameter

    USB=whatever, where whatever is whatever your removable disk is called

#### IF YOU DO NOT UNDERSTAND THIS, DO NOT PROCEED, GET SOME HELP !!!

If you use a fresh card, only sdc1 will typically be present. If you use the recommended operating system Ubuntu 16.04.5 LTS, any known partitions will be mounted and automatically shown in windows. In this case do

    make umount USB=sdc

otherwise, continue with

    make USB=sdc cleandisk partition

You may get an error, Re-reading the partition table failed.: Device or resource busy, in this case remove the card reader and reinsert it. do another make umount if necessary, and run lsblk again, You should see:

    sdc      8:32   1  14.9G  0 disk 
    ├─sdc1   8:33   1    32M  0 part 
    ├─sdc2   8:34   1     2G  0 part 
    ├─sdc3   8:35   1   512M  0 part 
    └─sdc4   8:36   1  12.3G  0 part 

The new partition table defaults to: 32Mbytes for DOS partition, 2G for the root, 512M for swap, and the rest for /home. If you don't like these numbers they can be edited in the file cardmem.sh

The next few steps can all be executed in one go:

    make USB=sdc mkfs fatdisk extdisk

You will be asked to confirm if the card previously had readable data on it. The first step makes the new filing systems, the second step writes the kernel+BBL to the DOS partition, and the third step extracts the root filing system. Unmounting the disk at the end of this process can take a while due to buffering. Do not attempt to remove the card reader until the umount completes. This SD-card is ready to be inserted in the slot underneath the Digilent board near to the USB connector.

## Remote console installation

For remote installation the USB master function is not needed and may be used to contain the required bitstream. Vivado is not needed which is an advantage since it is a multi-gigabyte download. You can use the following command (all the same caveats about being very careful to choose the correct disk apply as above)

    make memstick USB=sdc

To use this method JP1 must be in the USB/SD position and JP2 should be in the USB position. Once configured, the USB stick is inaccessible to Linux and cannot be used to store other files. After pressing the PROG button with the USB memory stick inserted the BUSY light should glow amber steadily for 30 seconds or so, then the green DONE light will come on. In the event of failure, the amber BUSY light will flash slowly, in this case it is worth trying a different memory stick.

Configuration from SD-Card is not supported in this release (because the onboard PIC places the SD-Card in 1-bit SPI mode, and we need it in 4-bit SD mode). If a method is found to return to 4-bit SD-mode, then this mode can be supported in a future release.

## Standalone installation

For standalone installation Vivado is required and the bitstream will be installed in QSPI memory. Even if you don't require standalone use, this method is preferred for reliability and performance. The Nexys4-DDR board should be plugged in and powered up, and the Digilent drivers should have been installed as per the manufacturer's recommendations.

    make program-cfgmem

This action will have no effect unless the programming jumper JP1 is in the QSPI position.

## Switch settings

   In addition to setting JP1 and JP2, the DIP-SW 1 (next to LED1) should be on and the others off, unless you have more than one board booted in which case DIP-SW 15-12 should be used to set a unique MAC address.
   
## Boot log

### This is the output from boot.c

    lowRISC boot program
    =====================================
    Hello LowRISC! Tue Aug 14 10:40:47 2018: Booting from FLASH because SW1 is high ..

### And this is the output from the FSBL

    u-boot based first stage boot loader
    MMC:   
    mmc created at 86800248, host = 86800200
    lowrisc_sd: 0
    Device: lowrisc_sd
    Manufacturer ID: 3
    OEM: 5344
    Name: SL16G 
    Bus Speed: 5000000
    High Capacity: Yes
    Capacity: 
    lu.ld GiB
    Bus Width: 4-bit

If it doesn't say Bus Width: 4-bit, then your SD-Card failed to be detected or was stuck in an incorrect mode.
You should hit the CPU_RESET and/or power off to retry.

### This is just a basic smoke test of the boot sector read capability

    0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    20:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    60:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    80:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    a0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    140:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    160:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    180:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    1a0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ef be ad de 00 00 80 00
    1c0:  01 01 0c 3f 1f 20 00 08 00 00 ff ff 00 00 00 00 01 21 83 3f 20 20 00 08 01 00 00 00 40 00 00 00
    1e0:  01 21 82 3f a0 20 00 08 41 00 00 00 10 00 00 00 81 21 83 1f e0 59 00 08 51 00 00 c4 89 01 55 aa

### You will get a spinning cursor for perhaps 30 seconds at this point

    Load boot.bin into memory
    -Loaded 6826312 bytes to memory address 87000000 from boot.bin of 6826312 bytes.

### This value can be checked under Linux using the 'md5sum boot.bin' command. It shows your hardware is good.

    hash = c36551a33100d1d5d07eeb765880dc35

### This copies the BBL and vmlinux segments to their correct places (no relocation is done)

    load elf to DDR memory
    Section[0]: memcpy(80000000,0x87001000,0x8c90);
    Section[1]: memcpy(80009000,0x8700a000,0x59);
    memset(80009059,0,0x2007);
    Section[2]: memcpy(80200000,0x8700b000,0x677754);
    Boot the loaded program...

### This printout occurs because --enable-print-device-tree is turned on in BBL
     {
      #address-cells = <0x00000001>;
      #size-cells = <0x00000001>;
      compatible = "freechips,rocketchip-unknown-dev";
      model = "freechips,rocketchip-unknown";
      cpus {
        #address-cells = <0x00000001>;
        #size-cells = <0x00000000>;
        cpu@0 {
          clock-frequency = <0x00000000>;
          compatible = "sifive,rocket0", "riscv";
          d-cache-block-size = <0x00000040>;
          d-cache-sets = <0x00000040>;
          d-cache-size = <0x00004000>;
          d-tlb-sets = <0x00000001>;
          d-tlb-size = <0x00000020>;
          device_type = "cpu";
          i-cache-block-size = <0x00000040>;
          i-cache-sets = <0x00000040>;
          i-cache-size = <0x00004000>;
          i-tlb-sets = <0x00000001>;
          i-tlb-size = <0x00000020>;
          mmu-type = "riscv,sv39";
          next-level-cache = <0x00000001>;
          reg = <0x00000000>;
          riscv,isa = "rv64imafdc";
          status = "okay";
          timebase-frequency = <0x0007a120>;
          tlb-split;
          interrupt-controller {
            #interrupt-cells = <0x00000001>;
            compatible = "riscv,cpu-intc";
            interrupt-controller;
            phandle = <0x00000002>;
          }
        }
      }
      memory@80000000 {
        device_type = "memory";
        reg = <0x80000000 0x08000000>;
        phandle = <0x00000001>;
      }
      soc {
        #address-cells = <0x00000001>;
        #size-cells = <0x00000001>;
        compatible = "freechips,rocketchip-unknown-soc", "simple-bus";
        ranges;
        error-device@3000 {
          compatible = "sifive,error0";
          reg = <0x00003000 0x00001000>;
          reg-names = "mem";
        }
        external-interrupts {
          interrupt-parent = <0x00000003>;
          interrupts = <0x00000001 0x00000002 0x00000003 0x00000004>;
        }
        interrupt-controller@c000000 {
          #interrupt-cells = <0x00000001>;
          compatible = "riscv,plic0";
          interrupt-controller;
          interrupts-extended = <0x00000002 0xffffffff 0x00000002 0x00000009>;
          reg = <0x0c000000 0x04000000>;
          reg-names = "control";
          riscv,max-priority = <0x00000007>;
          riscv,ndev = <0x00000004>;
          phandle = <0x00000003>;
        }
        rom@10000 {
          compatible = "sifive,rom0";
          reg = <0x00010000 0x00010000>;
          reg-names = "mem";
        }
        lowrisc-mmc@40010000 {
          reg = <0x40010000 0x00010000>;
          interrupt-parent = <0x00000003>;
          interrupts = <0x00000004>;
          reg-io-width = <0x00000008>;
          reg-shift = <0x00000003>;
          compatible = "lowrisc-mmc";
        }
        lowrisc-eth@40020000 {
          reg = <0x40020000 0x00008000>;
          interrupt-parent = <0x00000003>;
          interrupts = <0x00000003>;
          reg-io-width = <0x00000008>;
          reg-shift = <0x00000003>;
          compatible = "lowrisc-eth";
        }
        lowrisc-keyb@40030000 {
          reg = <0x40030000 0x00004000>;
          interrupt-parent = <0x00000003>;
          interrupts = <0x00000002>;
          reg-io-width = <0x00000008>;
          reg-shift = <0x00000003>;
          compatible = "lowrisc-keyb";
        }
        lowrisc-fake@40034000 {
          reg = <0x40034000 0x00004000>;
          interrupt-parent = <0x00000003>;
          interrupts = <0x00000001>;
          reg-io-width = <0x00000008>;
          reg-shift = <0x00000003>;
          compatible = "lowrisc-fake";
        }
        lowrisc-vga@40038000 {
          reg = <0x40038000 0x00004000>;
          reg-io-width = <0x00000008>;
          reg-shift = <0x00000003>;
          compatible = "lowrisc-vga";
        }
      }
    }

### This memory is reserved for BBL (still needed for unaligned address exceptions and kernel timer control)

    [    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
    [    0.000000] Linux version 4.18.0 (jrrk2@brexit.cl.cam.ac.uk) (gcc version 7.2.0 (GCC)) #1 Mon Sep 17 15:51:36 BST 2018
    [    0.000000] bootconsole [early0] enabled
    [    0.000000] Initial ramdisk at: 0x(____ptrval____) (1117799 bytes)
    [    0.000000] Zone ranges:
    [    0.000000]   DMA32    empty
    [    0.000000]   Normal   [mem 0x0000000080200000-0x0000000087ffffff]
    [    0.000000] Movable zone start for each node
    [    0.000000] Early memory node ranges
    [    0.000000]   node   0: [mem 0x0000000080200000-0x0000000087ffffff]
    [    0.000000] Initmem setup node 0 [mem 0x0000000080200000-0x0000000087ffffff]
    [    0.000000] On node 0 totalpages: 32256
    [    0.000000]   Normal zone: 504 pages used for memmap
    [    0.000000]   Normal zone: 32256 pages, LIFO batch:7

### The SWIOTLB is set to 1MB (a minimal value) because we only have 128MB of memory overall on this board

    [    0.000000] software IO TLB [mem 0x87cfd000-0x87dfd000] (1MB) mapped at [(____ptrval____)-(____ptrval____)]
    [    0.000000] elf_hwcap is 0x112d
    [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
    [    0.000000] pcpu-alloc: [0] 0 
    [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 31752
    [    0.000000] Kernel command line: 
    [    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
    [    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
    [    0.000000] Sorting __ex_table...
    [    0.000000] Memory: 119044K/129024K available (3524K kernel code, 244K rwdata, 830K rodata, 1228K init, 783K bss, 9980K reserved, 0K cma-reserved)
    [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
    [    0.000000] NR_IRQS: 0, nr_irqs: 0, preallocated irqs: 0

### The four hardware interrupts sources are uart, spi(not used), ethernet and SD-Card

    [    0.000000] plic: mapped 4 interrupts to 1 (out of 2) handlers.
    [    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff max_cycles: 0x1d854df40, max_idle_ns: 7052723233920 ns
    [    0.000000] Console: colour dummy device 128x32
    [    0.000000] console [tty0] enabled
    [    0.000000] bootconsole [early0] disabled

### Internally, lowrisc uses a VGA colour buffer, whether or not a VGA monitor is connected

         2.660000] Console: switching to colour lowrisc device 128x31
    [    3.400000] loop: module loaded
    [    3.560000] libphy: Fixed MDIO Bus: probed
    [    3.570000] lowrisc-digilent-ethernet: Lowrisc ethernet platform (40020000-40027FFF) mapped to ffffffd004010000

### lowrisc only supports 100BaseT, so PHY traffic will be minimal, and bit banged PHY control is adequate

    [    3.580000] libphy: GPIO Bitbanged LowRISC: probed
    [    3.580000] Probing lowrisc-0:01

### The PHY chip is working ...

    [    3.690000] SMSC LAN8710/LAN8720 lowrisc-0:01: attached PHY driver [SMSC LAN8710/LAN8720] (mii_bus:phy_addr=lowrisc-0:01, irq
    =POLL)
    [    3.710000] lowrisc-eth 40020000.lowrisc-eth: Lowrisc Ether100MHz registered

### The remote UART keyboard is mapped to HID events, so that local HID keyboard and remote are in parallel

    [    3.710000] lowrisc_kbd_probe
    [    3.720000] hid_keyboard address 40030000, remapped to ffffffd00401c000
    [    3.730000] input: 40030000.lowrisc-keyb as /devices/platform/soc/40030000.lowrisc-keyb/input/input0
    [    3.730000] Clear any pending input
    [    3.740000] Loading keyboard input device returns success
    [    3.750000] lowrisc_fake_probe
    [    3.750000] fake_keyboard address 40034000, remapped to ffffffd004024000
    [    3.760000] input: 40034000.lowrisc-fake as /devices/platform/soc/40034000.lowrisc-fake/input/input1

### We detected an SD-card was inserted ...

    [    3.770000] lowrisc-digilent-sd: Lowrisc sd platform driver (40010000-4001FFFF) mapped to ffffffd004030000
    [    3.810000] lowrisc-sd driver loaded, IRQ 4
    [    3.810000] Card inserted, mask changed to 4

### The IPv4 and IPv6 stacks were loaded

    [    3.830000] NET: Registered protocol family 10
    [    3.860000] Segment Routing with IPv6
    [    3.860000] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
    [    3.880000] NET: Registered protocol family 17
    [    3.890000] Loading compiled-in X.509 certificates

### The cpio archive and other temporary storage was discarded

    [    3.930000] Freeing unused kernel memory: 1228K
    [    3.940000] This architecture does not have kernel memory protection.

### The SD-Card protocol layer found a memory card

    [    4.530000] mmc0: new SDHC card at address aaaa
    [    4.540000] blk_queue_max_hw_sectors: set to minimum 8
    [    4.550000] mmcblk0: mmc0:aaaa SL16G 14.8 GiB

### 4 partitions were found (MSDOS for booting, ext4 for rootfs, swap, and ext4 for /home

    [    4.570000]  mmcblk0: p1 p2 p3 p4
    Mounting SD root
    [    6.270000] random: fast init done

### Somebody failed to shut down properly, but we got away with it

    [    7.450000] EXT4-fs (mmcblk0p2): recovery complete
    [    7.480000] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
    Mounting proc
    Mounting sysfs
    Mounting devtmpfs
    Mounting devpts
    Mounting tmpfs

### The SD-root is mounted, we can nuke our temporary root (from .cpio)

    Executing switch_root
    [   10.380000] random: crng init done

### This is the start of the real init process

    INIT: version 2.88 booting
    [info] Using makefile-style concurrent boot in runlevel S.
    [info] Setting the system clock.

### We don't have a clock on this board, but no matter ntpd will be started shortly

    hwclock: Cannot access the Hardware Clock via any known method.
    hwclock: Use the --verbose option to see the details of our search for an access method.
    [warn  (warning).set System Clock to: Thu Jan 1 00:00:24 UTC 1970 ...
    [ ok  done.vating swap...
    [   28.860000] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
    [....] Checking root file system...fsck from util-linux 2.32.1
    /dev/mmcblk0p2: clean, 27295/131072 files, 220019/524288 blocks
    done.
    [   31.870000] EXT4-fs (mmcblk0p2): re-mounted. Opts: (null)
    [ ok  done.vating lvm and md swap...
    [....] Checking file systems...fsck from util-linux 2.32.1

### We want to mount the MSDOS partition in case the kernel needs updating in place

    fsck.fat 4.1 (2017-01-24)
    0x25: Dirty bit is set. Fs was not properly unmounted and some data may be corrupt.
     Automatically removing dirty bit.
    Performing changes.
    /dev/mmcblk0p1: 1 files, 3334/16343 clusters
    /dev/mmcblk0p4: recovering journal
    /dev/mmcblk0p4: clean, 15/807840 files, 91356/3225728 blocks
    fsck exited with status code 1
    done.
    [ ok  .Cleaning up temporary files... /tmp

### The /home (user files)

    [   49.320000] EXT4-fs (mmcblk0p4): mounted filesystem with ordered data mode. Opts: (null)
    [ ok  done.ting local filesystems...
    [ ok  done.vating swapfile swap...
    [ ok  .Cleaning up temporary files...
    [ ok  .Starting Setting kernel variables: sysctl

### The Ethernet media access controller was found ...

    [....] Configuring network interfaces...[   68.240000] Open device, request interrupt 3
    [   68.250000] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
    [   69.280000] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
    Internet Systems Consortium DHCP Client 4.3.5
    Copyright 2004-2016 Internet Systems Consortium.
    All rights reserved.
    For info, please visit https://www.isc.org/software/dhcp/
    Listening on LPF/eth0/ee:e1:e2:e3:e4:e5
    Sending on   LPF/eth0/ee:e1:e2:e3:e4:e5
    Sending on   Socket/fallback
    DHCPREQUEST of 128.232.60.114 on eth0 to 255.255.255.255 port 67
    DHCPREQUEST of 128.232.60.114 on eth0 to 255.255.255.255 port 67

### A DHCP server was found! Note the address 128.232.60.114 in this case only, your value will differ.

    DHCPACK of 128.232.60.114 from 128.232.60.8
    invoke-rc.d: could not determine current runlevel
    bound to 128.232.60.114 -- renewal in 18801 seconds.
    done.
    [ ok  .Starting RPC port mapper daemon: rpcbind
    [FAIL  failed!g NFS common utilities: statd idmapd
    [ ok  .Cleaning up temporary files...
    [FAIL  failed!r: service(s) returned failure: nfs-common ...
    INIT: Entering runlevel: 2
    [info] Using makefile-style concurrent boot in runlevel 2.
    [ ok  .Starting cgroup management daemon: cgmanager[....] Starting system message bus: dbus
    [....] Starting cgroup management proxy daemon: cgproxyRecovering nvi editor sessions.
    none found.

### The time server is starting

    [ ok  .Starting NTP server: ntpd

### Finally, we are ready to do some real work

    Debian GNU/Linux buster/sid lowrisc tty1
    lowrisc login: 

You should logon as root in the first instance. The firstboot script (from firstboot.riscv in the top directory) will be active, you will able to set the super-user password immediately as well as create a non-privileged user. This user will be the user that was active when the make extdisk step above was executed. If this does not suit, then more users can be created in a subsequent root session. Unless the firstboot script is aborted, it will automatically delete itself and return to the logon prompt.

## A simple ssh session

If an Ethernet connection is available, it should be used:

#### To get the correct time
#### To allow software and updates to be downloaded
#### To allow ssh logins
#### To get a rich Linux experience

ssh by default does not allow root to login over the network. If you followed the procedure above to create a non-privileged user, it should be possible to ssh to the lowrisc using the address bound above (substituting the value from your own session of course). You can also confirm the value using the 'ifconfig eth0' command.

    ssh  128.232.60.114
    (possible security warnings here)
    jrrk2@128.232.60.114's password: 
    Linux lowrisc 4.18.0 #1 Mon Sep 17 15:51:36 BST 2018 riscv64

    The programs included with the Debian GNU/Linux system are free software;
    the exact distribution terms for each program are described in the
    individual files in /usr/share/doc/*/copyright.

    Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.
    Last login: Wed Sep 19 14:18:39 2018
    jrrk2@lowrisc:~$ git clone https://github.com/eembc/coremark.git
    Cloning into 'coremark'...
    remote: Counting objects: 147, done.
    remote: Total 147 (delta 0), reused 0 (delta 0), pack-reused 147
    Receiving objects: 100% (147/147), 413.40 KiB | 88.00 KiB/s, done.
    Resolving deltas: 100% (87/87), done.
    Checking out files: 100% (103/103), done.
    jrrk2@lowrisc:~$ 

If this doesn't work, you should carry out the usual checks that you connected to the internet, e.g.

    root@lowrisc:~# ifconfig eth0
    eth0: flags=67<UP,BROADCAST,RUNNING>  mtu 1500
            inet 128.232.60.114  netmask 255.255.252.0  broadcast 128.232.63.255
            inet6 fe80::ece1:e2ff:fee3:e4e5  prefixlen 64  scopeid 0x20<link>
            ether ee:e1:e2:e3:e4:e5  txqueuelen 1000  (Ethernet)
            RX packets 14427  bytes 2687808 (2.5 MiB)
            RX errors 0  dropped 1  overruns 0  frame 0
            TX packets 246  bytes 22501 (21.9 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    root@lowrisc:~# netstat -r
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    default         route.cl.cam.ac 0.0.0.0         UG        0 0          0 eth0
    128.232.60.0    0.0.0.0         255.255.252.0   U         0 0          0 eth0
    root@lowrisc:~# 

If all is well, you may proceed as follows:

    jrrk2@lowrisc:~$ cd coremark
    jrrk2@lowrisc:~/coremark$ make PORT_DIR=linux64
    make XCFLAGS=" -DPERFORMANCE_RUN=1" load run1.log
    make[1]: Entering directory '/home/jrrk2/coremark'
    make port_prebuild
    make[2]: Entering directory '/home/jrrk2/coremark'
    make[2]: Nothing to be done for 'port_prebuild'.
    make[2]: Leaving directory '/home/jrrk2/coremark'
    make link
    make[2]: Entering directory '/home/jrrk2/coremark'
    gcc -O2 -Ilinux64 -I. -DFLAGS_STR=\""-O2 -DPERFORMANCE_RUN=1  -lrt"\" -DITERATIONS=0 -DPERFORMANCE_RUN=1 core_list_join.c core_main.c core_matrix.c core_state.c core_util.c linux64/core_portme.c -o ./coremark.exe -lrt
    Link performed along with compile
    make[2]: Leaving directory '/home/jrrk2/coremark'
    (boring stuff removed here)
    ./coremark.exe  0x3415 0x3415 0x66 0 7 1 2000  > ./run2.log
    make port_postrun
    make[2]: Entering directory '/home/jrrk2/coremark'
    make[2]: Nothing to be done for 'port_postrun'.
    make[2]: Leaving directory '/home/jrrk2/coremark'
    make[1]: Leaving directory '/home/jrrk2/coremark'
    Check run1.log and run2.log for results.
    See readme.txt for run and reporting rules.

### And here are the results

    jrrk2@lowrisc:~/coremark$ more run2.log
    2K validation run parameters for coremark.
    CoreMark Size    : 666
    Total ticks      : 18980
    Total time (secs): 18.980000
    Iterations/Sec   : 105.374078
    Iterations       : 2000
    Compiler version : GCC8.2.0
    Compiler flags   : -O2 -DPERFORMANCE_RUN=1  -lrt
    Memory location  : Please put data memory location here
                            (e.g. code in flash, data on heap etc)
    seedcrc          : 0x18f2
    [0]crclist       : 0xe3c1
    [0]crcmatrix     : 0x0747
    [0]crcstate      : 0x8d84
    [0]crcfinal      : 0x0cac
    Correct operation validated. See readme.txt for run and reporting rules.

### By a curious coincidence, this is exactly 200 times slower than my desktop PC.

## Installing your own favourite languages and utilities

Courtesy of debian sid, the majority of commonly asked for packages have been ported to RISCV.
There is a price to pay on installation time relative to the PC based initial install. Nevertheless
this is an advantage over traditional embedded systems that have their filesystem frozen, complete
with any security bugs, at manufacturing time.

Installation is done with the apt install command, either on the console logged on as root, or
remotely by adding your chosen user to the sudo group.

In general embedded systems should stick to C and C++, and avoid perl, python, ruby, mono, .NET etc

For example, although lowRISC can run Fedora or OpenSUSE RISCV, the user experience is script heavy
compared to Debian. At this time source distributions and self-hosting are not practical propositions

#### Example (some details omitted):

    jrrk2@lowrisc:~$ apt install ocaml-nox
    Reading package lists... Done
    Building dependency tree       
    Reading state information... Done
    The following additional packages will be installed:
      camlp4 ledit libcamlp4-ocaml-dev libfindlib-ocaml libfindlib-ocaml-dev libncurses-dev libncurses5-dev ocaml-base-nox
      ocaml-compiler-libs ocaml-findlib ocaml-interp
    Suggested packages:
      ncurses-doc ocaml-doc tuareg-mode | ocaml-mode
    The following NEW packages will be installed:
      camlp4 ledit libcamlp4-ocaml-dev libfindlib-ocaml libfindlib-ocaml-dev libncurses-dev libncurses5-dev ocaml-base-nox
      ocaml-compiler-libs ocaml-findlib ocaml-interp ocaml-nox
    0 upgraded, 12 newly installed, 0 to remove and 0 not upgraded.
    Need to get 44.8 MB of archives.
    After this operation, 231 MB of additional disk space will be used.
    Do you want to continue? [Y/n] 
    Get:1 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ocaml-base-nox riscv64 4.05.0-10+b1 [521 kB]
    Get:2 http://ftp.ports.debian.org/debian-ports sid/main riscv64 libncurses-dev riscv64 6.1+20180714-1 [662 kB]
    Get:4 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ocaml-compiler-libs riscv64 4.05.0-10+b1 [11.1 MB]
    Get:5 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ocaml-interp riscv64 4.05.0-10+b1 [3587 kB]
    Get:6 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ocaml-nox riscv64 4.05.0-10+b1 [12.0 MB]
    Get:7 http://ftp.ports.debian.org/debian-ports sid/main riscv64 libcamlp4-ocaml-dev riscv64 4.05+1-2 [15.9 MB]
    Get:8 http://ftp.ports.debian.org/debian-ports sid/main riscv64 camlp4 riscv64 4.05+1-2 [643 kB]
    Get:9 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ledit all 2.04-1 [49.1 kB]
    Get:10 http://ftp.ports.debian.org/debian-ports sid/main riscv64 libfindlib-ocaml riscv64 1.7.3-2+b1 [115 kB]
    Get:11 http://ftp.ports.debian.org/debian-ports sid/main riscv64 libfindlib-ocaml-dev riscv64 1.7.3-2+b1 [88.6 kB]
    Get:12 http://ftp.ports.debian.org/debian-ports sid/main riscv64 ocaml-findlib riscv64 1.7.3-2+b1 [196 kB]
    Fetched 44.8 MB in 6min 7s (122 kB/s)
    debconf: delaying package configuration, since apt-utils is not installed
    Selecting previously unselected package ocaml-base-nox.
    (Reading database ... 23681 files and directories currently installed.)
    Preparing to unpack .../00-ocaml-base-nox_4.05.0-10+b1_riscv64.deb ...
    Preparing to unpack .../01-libncurses-dev_6.1+20180714-1_riscv64.deb ...
    Preparing to unpack .../02-libncurses5-dev_6.1+20180714-1_riscv64.deb ...
    Preparing to unpack .../03-ocaml-compiler-libs_4.05.0-10+b1_riscv64.deb ...
    Preparing to unpack .../04-ocaml-interp_4.05.0-10+b1_riscv64.deb ...
    Preparing to unpack .../05-ocaml-nox_4.05.0-10+b1_riscv64.deb ...   
    Preparing to unpack .../06-libcamlp4-ocaml-dev_4.05+1-2_riscv64.deb ...
    Preparing to unpack .../07-camlp4_4.05+1-2_riscv64.deb ...
    Preparing to unpack .../08-ledit_2.04-1_all.deb ...
    Preparing to unpack .../09-libfindlib-ocaml_1.7.3-2+b1_riscv64.deb ...
    Preparing to unpack .../10-libfindlib-ocaml-dev_1.7.3-2+b1_riscv64.deb ...
    Preparing to unpack .../11-ocaml-findlib_1.7.3-2+b1_riscv64.deb ...
    Setting up ocaml-base-nox (4.05.0-10+b1) ...
    Setting up libncurses-dev:riscv64 (6.1+20180714-1) ...
    Setting up libfindlib-ocaml (1.7.3-2+b1) ...
    Setting up ocaml-findlib (1.7.3-2+b1) ...
    Setting up ledit (2.04-1) ...
    update-alternatives: using /usr/bin/ledit to provide /usr/bin/readline-editor (readline-editor) in auto mode
    Setting up libncurses5-dev:riscv64 (6.1+20180714-1) ...
    Setting up ocaml-compiler-libs (4.05.0-10+b1) ...
    Setting up ocaml-interp (4.05.0-10+b1) ...
    Setting up ocaml-nox (4.05.0-10+b1) ...
    Setting up libcamlp4-ocaml-dev (4.05+1-2) ...
    Setting up camlp4 (4.05+1-2) ...
    Setting up libfindlib-ocaml-dev (1.7.3-2+b1) ...
    root@lowrisc:~# 

#### Runtime example:

    jrrk2@lowrisc:~$ ocaml
            OCaml version 4.05.0

    # 355./.113.;;
    - : float = 3.14159292035398252
    # let rec fact n = if n > 0 then n*fact(n-1) else 1;;
    val fact : int -> int = <fun>
    # fact 6;;
    - : int = 720
    # exit 0;;

## Console behaviour

To save providing many different binaries, lowRISC release refresh-v0.6 only provides one console choice.
This is the VT console, also known as the PC screen. This provides the best experience because error messages
are in colour and so-on. But we also need to cater for situations where this hardware is not available, so
the PC hardware driver incorporates a hook to deliver console output to the serial port also. This is adequate,
but lacks the sophistication required for full-screen editing, because the sequences send to the VT console
are very different to what a serial console requires. This is why ssh connection is recommended for
extensive use, because the users's preferences such as ANSI control sequences will be reflected in the type of
host connection.

## Customising the installation in Linux

Because emulation on FPGA is rather slow compared to a modern PC, it is convenient to have a procedure
to customise the installation on a PC. This can also be used as a rescue method if the password is locked
or similar eventualities. In addition the card reader is optimised for performance and can take advantage
of higher speed modes and better signal integrity that have been introduced from time to time.

    make customise
    dpkg-reconfigure locales
    dpkg-reconfigure tzdata
    apt install gnuchess

This method relies on misc binary emulation for RISCV being installed (typically in /proc/sys/fs/binfmt_misc/qemu-riscv64)

### How does this work

RISCV executables under Linux use a posix style convention for system calls (open, read, write etc). Under FPGA emulation these map to the running RISCV kernel. Under PC qemu emulation these foreign binaries are recognised as scripts for /usr/bin/qemu-riscv64-static, which interprets the executable with just-in-time conversion and translates the system calls to regular x86-64 Linux kernel calls. This behaviour breaks down if you try to access kernel data structures that do not match, but is useful for the majority of tasks.

## Debugging

Without a doubt the quality of the debugger is the number one feature software engineers look for when choosing a processor. A primary aim of the refresh-v0.6 release is updating the technical content as much as possible (and making it easy to update further as needed). An important improvement in newer versions of Rocket has been the availability of a JTAG connection to allow gdb to be used on the running FPGA. Because the Xilinx device uses JTAG for many test and configuration purposes, it is not possible to match the instruction width and user JTAG registers from the debug specification. Only the Verilog, Chisel and openocd components are impacted by this change. The bitstream incorporated in this release has already been adjusted for this purpose (at the moment this also prevents Vivado internal logic analyser from working). The modified version of openocd may be compiled as follows:

    make debug

The patched version of openocd will be downloaded, built and launched. You should say output that eventually ends with:

    openocd -f openocd-nexys4ddr.cfg
    Open On-Chip Debugger 0.10.0+dev-00165-gdc312f5 (2018-09-20-09:51)
    Licensed under GNU GPL v2
    For bug reports, read
            http://openocd.org/doc/doxygen/bugs.html
    adapter speed: 10000 kHz
    Info : ftdi: if you experience problems at higher adapter clocks, try the command "ftdi_tdo_sample_edge falling"
    Info : clock speed 10000 kHz
    Info : JTAG tap: riscv.cpu tap/device found: 0x13631093 (mfg: 0x049 (Xilinx), part: 0x3631, ver: 0x1)
    Info : dtmcontrol_idle=5, dmi_busy_delay=1, ac_busy_delay=0
    Info : dtmcontrol_idle=5, dmi_busy_delay=2, ac_busy_delay=0
    Info : dtmcontrol_idle=5, dmi_busy_delay=3, ac_busy_delay=0
    Info : dtmcontrol_idle=5, dmi_busy_delay=4, ac_busy_delay=0
    Info : Disabling abstract command reads from CSRs.
    Info : Disabling abstract command writes to CSRs.
    Info : [0] Found 1 triggers
    Info : Examined RISC-V core; found 1 harts
    Info :  hart 0: XLEN=64, 1 triggers
    Info : Listening on port 3333 for gdb connections
    Info : Listening on port 6666 for tcl connections
    Info : Listening on port 4444 for telnet connections
    Info : accepting 'gdb' connection on tcp/3333

The window will remain unresponsive, waiting for a connection. In a second window, with the same directory, preferably quite large, issue the following command:

    make gdb

A sample session will open, after compiling bbl if needed. The following commands or some variant may be typed:

    target remote :3333 (this will connect to openocd, by default on the localhost)
    load (load the program over JTAG)
    set $priv=3 (force the processor to machine mode, if running Linux already supervisor or user mode will be the current mode)
    break printm (set a breakpoint on the printm function, this is bbl's equivalent of printf/printk)
    cont (continue, may be abbreviated to just c)

This will reset the program to the start address and run till the first printm statement. Other commands that might be useful:

    focus cmd (allows scrolling through previous commands, instead of scrolling the source code screen)
    layout asm (shows disassembly instead of source code)
    layout regs (shows low-level registers in parallel with disassembly)
    quit (ends the session)
    
consult the gdb documentation for details.

GDB sessions will only properly in machine mode at present. To debug Linux, it needs to be cognizant of page table entries.

## Software license.

These prebuilt binaries contain GNU software, the implication being that source code must be provided. Source for the Debian system is available upstream in

    http://www.debianmirror.de/debian-ports/pool-riscv64

Source for boot.bin is available on kernel.org and patches are automatically applied by typing:

    make all

Source for the first stage bootloader is available by typing:

    make lowrisc-fpga/STAMP.fpga

It is then available in the lowrisc-fpga/bare_metal directory
