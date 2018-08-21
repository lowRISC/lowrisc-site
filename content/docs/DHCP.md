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
