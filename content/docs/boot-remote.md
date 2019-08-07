+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Boot remote instructions"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### Boot Linux remotely on FPGA

The previous release of lowrisc made use of a custom protocol for boot-loading, this release
uses a standard tftp (trivial file transfer protocol, not to be confused with ftp) client
which is available in the Linux distribution.
This [protocol] (https://tools.ietf.org/html/rfc1350) is very old, beware of non-standard
client extensions that could confuse our server.

Most institutional local area networks have some kind of boot protocol associated with error
recovery on PCs. It is anticipated that IT support departments will take a dim view of users
attempting to hook RISCV support into their systems. Instead we take the approach that the RISCV
FPGA apparatus is the tftp server and the Linux PC/build host is the client. This does require
the user to have knowledge of the IP address allocated to the RISCV apparatus when it boots up.

# Boot parameters

SW[3:0] Ethernet MAC address, least significant bit

| SW[7:5]             | boot mode                  |
| --------------      | :----------:               |
| 000                 | boot from external SD-Card |
| 001                 | boot from Quad-SPI memory  |
| 010                 | perform bare-metal RAM test |
| 100                 | boot from Ethernet via tftp client |
| 110                 | perform cache test program |
| 111                 | perform external keyboard test |

To provide compativility with GenesysII systems that only have 8 slide switches, designations have
changed.
This section assumes you followed the DHCP instructions earlier, in which case should have a message such as:

Hello from Ariane! Please wait a moment...  
Relocating to DDR memory  
Hello World!  
...  
TFTP boot  
MAC = eee1:e2e3e4e5  
MAC address = ee:e1:e2:e3:e4:e5.  
eth0 MAC : EE:E1:E2:E3:E4:E5  
Sending DHCP_DISCOVERY  
Waiting for DHCP_OFFER  
eth0 MAC : EE:E1:E2:E3:E4:E5  
Sending DHCP_DISCOVERY  
Waiting for DHCP_OFFER  
Sending DHCP_REQUEST  
DHCP ACK  
DHCP Client IP Address:  **128.232.60.114**  
Server IP Address:  128.232.60.8  
Router address:  128.232.60.1  
Net mask address:  255.255.252.0  
Lease time = 12h:0m:0s  
Domain = "cl.cam.ac.uk"  
Client Hostname = "lowrisc5-sm"

The response to a tftp put request will be as follows:

    handle_wrq called.

When the tftp protocol was developed O/S interoperability was a far-off dream so by default computers would talk to each other via ASCII. You must choose binary/also known as octet mode for booting lowRISC. If you attempt to upload not in binary mode, the following message will be seen.

    Only octet mode is supported (client specified netascii)

# MD5 checksumming

TFTP uses UDP(user datagram protocol) packets which do not have sophisticated error recovery.
To provide extra security against corruption the entire payload is checksummed against its own filename. This provision overcomes the lack of a specific protocol for checksumming. All build scripts
provided by lowRISC for this purpose will have the appropriate renaming built-in. In the event of
an error, the following message will be given:

    handle_wrq called.
    wrq: "e8420975ca1b26a1ee05a81505844d96", blocksize=512
    021040 Receive file end (blocks = 21041, crc err = 0, fram err = 0)
    File length = 10772328
    md5(81000000,10772328) = 28bb60655e8bbc48cde7405f28c3da8d
    Aborting boot, expected hash value e8420975ca1b26a1ee05a81505844d96

Otherwise the log will look similar to the following:

    handle_wrq called.
    wrq: "e8420975ca1b26a1ee05a81505844d96", blocksize=512
    021040 Receive file end (blocks = 21041, crc err = 0, fram err = 0)
    File length = 10772328
    md5(81000000,10772328) = e8420975ca1b26a1ee05a81505844d96
    load elf to DDR memory
    Section[0]: elfn(80000000,0x1000,0x70c8);
    Section[1]: elfn(80008000,0x9000,0x1061);
    memset(80009061,0,0xa027);
    Section[2]: elfn(80200000,0x200000,0x842f2c);
    Boot the loaded program at address 80000000...

culminating after numerous messages with:

    Debian GNU/Linux 10 lowrisc5.sm hvc0

    lowrisc5 login: 

* [Booting the kernel from QSPI memory] ({{< ref "docs/boot-qspi.md">}})
* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})

