+++
Description = ""
date = "2015-04-14T13:26:41+01:00"
title = "DHCP configuration"

+++

## Why DHCP ?

A powerful but confusing feature for new users is the Ethernet interface available on the FPGA board. The good news is that the infrastructure designed to manage PCs can work equally well for FPGA boards. If you have a home hub or network address translation zone associated with your development environment it should be sufficient to simply plug the FPGA board into your 100BaseT hub and reset (having followed the previous advice to install the bitstream in quad-spi memory). A DHCP server will supply hard to remember and possibly regularly changing information to your boot loader and Linux:

  1. The IP address to be used
  2. The Netmask to be used
  3. The default route gateway (to allow you to talk to the internet)
  4. Caching Name servers
  5. A subsequent server for NFS booting and other goodies


If the Ethernet is unplugged or incapable of 100BaseT-DX operation, the display will likely stick after 'Waiting for DHCP_OFFER'.

## Direct cable connection

If you use a direct cable (recommended if you are experimenting), connect with your own PC's Ethernet port.
This could be a development workstation if you have a second Ethernet card fitted, or a laptop with Wifi and Ethernet.
You need to install isc-dhcp-server (or similar) and create a config which includes the following (for example):

    # This is a very basic subnet declaration.

    subnet 192.168.0.0 netmask 255.255.255.0 {
      range 192.168.0.100 192.168.0.127;
      option routers 192.168.0.53;
    }

    # Configuration assuming switch 15:12 is binary 0100
    
    host lowrisc {
      hardware ethernet ee:e1:e2:e3:e4:e4;
      fixed-address 192.168.0.51;
    }

An FPGA booted with this configuration will only be able to see your own PC by default. Forwarding of packets is possible but outside the scope of this tutorial.

## Institutional LAN connection

This option is the option that talks to your institution IT infrastructure. For security reasons you will need to request that the MAC address be registered as valid centrally. Emphasize that it is a locally administered value and not a registered company value.

The use of the DIP switches 15:12 on the FPGA card allows up to 16 different boards to be used. The least significant nibble of the MAC address will be influenced. This value may be changed in the source code if your organisation has a globally valid range of MAC addresses assigned by: (https://standards.ieee.org/products-services/regauth/index.html).

You should ensure that nobody else on the same VLAN (or your entire site if you aren't sure if VLANs are in use) is making use of the same range. It is a good idea to avoid changing the MAC address after powering up on a certain network port. Otherwise your router may decide you are a bad actor and refuse to talk to you.

If VLANs are in use there could be delays or retries needed to talk to a newly configured target.

Forwarding of packets to the internet will normally be handled automatically and the replies routed back to the FPGA. Incoming session initiation will most likely be blocked by default.

## Broadband network address translation hub

This option will have one internet facing IP address (which may change at any arbitrary moment, but usually not more than once/day) and several port which are in the private range 192.168.x.x and/or 10.x.x.x

Usually registration of the MAC address is not necessary, but you can fix the value in a manufacturer specific manner in the hub control panel, and this is usually more convenient than a random value. No particular effort is needed to route packets to the internet or get the responses. Protocols that require the IP address to be passed in the packet in ASCII can go wrong when NAT is used, but in my experience this is a rare occurence.

## Static IP

Because of the flexibility of DHCP, and the lack of a user interface on the FPGA board, it was decided not to offer static IP as an option on this release. If a static address is required, it can be offered via DHCP (recommended usage).

It is suggested you proceed to the link below (or for development purposes, checkout the alternative targets)

* [Developing BareMetal tool chain] ({{< ref "docs/build-bare-metal-toolchain.md">}})
