+++
date = "2015-03-23T11:45:42Z"
title = "FAQ"

+++
#### Do you have a discussion list?

  Yes, you can now [subscribe 
  to lowrisc-dev](http://listmaster.pepperfish.net/cgi-bin/mailman/listinfo/lowrisc-dev-lists.lowrisc.org) and view archives [here](http://listmaster.pepperfish.net/pipermail/lowrisc-dev-lists.lowrisc.org/).

#### Are you hiring?

We hope to put out a job advert for a new member of the team at the University 
of Cambridge Computer Laboratory in early 2016. Interested applicants are 
encouraged to make informal enquiries about the post to Rob Mullins 
<Robert.Mullins@cl.cam.ac.uk>.

#### Are contract or remote working arrangements on offer?

  We are not currently looking for contract or remote workers, but may in the 
  future. If we do, we'll advertise via this website and the announcement 
  list.

#### What are the goals of the project?

*   To create a fully open SoC and low-cost development board and to      support the open-source hardware community. This will involve volume      silicon manufacture.
*   To explore and promote novel hardware security features
*   To make it simple for existing companies and especially semiconductor      startups to create derivative designs, e.g. by sharing scripts, tools,      source and our experience
*   To create a benchmark design to aid academic research

#### When can I buy a lowRISC SoC?

  As with most tech projects, the most accurate answer is "When it's ready". 
  However, it's useful to consider some of the main milestones:

*   _Release of an initial FPGA version:_ Done! See the [tagged memory 
release]({{< ref "docs/tagged-memory-v0.1/index.md" >}}) and the [untethered 
release]({{< ref "docs/untethered-v0.2/index.md" >}}).
*   _Production of a test chip:_ we expect to tape out a test chip during the 
course of 2016.
*   _Tape out of production silicon:_ this is likely to happen, at      the earliest, a year after the first test chip (in 2017).

#### Why RISC-V and not OpenRISC/SPARCv8/MIPS/...?

  We considered two aspects when surveying the potentially instruction set 
  architectures (ISAs), firstly the features of the ISA itself and secondly 
  the existence of high performance designs. RISC-V is a 64-bit, 
  contemporary clean-sheet design. Implementations exist in an open-source 
  HDL (Chisel) and multiple high performance test chips have been produced, 
  at 45 and 28nm. When performing this survey, the requirement that the ISA 
  be freely implementable rules out most ISAs currently used by the 
  industry. We did consider using older versions of commercial ISAs (i.e. 
  versions where all relevant patents would have expired), but this raises 
  the issue of how to go about bringing them up to date. To avoid legal 
  uncertainty, we would have to make arbitrarily different choices to the 
  original vendor, which means compatibility would be lost.

#### What features and peripherals will the SoC have?

  We'll distribute draft specifications as soon as is reasonable. The plan 
  is to share as much as possible as early as possible.

#### How will your designs be licensed?

  A permissive open-source license.

#### How is this different to Raspberry Pi?

  Our goals and focus are quite different. The Raspberry Pi exists to 
  improve computer science education worldwide. A fully open-source SoC is 
  not necessary to reach this goal, or even a pragmatic way of achieving it 
  given the timescales involved. While it is an ultimate goal to support all 
  the features of a modern commercial SoC, it will require a number of 
  iterations of the design to achieve this. For example, early versions of 
  our SoC will not include a GPU.

#### What is your relationship to Raspberry Pi?

  We know the team well but this is a completely independent project.
  Robert co-founded Raspberry Pi, while Alex is a contributor since the very 
  early days of the project.

#### What level of performance will it have?

  To run Linux "well". The clock rate achieved will depend on the technology 
  node and particular process selected. As a rough guide we would expect 
  ~0.5-1GHz at 40nm and ~1.0-1.5GHz at 28nm.

#### Is volume fabrication feasible?

  Yes. There are a number of routes open to us. Early production runs are 
  likely to be done in batches of ~25 wafers. This would yield around 
  100-200K good chips per batch. We expect to produce packaged chips for 
  less than $10 each. 

#### How can I contribute?

  In the coming months we will be launching mailing lists, a Wiki and of 
  course a source code repository to publicly coordinate development of the 
  project. This will include both hardware and software work. We hope to 
  have interesting, evidence-backed debates about implementation options out 
  in the open.
  
