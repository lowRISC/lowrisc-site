+++
Description = ""
date = "2016-07-08T11:00:00+00:00"
title = "How to add a new peripherial"
parent = "/docs/debug-v0.3/"
prev = "/docs/debug-v0.3/soc_struct/"
next = "/docs/debug-v0.3/release/"
showdisqus = true

+++

This document details the steps needed to add a second BRAM on the IO NASTI 
bus.

### A secondary BRAM

Below is the top-level connection of the BRAM to be added.

    module nasti_bram (
	  input  clk, rstn,
	  nasti_channel.slave nasti
    );

### Modify the global address map

Assuming the BRAM is 128KB and is readable, writable but not executable, we add a new entry named "extra_bram" into the address map at `$TOP/src/main/scala/Configs.scala`:

    # In class BaseConfig extends Config (
    
      if (site(UseSPI)) {
        entries += AddrMapEntry("spi", MemSize(1<<13, 1<<13, MemAttr(AddrMapProt.RW)))
        Dump("ADD_SPI", true)
      }
      
    + entries += AddrMapEntry("extra_bram", MemSize(1<<17, 1<<17, MemAttr(AddrMapProt.RW)))
      
      new AddrMap(entries)

This should result in two extra macros defined in `dev_map.h`:

    #define DEV_MAP__io_ext_extra_bram__BASE 0x40020000
    #define DEV_MAP__io_ext_extra_bram__MASK 0x1ffff

### Connect the BRAM to the IO NASTI bus.

Finally, we need to add the BRAM in the SystemVerilog top-level connection at `$TOP/src/main/verilog/chip_top.sv`:

    +   // secondary BRAM
    +  
    +   nasti_channel
    +     #(
    +     .ADDR_WIDTH  ( `ROCKET_PADDR_WIDTH       ),
    +     .DATA_WIDTH  ( `LOWRISC_IO_DAT_WIDTH     ))
    +   io_extra_bram_lite();
    +   
    +   nasti_bram extra_bram
    +     (
    +      .*,
    +      .nasti ( io_extra_bram_lite )
    +     );
    +   
        /////////////////////////////////////////////////////////////
        // IO crossbar
     
    -   localparam NUM_DEVICE = 4;
    +   localparam NUM_DEVICE = 5;
     
        // output of the IO crossbar
        nasti_channel
          #(
            .N_PORT      ( NUM_DEVICE                ),
            .ADDR_WIDTH  ( `ROCKET_PADDR_WIDTH       ),
            .DATA_WIDTH  ( `LOWRISC_IO_DAT_WIDTH     ))
        io_cbo_lite();
     
    -   nasti_channel ios_dmm4(), ios_dmm5(), ios_dmm6(), ios_dmm7(); // dummy channels
    +   nasti_channel ios_dmm5(), ios_dmm6(), ios_dmm7(); // dummy channels
     
        nasti_channel_slicer #(NUM_DEVICE)
        io_slicer (.s(io_cbo_lite), .m0(io_host_lite), .m1(io_uart_lite), .m2(io_spi_lite),
    -              .m3(io_bram_lite), .m4(ios_dmm4), .m5(ios_dmm5), .m6(ios_dmm6), .m7(ios_dmm7));
    +              .m3(io_bram_lite), .m4(io_extra_bram_lite), .m5(ios_dmm5), .m6(ios_dmm6), .m7(ios_dmm7));
     
        // the io crossbar
        nasti_crossbar
          #(
            .N_INPUT    ( 1                     ),
            .N_OUTPUT   ( NUM_DEVICE            ),
            .IB_DEPTH   ( 0                     ),
            .OB_DEPTH   ( 1                     ), // some IPs response only with data, which will cause deadlock in nasti_demux (no lock)
            .W_MAX      ( 1                     ),
            .R_MAX      ( 1                     ),
            .ADDR_WIDTH ( `ROCKET_PADDR_WIDTH   ),
            .DATA_WIDTH ( `LOWRISC_IO_DAT_WIDTH ),
            .LITE_MODE  ( 1                     )
            )
        io_crossbar
          (
           .*,
           .s ( io_lite     ),
           .m ( io_cbo_lite )
           );
     
      `ifdef ADD_HOST
        defparam io_crossbar.BASE0 = `DEV_MAP__io_ext_host__BASE ;
        defparam io_crossbar.MASK0 = `DEV_MAP__io_ext_host__MASK ;
      `endif
     
      `ifdef ADD_UART
        defparam io_crossbar.BASE1 = `DEV_MAP__io_ext_uart__BASE;
        defparam io_crossbar.MASK1 = `DEV_MAP__io_ext_uart__MASK;
      `endif
     
      `ifdef ADD_SPI
        defparam io_crossbar.BASE2 = `DEV_MAP__io_ext_spi__BASE;
        defparam io_crossbar.MASK2 = `DEV_MAP__io_ext_spi__MASK;
      `endif
     
      `ifdef ADD_BRAM
        defparam io_crossbar.BASE3 = `DEV_MAP__io_ext_bram__BASE;
        defparam io_crossbar.MASK3 = `DEV_MAP__io_ext_bram__MASK;
      `endif
      
    +   defparam io_crossbar.BASE4 = `DEV_MAP__io_ext_extra_bram__BASE;
    +   defparam io_crossbar.MASK4 = `DEV_MAP__io_ext_extra_bram__MASK;

That's it! Now the secondary BRAM should be ready for use.
