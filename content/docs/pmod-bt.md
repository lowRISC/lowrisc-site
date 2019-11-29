+++
Description = ""
date = "2019-06-24T00:00:00+00:00"
title = "Configure the PMOD-BT"
parent = "/docs/ariane-v0.7/"
showdisqus = true

+++

### PMOD-BT introduction

This module is described [here](https://reference.digilentinc.com/reference/pmod/pmodbt2/start). Internally it uses a  [RN42 module] (http://ww1.microchip.com/downloads/en/devicedoc/rn-42-ds-v2.32r.pdf) which in turn uses a CSR BC04EXT. It comes with a serial port profile (SPP) stack running on the Bluetooth chip. This needs to be disabled to get access to the host command interface (HCI) mode. The mode of operation is determined py persistent store keys in pages two and three of the flash memory. This memory is accessible via the serial peripheral interface (SPI) of the chip which requires a separate header to be soldered onto the module, a relatively easy job. This protocol makes use of three input (CLK,CS,MOSI) and one output wire (MISO). The FT2232 USB to UART converter has a bit-banged mode which is suitable for this job, but unfortunately the way it is buffered makes it impossible to get access to more than 2 output in bit-bang mode. The [ft2232c_ila project](https://github.com/jrrk2/ft2232c_ila.git) works around this problem using tunnelling through the UART pins. After using this mode the USB connector has to be unplugged before the UART driver will work again.




