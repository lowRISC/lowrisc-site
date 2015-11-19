+++
Description = ""
date = "2015-11-09T16:15:00+01:00"
title = "Install Xilinx Vivado"
parent = "/docs/untether-v0.2/dev-env/"
next = "/docs/untether-v0.2/verilator/"
showdisqus = true

+++

### Download and install XIlinx Vivado

The Xilinx Vivado design suite can be downloaded from [http://www.xilinx.com/support/download.html](http://www.xilinx.com/support/download.html) free of charge for registered users (registration is also free). For Ubuntu Linux, we recommend downloading the "Vivado 2015.3: Full Installer For Linux Single File Download Image Including SDK" (TAR/GZIP - 6.92 GB). Please move and extract the downloaded TAR/GZIP file, then run the `xsetup` script provided by the installation image.

During the installation process, when asked for "Select Edition to Install", please choose "Vivado Design Edition". When choosing which packages to install, please add "Software Development Kit". It is not required to install Xilinx Vivado in system directories, so please choose any installation directory preferred. The installation required around 21 GB of disk space.

### License

A license is required to use the Xilinx Vivado suite. For users who bought an FPGA developement kit, such as the KC705 kit, a voucher should be enclosed. This voucher will allow the user to generate a site and device locked license (version limited as well). Such a license will allow a user to implement designs targeting the sepecific FPGA used in the developement kit, such as Kintex-7 FPGAs for the KC705 kit. This license is a version limited one. Users are allowed to install and update the Xilinx Vivado suite for one year. Once the license is expired, the old Xilinx Vivado is still usable but not updatable.

To generate a license using a voucher, login Xilinx and visit [http://www.xilinx.com/getlicense](http://www.xilinx.com/getlicense).

### Enviroment settings

Here is an example script for setting up the Xilinx Vivado suite.

    #!/bin/bash
    # source the prepared script, assume Xilinx is installed to
    # /local/tool/Xilinx
    source /local/tool/Xilinx/Vivado/2015.3/settings64.sh
    # exporting XILINX_VIVADO is required for FPGA simulation
    export XILINX_VIVADO
    # setup the license
    export XILINXD_LICENSE_FILE=/PATH/TO/LICENSE/FILE

Note to export the `XILINX_VIVADO` variable which is required by FPGA simulation.

### USB-JTAG installation

The default JTAG and configuration method for the KC705 kit is the UART-JTAG cable. A driver is needed for Vivado to utilize this cable. We recommend to use the driver packages provided by Digilent: [https://www.digilentinc.com/Products/Detail.cfm?Prod=ADEPT2](https://www.digilentinc.com/Products/Detail.cfm?Prod=ADEPT2). For 64-bit Ubuntu, please download and install the following two deb packages:

  * Adept 2.16.1 Runtime, X64 DEB
  * Adept 2.2.1 Utilities, X64 DEB

### USB-UART installation

KC705 has a Silicon Labs CP2103GM USB-to-UART bridge. To utilize this bridge, please download the driver from [http://www.silabs.com/Support%20Documents/Software/Linux_3.x.x_VCP_Driver_Source.zip](http://www.silabs.com/Support%20Documents/Software/Linux_3.x.x_VCP_Driver_Source.zip). Follow the instructions in the "CP210x_VCP_Linux_3.13.x_Release_Notes.txt" enclosed in the driver package.

The USB-UART bridge is normally shown in Ubuntu as /dev/ttyUSB0. [Screen](https://wiki.archlinux.org/index.php/Working_with_the_serial_console#Screen) or [CuteCom](http://cutecom.sourceforge.net/) can be used to connect to this console.

By default, users are not allowed to connect to /dev/ttyUSB0 due to the lack of permission. The easiest way of resolving this issue is to add yourself to the dialout group.

    sudo adduser <username> dialout