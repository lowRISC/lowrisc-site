+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Boot remote instructions"
parent = "/docs/fpga-v0.6/"
showdisqus = true

+++


### Boot Linux remotely on FPGA

You should have examples of remote booting in the Makefile known as etherlocal and etherremote.

Modify or duplicate these examples to reflect your local network topology, then

    cd $TOP/fpga/board/nexys4_ddr

The remote downloader should be built (first time only)

    make -C ../../common/script

This section assumes you followed the DHCP instructions earlier, in which case should have a message such as:

    Hello LowRISC! Mon Aug 13 08:56:12 2018: Booting from Ethernet because SW2 is high ..
    MAC = eee1:e2e3e4e5
    MAC address = ee:e1:e2:e3:e4:e5.
    eth0 MAC : EE:E1:E2:E3:E4:E5
    Sending DHCP_DISCOVERY
    Waiting for DHCP_OFFER
    Sending DHCP_REQUEST
    DHCP ACK
    DHCP Client IP Address:  128.232.60.114 (NOTE THIS VALUE)
    Server IP Address:  128.232.60.9
    Router address:  128.232.60.1
    Net mask address:  255.255.252.0
    Lease time = 43200
    domain = "cl.cam.ac.uk"
    server = "lowrisc5-sm"

The user should type the following at this point:

    export IP=128.232.60.114 # or whatever value you noted above
    ../../common/script/recvRawEth -r -s $IP boot.bin

This functionality is the same as the 'make etherlocal' option

It is convenient for development to work always from a development version of the kernel.
But if the kernel only changes infrequently, it might be preferable to update on the live
system as shown at the following link:

* [Updating the kernel on a running system] ({{< ref "docs/update-running-kernel.md">}})

