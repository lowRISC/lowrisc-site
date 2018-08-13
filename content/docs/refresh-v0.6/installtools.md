+++
Description = ""
date = "2018-01-11T13:00:00+00:00"
title = "Install FPGA and simulation tools"
parent = "/docs/ethernet-v0.6/environment/"
showdisqus = true

+++

This part is similar to the previous tutorial, simply perform those steps (a newer Vivado is needed):

 * [Install Xilinx Vivado] ({{<ref "xilinx.md">}})
 * [Install Verilator] ({{<ref "verilator.md">}})

The above procedure may change your LD_LIBRARY_PATH to an older version of libraries than some systems expect. If this
happens, you may get a message such as:

* awk: symbol lookup error: awk: undefined symbol: mpfr_z_sub

A work-around is to manually execute `unset LD_LIBRARY_PATH` afterwards before installing the cross-compiler.

To use JTAG with the Digilent board you must install the drivers as follows (this one-off step might have to be performed by an administrator):

cd /opt/Xilinx/Vivado/2018.1/data/xicom/cable_drivers/lin64/install_script/install_drivers
sudo sh install_digilent.sh

After this step the Digilent board should be unplugged and plugged in again.
