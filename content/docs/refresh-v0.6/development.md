+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Build your own bitstream and images"
parent = "/docs/fpga-v0.6/"
showdisqus = true

+++

## Build the bare-metal RISCV toolchain (slow, but userland toolchain build is no longer necessary)

    cd $TOP/rocket-chip/riscv-tools/
    bash ./build.sh

## Build Linux and early stage root filesystem

These instructions assume you are running our recommended distribution Ubuntu 16.04.5 LTS

No pre-build installation images are available for our setup. So we accelerate the bootstrapping process using qemu.
This first step creates a RISCV emulation environment to short-circuit the complexities of preparing a rootfs

    cd $TOP/qemu
    ./configure --static --disable-system --target-list=riscv64-linux-user
    make

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

Then configure and build the kernel (not forgetting the device tree blob)

    cd $TOP/riscv-linux
    make ARCH=riscv defconfig scripts
    scripts/dtc/dtc arch/riscv/kernel/lowrisc.dts -O dtb -o arch/riscv/kernel/lowrisc.dtb
    make ARCH=riscv -j 4 CONFIG_INITRAMFS_SOURCE=initramfsmmc.cpio

N.B. In this release, since we only support one board, it is acceptable to build the blob into the kernel. To support multiple boards it would be better if it was stored in the boot loader or BBL.

Now configure and build Berkeley Boot loader

    cd $TOP/rocket-chip/riscv-tools/riscv-pk/
    mkdir -p build
    cd build
    ../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-payload=$TOP/riscv-linux/vmlinux --enable-logo
    make
    cp -p bbl $TOP/fpga/board/nexys4_ddr/boot.bin

Alternatively, if all is well you can let one script take care of it:

    cd $TOP/riscv-linux
    ./make_root.sh

### Generate the bitstream

#### FPGA demo with Fpga (default bootloader)

    cd $TOP/fpga/board/nexys4_ddr
    make cleanall
    make bitstream

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`.
This will take some time (20-60 minutes depending on your computer).

### Program the bootloader on FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the quad-SPI on the FPGA board:

    make cfgmem
    make program-cfgmem

At this point, you should check the MODE jumper is in QSPI mode and then press the PROG button.
The default bootloader assumes an Ethernet DHCP server is present, if so you should see a result similar to this:

    Calling main with MAC = eee1:4
    Selftest iteration 1, next buffer = 13, rx_start = 6800
    Selftest matches=2/2, delay = 11
    Selftest iteration 2, next buffer = 14, rx_start = 7000
    Selftest matches=4/4, delay = 11
    Selftest iteration 3, next buffer = 15, rx_start = 7800
    Selftest matches=8/8, delay = 12
    Selftest iteration 4, next buffer = 0, rx_start = 4000
    Selftest matches=16/16, delay = 22
    Selftest iteration 5, next buffer = 1, rx_start = 4800
    Selftest matches=32/32, delay = 41
    Selftest iteration 6, next buffer = 2, rx_start = 5000
    Selftest matches=64/64, delay = 80
    Selftest iteration 7, next buffer = 3, rx_start = 5800
    Selftest matches=128/128, delay = 159
    Selftest iteration 8, next buffer = 4, rx_start = 6000
    Selftest matches=187/187, delay = 231

This first bit establishes that digital loopback of the Ethernet is working. If this does not appear, search your build log for timing errors.

    0: 0
    1: 1
    2: 1
    3: 1
    800: 1e
    801: 0
    802: 0
    803: 0

This bit is just probing the platform level interrupt controller with some default values.

    lowRISC etherboot program
    =====================================
    MAC = eee1:4
    MAC address = ee:e1:e2:e3:e4:e4.
    eth0 MAC : EE:E1:E2:E3:E4:E4

This section is concerned with setting the MAC address, and reading it back. The least significant value read will depend on SW[15:12]

    Sending DHCP_DISCOVERY
    Waiting for DHCP_OFFER
    Sending DHCP_REQUEST
    DHCP ACK
    DHCP Client IP Address:  128.232.60.123
    Server IP Address:  128.232.60.8
    Router address:  128.232.60.1
    Net mask address:  255.255.252.0
    Lease time = 43200
    domain = "cl.cam.ac.uk"
    server = "lowrisc4-sm"

This section is the section that talks to your institution IT infrastructure, or your own PC if you use a direct cable. For the former case you will need to request that the MAC address be registered as valid centrally. Emphasize that it is a locally administered value and not a registered company value. If the Ethernet is unplugged or incapable of 100BaseT-DX operation, the display will likely stick after 'Waiting for DHCP_OFFER'. If you use a direct cable (recommended if you are experimenting), you need to install isc-dhcp-server (or similar) and create a config which includes the following:

    # This is a very basic subnet declaration.

    subnet 192.168.0.0 netmask 255.255.255.0 {
      range 192.168.0.100 192.168.0.127;
      option routers 192.168.0.53;
    }

    host lowrisc {
      hardware ethernet ee:e1:e2:e3:e4:e4;
      fixed-address 192.168.0.51;
    }

The use of the DIP switches 15:12 allows up to 16 different boards to be used. You should ensure that nobody else on your site is making use of the same range. It is a good idea to avoid changing the MAC address after powering up on a certain network port. Otherwise your router may decide you are a bad actor and refuse to talk to you.

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

### Boot Linux remotely on FPGA

You should have examples of remote booting in the Makefile known as etherlocal and etherremote.

Modify or duplicate these examples to reflect your local network topology, then

    make etherlocal or make etherremote
    
#### FPGA demo with Fpga (alternative boot programs)

    cd $TOP/fpga/board/nexys4_ddr
    make target (where target is mmc, dram, hello etc.)

The generated bitstream is located at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`.
First time through, this will take some time (20-60 minutes depending on your computer).

### Program the alternative boot programs on FPGA

Next, turn on the FPGA board and connect the USB cable. Now you
download the bitstream to the quad-SPI on the FPGA board:

    make cfgmem-updated
    make program-cfgmem-updated

## Useful Makefile targets

#### `make project`
Generate a Vivado project.

#### `make verilog`
Run Chisel compiler and generate the Verilog files for Rocket chip.

#### `make vivado`
Open the Vivado GUI using the current project.

#### `make bitstream`
Generate the default bitstream according to the `CONFIG` in Makefile and the program loaded in `src/boot.mem`. The default bitstream is generated at `lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit`

#### `make <hello|dram|eth|mmc>`
Generate bitstreams for bare-metal tests:

 * **hello** A hello world program.
 * **dram** A DDR RAM test.
 * **mmc** A 1st bootloader that loads `boot.bin` from SD to DDR RAM and executes `boot.bin` afterwards.

For each bare-metal test `<test>`, the executable is generated to 
`examples/<test>.riscv`. It is also converted into a hex
file and copied to `src/boot.mem`, which then changes the default program for 
`make bitstream` and `make simulation`. The updated bitstream is generated at 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <program|program-updated>`
Download a bitstream to FPGA. Use `program` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`program-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <cfgmem|cfgmem-updated>`
Convert a bitstream to the format suitable for quad-SPI flash on the FPGA board. Use `cfgmem` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`cfgmem-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <program-cfgmem|program-cfgmem-updated>`
Download a bitstream to quad-SPI flash on the FPGA board. Use `program-cfgmem` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.bit` and 
`program-cfgmem-updated` for 
`lowrisc-chip-imp/lowrisc-chip-imp.runs/impl_1/chip_top.new.bit`

#### `make <clean|cleanall>`
`make clean` will remove all generated code without removing the Vivado 
project files. To remove all files including the Vivado project, use `make 
cleanall`.
