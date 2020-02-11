### Build the buildroot

buildroot manages the building of kernels, bootloader, host and debug tools, and the root filing system, as follows:

    make buildroot

The generated output is located inside `buildroot-2019.11-1-lowrisc` et al.
This will take some time (an hour or more depending on your computer).

Note that there are actually two buildroots, a rescuefs that generates the rescue tools (fsck etc),
and mainfs which has the main filing system, and a kernel which requires the rescue root filing system.

Hence the rescuefs contains the vanilla kernel and the mainfs contains the rescue kernel.

The rescue kernel should be used if an error occurs which cannot be fixed while the disk is mounted. It allows
the disk to be opened without mounting by using a rootfs image from the QSPI memory.

The buildroot system does not require an external toolchain, this will be built by itself.
buildroot itself also does not require super-user privileges, however it will be difficult to format the SD-Card
with the resulting image without it.

If you need to start modifying source code, buildroot does not manage the dependencies for you.
If you are unable to find a suitable command in the buildroot documentation, the over-arching command:

    make buildroot-clean

will start the process from scratch.

Continue the process below:

* [Produce an FPGA Bitstream] ({{< ref "docs/generate-the-bitstream.md">}})
