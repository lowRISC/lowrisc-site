+++
Description = ""
date = "2016-09-22T13:26:41+01:00"
title = "Extending the video accelerator to add custom stream processors"
+++

This tutorial will cover:

 *  Adding a new stream processor to the Video Accelerator infrastructure.
 *  Exposing the new instruction to the user.

## Adding a new stream processor
A stream processor has to be able to take a AXI4-Stream channel as input, process the data and output back to a AXI4-Stream channel as these are the only Input/Output options provided to it within the Video Accelerator infrastructure. 

Let us assume that we wish to add
```sv
stream_processor processor(
   .aclk(aclk),
   .aresetn(aresetn),

   .in_ch(to_processor_ch),
   .out_ch(from_processor_ch)
);
```
Open the Accelerator System Verilog file: video_acc.sv.
This snippet will be added at the end of the module.

However, it is missing the input/output. For that we need to declare the input and output channels:
```sv
// Make sure to add at the top of the file
nasti_stream_channel # (
   .DATA_WIDTH(DATA_WIDTH),
   .DEST_WIDTH(DEST_WIDTH)
) to_processor_ch(), from_processor_ch();
```
And add them to the mux and demux
```sv
nasti_stream_combiner #(
   .N_PORT(NR_FUN_UNITS + 1)
) glue(
   .slave(out_vein_ch),
   .master_0(routed_ch),
   .master_1(from_dct_ch),
   .master_2(from_idct_ch),
   .master_3(from_yuv422to444_ch),
   .master_4(from_yuv444toRGB_ch),
   .master_5(from_processor_ch),// Change a dummy_ch to your 'from' channel
   .master_6(dummy_ch),
   .master_7(dummy_ch)
);

nasti_stream_slicer #(
      .N_PORT(NR_FUN_UNITS + 1)
)  unglue(
   .master(in_vein_ch),
   .slave_0(output_buf_ch),
   .slave_1(to_dct_ch),
   .slave_2(to_idct_ch),
   .slave_3(to_yuv422to444_ch),
   .slave_4(to_yuv444toRGB_ch),
   .slave_5(to_processor_ch),// Change a dummy_ch to your 'to' channel
   .slave_6(dummy_ch),
   .slave_7(dummy_ch)
 );
```
**Make a note of which master/slave you add your channels to as you will need this later.**

Your accelerator will receive an 8-bit *t_user*. The format of these bits depends on yourself, but a common use is to have 1-bit as the "chain" bit. If the bit is high, you can set *t_dest* to a non-zero value which matches the number of stream processor you wish to chain to.

You need to increase NR_FUN_UNITS by one after wiring, and now your stream processor can be utilized via our SPA infrastructure.

## Exposing the new instruction to the user

### Bare metal
To expose the instruction to the user in bare metal we need to:
Open videox.c and update
```C
#define FUNC_MAX 3
```
to the value of NR_FUN_UNITS.

Then we need to open videox.h and add
```C
#define FUNC_YOUR_OP 5
```
to allow easier use of the new operation.

Now you can use your accelerator using our provided *videox.h* interface.

### Linux Driver
Open videox.c and update
```c
#define NR_FUN_UNITS 3
```
to the value of NR_FUN_UNITS.
