+++
Description = ""
date = "2015-12-17T17:00:00+00:00"
title = "Install Xilinx Vivado"
parent = "/docs/refresh-v0.6"
showdisqus = true

+++

### Download and install Xilinx Vivado

The Xilinx Vivado design suite can be downloaded from [http://www.xilinx.com/support/download.html](http://www.xilinx.com/support/download.html) free of charge for registered users (registration is also free). For this release, we only recommend Vivado 2018.1. The version used in previous releases 2015.4 is known NOT to work on this release.
During the installation process, when asked for "Select Edition to Install", 
please choose "Vivado Design Edition". When choosing which packages to 
install, please add "Software Development Kit". It is not required to install 
Xilinx Vivado in system directories, so choose any installation directory 
preferred. The installation requires up to 30 GB of disk space.

The default location is /opt/Xilinx and this will be the location referred to in the tutorial.
Typically /opt will be on the relatively small root partition of the computer, so it is necessary
to make a symbolic link to a larger disk (which could be a server), for example:

      cd /opt
      sudo ln -s /local/scratch/Xilinx .

### License

A license is required to use the Xilinx Vivado suite. For users who bought an 
FPGA development kit, such as the KC705 kit, a voucher may be enclosed. This 
voucher will allow the user to generate a site and device locked license 
(version limited as well). Such a license will allow a user to implement 
designs targeting the sepecific FPGA used in the development kit, such as 
Kintex-7 FPGAs for the KC705 kit. This license is a version limited one. Users 
are allowed to install and update the Xilinx Vivado suite for one year. Once 
the license is expired, the old Xilinx Vivado is still usable but not 
updateable.

For users of low-end boards, such as the NEXYS4-DDR, you can apply a free 
WebPACK license which allows implementations targeting certain Artix-7, 
Kintex-7 and Zynq-7000 FPGAs 
[[vivado-webpack](http://www.xilinx.com/products/design-tools/vivado/vivado-webpack.html)].

To generate a license using a voucher or a WebPACK license, login to Xilinx 
and visit 
[http://www.xilinx.com/getlicense](http://www.xilinx.com/getlicense).

Academic users can obtain licenses for all devices for research purposes via Europractice (in Europe)
or equivalent schemes.

### Future Board options

KC705 support is unbundled in this release, because it is incomplete.
For further details, checkout the kc705_mii branch.

In future we intend to support the ArtyA7-100 which is cheaper and has a larger DDR3 ram than
the Nexys4DDR. However it requires a separate PMOD if you want to use the SD-Card support.
For the latest status, checkout the artya7_mii branch.

### Environment settings

Here is an example script for setting up the Xilinx Vivado suite.

    #!/bin/bash
    # source the prepared script, assume Xilinx is installed to
    # /local/tool/Xilinx
    source /local/tool/Xilinx/Vivado/2015.4/settings64.sh
    # exporting XILINX_VIVADO is required for FPGA simulation
    export XILINX_VIVADO
    # setup the license
    export XILINXD_LICENSE_FILE=/PATH/TO/LICENSE/FILE

Note to export the `XILINX_VIVADO` variable which is required by FPGA simulation.

### USB-JTAG installation

The default JTAG and configuration method for both the KC705 and the 
NEXYS4-DDR kits is the UART-JTAG cable. A driver is needed for Vivado to 
utilize this cable. We recommend to use the [driver packages provided by 
Digilent](https://reference.digilentinc.com/reference/software/adept/start).  
For 64-bit Ubuntu, please download and install the following two deb packages:

  * Adept 2.16.1 Runtime, X64 DEB
  * Adept 2.2.1 Utilities, X64 DEB

### USB-UART installation

The KC705 has a Silicon Labs CP2103GM USB-to-UART bridge. To utilize this 
bridge, please download the driver from 
[http://www.silabs.com/Support%20Documents/Software/Linux_3.x.x_VCP_Driver_Source.zip](http://www.silabs.com/Support%20Documents/Software/Linux_3.x.x_VCP_Driver_Source.zip).  
Follow the instructions in the "CP210x_VCP_Linux_3.13.x_Release_Notes.txt" 
enclosed in the driver package.

The FTDI USB-UART bridge chip used on NEXYS4-DDR is supported in Ubuntu 14.04 and does not require extra driver installation.

The USB-UART bridge is normally shown in Ubuntu as /dev/ttyUSB0 ~ /dev/ttyUSB3. [Microcom](http://manpages.ubuntu.com/manpages/lucid/man1/microcom.1.html), [CuteCom](http://cutecom.sourceforge.net/) or [Screen](https://wiki.archlinux.org/index.php/Working_with_the_serial_console#Screen) can be used to connect to this console.

    microcom -p /dev/ttyUSB0 -s 115200

After installing microcom you will probably want to add your username to the dialout group:

    sudo usermod -a -G dialout $USER

This takes effect at next login. To use immediately you can use:

    sudo gpasswd dialout

followed by (your old shell settings will be forgotten):

    newgrp dialout

otherwise only the super user can make use of microcom.

You might want to add the Vivado tools to your path first to keep the environment clean. This prevents system tools
from trying to use shared libraries from the (older) Vivado install. Proceed as follows if you chose the default install
location (or follow your system adminstrator instructions)

    source /opt/Xilinx/Vivado/2018.1/settings64.sh
    unset LD_LIBRARY_PATH

To use JTAG downloading with Vivado and the Digilent board you must install the drivers as follows (this one-off step might have to be performed by an administrator):

    cd /opt/Xilinx/Vivado/2018.1/data/xicom/cable_drivers/lin64/install_script/install_drivers
    sudo sh install_digilent.sh

After this step the Digilent board should be unplugged and plugged in again.

The above procedure may change your LD_LIBRARY_PATH to an older version of libraries than some systems expect. If this
happens, you may get a message such as:

* awk: symbol lookup error: awk: undefined symbol: mpfr_z_sub

A work-around is to manually execute `unset LD_LIBRARY_PATH` afterwards before installing the cross-compiler.

Continue the process below:

 * [Prepare the environment and get started]({{< ref "docs/prepare-the-environment.md" >}})
