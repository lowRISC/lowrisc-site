+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Configure the PMOD-BT"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### PMOD-BT introduction

This module is described [here](https://reference.digilentinc.com/reference/pmod/pmodbt2/start). Internally it uses a  [RN42 module] (http://ww1.microchip.com/downloads/en/devicedoc/rn-42-ds-v2.32r.pdf) which in turn uses a CSR BC04EXT. It comes with a serial port profile (SPP) stack running on the Bluetooth chip, intended for direct RF serial communication. Convenient as that may be for direct hardware use, this functionality needs to be disabled to get access to the host command interface (HCI) mode, to communicate with the bluez stack in the Linux kernel. In BC04EXT chips the mode of operation is determined by persistent store keys in pages two and three of the external flash memory. This memory is accessible via the serial peripheral interface (SPI) of the chip which requires a separate header to be soldered onto the module, a relatively easy job. The RISCV kernel could do this easily but for generality and because the software is nothing specific to LowRISC, we use the on-board USB interface of the Nexys4DDR to tunnel this protocol, which makes use of three input (CLK,CS,MOSI) and one output wire (MISO). The FT2232 USB to UART converter has a bit-banged mode which is suitable for this job, but unfortunately the way it is buffered makes it impossible to get access to more than 2 outputs in bit-bang mode. Since this is a one-off preparation step per PMOD-BT2, we use a separate Xilinx [ft2232c_ila project](https://github.com/jrrk2/ft2232c_ila.git) to work around this problem using tunnelling through the UART pins. After using this mode the USB connector has to be unplugged (resulting in a power on reset and re-enumeration) before the UART driver will work again. Since there are two channels it is possible for Vivado's logic analyzer mode to monitor the activity on the link simultaneously.

### The wiring connections to the PMOD-BT2 module

Four 0.1 inch pitch flying leads, preferably of different colours, are required. Also a 6-way
0.1 inch in-line header should be soldered to the SPI connector on the module as shown. If you
don't want to solder then a bed-of-nails type connector which clamps the board in place would
do equally well, especially if there are multiple boards to be modified.

![wiring illustration](/img/bt2wiring.png "PMOD-BT2 wiring photograph")

Do not connect the power from the PMOD to the SPI, because the polarity is reversed in some versions
of Digilent documentation. Power will be drawn from the main PMOD (JB). For the same reason do not
attempt to connect the BT2 module SPI connector directly to the PMOD.

![PMOD JA detail](/img/JA.png "PMOD JA wiring detail")

It will be seen that the left-hand PMOD (JA) pin (yellow in this instance) connects
to the nearest SPI header pin to the motherboard, and the remaining pins connect
in the same order.

![PMOD-BT2 SPI detail](/img/BT2SPI.png "PMOD-BT2 SPI wiring detail")

### Persistent-store modification software.

The BC04EXT (or other BlueCore flash based technology) runs on an embedded processor (called a XAP2). It does not matter what version of software is running, because the programming replaces the operational software with a stub that runs from on-chip RAM. It is very important that the remainder of the FLASH memory that we are not working on should not be disturbed, because it is unlikely a suitable replacement firmware will be available. The software allows the current software to be dumped as a safety measure. If you have multiple PMOD-BT2 modules it is certain that their persistent store settings will be different, especially with regard to analogue crystal frequency trim settings and digital settings such as the Bluetooth address and device name.

Therefore the goal of the [described software] (https://github.com/jrrk2/csrremote.git), is to disturb the chip as little as possible.

This software is 32-bit, for compatibility with any WINE software that might be installed, dependent libraries need to be installed as follows:

sudo apt install libusb-1.0-0-dev:i386 libftdi-dev:i386

starting from a convenient directory, proceed as follows (Vivado must already be in your path):

    git clone https://github.com/jrrk2/ft2232c_ila.git
    cd ft2232c_ila
    vivado  -source ft2232c_ila.tcl &
    cd ..
    
    git clone -b lowrisc https://github.com/jrrk2/csrremote.git
    cd csrremote
    make
    export PSMOD=1
    ./CsrUsbProg psmod psmod

## How it works

The BC04EXT chips consists for our purposes of a XAP2 CPU, FLASH interface, Bluetooth Baseband/RF, and UART/USB interfaces. When the above program is running, it takes control of the XAP2 and the FLASH, whilst ignoring anything it does not understand. The firmware when it next restarts will notice any changes in persistent store keys and activate them as appropriate. Normally this is done using a journalled flash filing system, however the above program modifies keys in place if it can since there is no implication for firmware which is not running.

The program will scan the flash journal to find which page is in use, skip over any pskeys it does not recognise, and modify in place, or add keys corresponding to any of the following which are not present (for example due to ROM defaults).

Refer to Pskey::modify for details. Life is easy because all the keys we are interested in are single (16-bit) word values:

    Disable virtual machine which would normally handle the SPP (serial port profile traffic):
    set_config(PSKEY_VM_DISABLE, 1);

    Divert the host control interface client off-chip (for Linux to handle instead):
    set_config(PSKEY_ONCHIP_HCI_CLIENT, 0);

    Set the UART configuration (parity, stop bits etc, to the BCSP client default):
    set_config(PSKEY_UART_CONFIG_BCSP, 0x0806);

    Set the host interface to UART mode (USB is not connected or usable if it was, in our module):
    set_config(PSKEY_HOST_INTERFACE, 1);

    Ensure the baudrate is fixed at 115200 baud. This makes it much easier to confirm correct operation with a PC.
    set_config(PSKEY_UART_BAUDRATE, div);

What is BCSP? It is BlueCore serial protocol, and is a multi-channel UART comms protocol for HCI which is somewhat inspired by SLIP (serial line interface protocol), a UART implementation of point-to-point TCP/IP links. It is not mandatory to have UART flow control (CTS/DTR).

## Testing the modifications.

The USB should be unplugged after using this program/bitstream. It is not sufficient to reset or power off the board because the USB converter is powered from the USB 5V line. With the regular bitstream in place, the Bluetooth UART will be diverted to the USB uart converter connected to the host if SW[4] (counting from 0) is high. With the powered up module in place on PMOD JB, you should see BCSP link establishment packets appearing in the microcom program which normally shows the RISCV serial output. Exiting this program will allow hciattach to be run, e.g.

    hciattach ttyUSB0 bcsp

This will connect the Bluetooth module into the bluez kernel function in Linux. It should be possible to pair and connect to eligible devices. However these pairings will not be remembered by the RISCV Linux when it runs later.
