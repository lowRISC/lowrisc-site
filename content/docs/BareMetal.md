## Build the bare-metal RISCV toolchain (slow, but userland toolchain build is no longer necessary)

    cd $TOP/rocket-chip/riscv-tools/
    bash ./build.sh

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
