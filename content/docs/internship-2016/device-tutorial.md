+++
Description = ""
date = "2016-09-22T13:26:41+01:00"
title = "Extending lowRISC with new devices"
+++

In this tutorial, we will cover how to

* Add a device as an I/O slave
* Add a device as a DMA master

## Add an I/O slave device

The lowRISC chip uses NASTI-Lite (UC Berkeley implementation of AXI-Lite) as the interface for all I/O devices. The data width is 32-bits. Implement the [standard AXI4-Lite interface](http://www.xilinx.com/support/documentation/ip_documentation/ug761_axi_reference_guide.pdf "Xilinx AXI Specification") for the new device, and follow these instructions to connect it to the chip:

First, we assign an address to the new device. To do so, we open src/main/scala/Configs.scala and find the declaration of `externalIOAddrMap`. We then add the following line to the appropriate location:
```scala
entries += AddrMapEntry("devicename", MemSize(size, alignment, MemAttr(AddrMapProt.RW)))
```
Replacing devicename, size, and alignment to values that suit the new device. It may also be necessary to modify MemAttr to another value (such as AddrMapProt.RWX to allow code execution on the address).

The I/O Crossbar is implemented in SystemVerilog, so we are now finished with the Chisel (Scala) code.

Next, we can open src/main/verilog/chip\_top.sv and instantiate an nasti_channel interface:
```verilog
 nasti_channel
     #(
       .ADDR_WIDTH  ( `ROCKET_PADDR_WIDTH       ),
       .DATA_WIDTH  ( `LOWRISC_IO_DAT_WIDTH     ))
   io_yourdevice_lite();
```

Instantiate the new device and connect it with the nasti\_channel, clk and rstn signal. Find the declaration of io\_slicer and add the nasti\_channel to it by replacing an ios\_dmm device.

Increment NUM\_DEVICE by one, and set io\_crossbar.BASEx and MASKx (replace x with a number)
```verilog
defparam io_crossbar.BASEx = `DEV_MAP__io_ext_yourdevice__BASE;
defparam io_crossbar.MASKx = `DEV_MAP__io_ext_yourdevice__MASK;
```

The lowRISC chip is now connected to the new device, and can be accessed using the `DEV_MAP__io_ext_yourdevice__BASE` address declared in the file dev_map.h.

## Add a DMA master device

Despite the fact that memory bus in lowRISC uses the TileLink protocol instead 
of AXI, it is still possible to use an AXI device as a master device.  Adding 
a DMA device is a little bit harder, due to the need to instantiate a bridge 
between TileLink and AXI for each AXI master device. __Notice: The current 
bridge implementation provided by UC Berkeley restricts burst size to be 
either 1 or 8, and only INCR mode is allowed.__ The implementation of AXI we 
used was called NASTI ('Not A STandard Interface') by its authors. All future 
references to AXI use the NASTI name.

To add the device, first we add a new slot to the TileLink. Find `case TLKey("L1toL2")` in Configs.scala, and increment the nCachelessClients value by one.

Next, we need to expose pins from the Chisel code to chip_top.sv. To do this open LowRISCChip.scala, find class TopIO, and add
```scala
val nasti_yourdevice = new NastiIO()(p.alterPartial({case BusId => "mem"})).flip
```

Next, we need to connect the NASTI interface to our TileLink bus. Instantiate a converter and append to the uncached_clients list:
```scala
val axi_yourdevice = Module(new TileLinkIONastiIOConverter()(coherentNetParams))
axi_yourdevice.io.nasti <> io.nasti_yourdevice
uncached_clients :+= axi_yourdevice.io.tl
```

Now after regenerating the Verilog file from Chisel, we are able to see many
NASTI pins exposed from the Rocket module, which we can wire to our device
in chip_top.sv.

