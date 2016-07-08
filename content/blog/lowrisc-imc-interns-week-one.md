+++
Description = ""
date = "2016-07-07T14:23:34+01:00"
title = "lowRISC / IMC internship week one - VGA output"

+++
_Begnning on Monday, June 27th, we had a team of four University of
Cambridge undergrads begin a 10 week
internship working on the lowRISC project at the Computer Laboratory,
kindly sponsored by [IMC Financial Markets](http://www.imc.nl/) (who are also 
helping to advise this project). The team will be blogging regularly over the
course of the summer - I'll pass over to them to introduce
themselves._

After some initial brainstorming, we decided to aim to extend the
current lowRISC SoC design to enable video output, with the final goal of
playing video smoothly at a resolution of 640x480 on FPGA. The photo below 
shows the four of us (left to right: Gary Guo, Profir-Petru Pârțachi, Alistair Fisher,
Nathanael Davison).

<img src="/blog/2016/imc_lowrisc_interns_potatocam.jpg" alt="2016 lowRISC/IMC 
internship team" style="width: 450px;"/>

The final goal has been decomposed into several milestones: adding VGA
functionality to lowRISC, adding an in-memory framebuffer, implementing a
video codec for RISC-V and designing and creating a 2D accelerator to speed
up video decoding. Our plan for the augmented SoC architecture is
shown the in the diagram below:

<img src="/blog/2016/imc_lowrisc_vga_diagram_week1.png" alt="Drawing" style="width: 650px;"/>

In our first week, we've succeeded in adding VGA output to lowRISC, a
demonstration of this is shown in the video below. The demo shows lowRISC
instantiated on a Nexys4 DDR board (Artix-7) displaying a static image
that has been loaded into its BRAM. This image is read from SD card by a
bare-metal program on the RISC-V application core, which then loads it in to
the memory-mapped BRAM we hooked up to the AXI-Lite bus. The on-chip BRAM
is obviously a very limited resource, so our next step is to use the
board's DRAM to hold the framebuffer and make use of the BRAM for a
line-buffer.

<iframe width="560" height="315" src="https://www.youtube.com/embed/256wh1QOuH0" frameborder="0" allowfullscreen></iframe>

We aim to publish something every week, either in the form of a blog post
like this or as a more detailed guide showing how to repeat our work. Next
week we'll share a guide on how to enable VGA in lowRISC. By the end
of the summer, as well as a working technical demo, we will also have
produced detailed documentation on the whole process of adding a
customised accelerator to lowRISC.
